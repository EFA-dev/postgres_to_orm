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
  var log = Logger.root;
  log.level = Level.ALL;
  log.onRecord.listen((record) {
    stdout.write(colorLog(record));
  });

  log.info('*** Getting settings from "config.yaml" file ***');
  var config = BuildConfiguration('./config.yaml');
  log.info(config.dbSchema);
  log.info(config.outputPath);

  var connection = await DBConnection.createConnection(config.database);
  log.info('*** Database connection created ***');

  await connection.open();
  log.info('*** Database connection established ***');

  log.info('*** Tables are getting from database ***');
  var schemaReader = SchemaReader(config, connection);
  var tableList = await schemaReader.getTables();
  log.info('*** ${tableList.length} Table received ***');

  log.info('*** Creating ManagedObject classes ***');
  var managedObjectList = ClassGenerator.generateManagedObjectClass(tableList);
  log.info('*** ${managedObjectList.length} ManagedObject created ***');

  log.info('*** Creating Model classes ***');
  var modelList = await ClassGenerator.generateModelClass(tableList);
  log.info('*** ${modelList.length} Model Class created ***');

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
