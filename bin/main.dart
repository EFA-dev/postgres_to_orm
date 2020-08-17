import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:io/ansi.dart';
import 'package:logging/logging.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';
import 'package:postgres_to_orm/src/class_generator.dart';
import 'package:postgres_to_orm/src/db_connection.dart';
import 'package:postgres_to_orm/src/schema_reader.dart';

Future<void> main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    stdout.write(colorLog(record));
  });

  Logger.root.info('*** Getting settings from "config.yaml" file ***');
  var config = BuildConfiguration('./config.yaml');

  var connection = await DBConnection.createConnection(config.database);
  Logger.root.info('*** Database connection created ***');

  await connection.open();
  Logger.root.info('*** Database connection established ***');

  Logger.root.info('*** Tables are getting from database ***');
  var schemaReader = SchemaReader(config, connection);
  var tableList = await schemaReader.getTables();
  Logger.root.info('*** ${tableList.length} Table received ***');

  Logger.root.info('*** Creating ManagedObject classes ***');
  var managedObjectList = ClassGenerator.generateManagedObjectClass(tableList);
  Logger.root.info('*** ${managedObjectList.length} ManagedObject created ***');

  Logger.root.info('*** Creating Model classes ***');
  var modelList = await ClassGenerator.generateModelClass(tableList, schemaReader);
  Logger.root.info('*** ${modelList.length} Model Class created ***');

  await connection.close();
}

//class Article extends ManagedObject<_Article> implements _Article {}

void checkArgs(List<String> arguments) {
  var parser = ArgParser();
  parser.addFlag('verbose', defaultsTo: true, abbr: 'v');

  bool verbose = parser.parse(arguments)['verbose'];
  if (verbose) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      stdout.write(colorLog(record));
    });
  }
}

StringBuffer colorLog(LogRecord record, {bool verbose = true}) {
  AnsiCode color;
  if (record.level < Level.WARNING) {
    color = cyan;
  } else if (record.level < Level.SEVERE) {
    color = yellow;
  } else {
    color = red;
  }
  final level = color.wrap('[${record.level}]');
  final eraseLine = ansiOutputEnabled ? '\x1b[2K\r' : '';
  var lines = <Object>['$eraseLine$level ${record.message}'];

  if (record.error != null) {
    lines.add(record.error);
  }

  var message = StringBuffer(lines.join('\n'));

  // We always add an extra newline at the end of each message, so it
  // isn't multiline unless we see > 2 lines.
  var multiLine = LineSplitter.split(message.toString()).length > 2;

  if (record.level > Level.INFO || !ansiOutputEnabled || multiLine || verbose) {
    // Add an extra line to the output so the last line isn't written over.
    message.writeln('');
  }
  return message;
}
