import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:io/ansi.dart';
import 'package:logging/logging.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';
import 'package:postgres_to_orm/src/class_generator.dart';
import 'package:postgres_to_orm/src/db_connection.dart';
import 'package:postgres_to_orm/src/file_generator.dart';
import 'package:postgres_to_orm/src/schema_reader.dart';

Future<void> main(List<String> arguments) async {
  var argResults = checkArgs(arguments);

  var log = Logger.root;

  log.info('*** Getting settings from "config.yaml" file ***');
  var config = BuildConfiguration('./config.yaml');
  var fileGenerator = FileGenerator(config);

  var connection = await DBConnection.createConnection(config.database);
  var schemaReader = SchemaReader(config, connection);

  await connection.open();
  log.info('*** Database connection established ***');

  //* Table List
  log.info('*** Tables are getting from database ***');
  var tableList = await schemaReader.getTables();
  log.info('*** ${tableList.length} Table received ***');

  var classGenerator = ClassGenerator(config: config, tableList: tableList);

  //* Managed Object Class
  log.info('*** Creating ManagedObject classes ***');
  var managedObjectSetList = classGenerator.generateManagedObjectClass();
  log.info('*** ${managedObjectSetList.length} ManagedObject created ***');

  //* Model Object Class
  log.info('*** Creating Model classes ***');
  var modelClassSetList = await classGenerator.generateModelClass();
  log.info('*** ${modelClassSetList.length} Model Class created ***');

  //* Entity File
  // log.info('*** Creating Entity Files ***');
  // var generateEntityResult = await fileGenerator.generateEntityFile(
  //   config: config,
  //   tableList: tableList,
  //   managedObjectSetList: managedObjectSetList,
  //   modelClassSetList: modelClassSetList,
  //   packageName: argResults['packageName'],
  //   outputPath: argResults['entityPath'],
  // );
  // log.info('*** ${modelClassSetList.length} Entity File created ***');

  //* Controller File
  if (config.createController) {
    log.info('*** Creating Controller Files ***');
    var controllerClassList = await classGenerator.generateControllerClass();

    var generateControllerResult = fileGenerator.generateControllerFile(
      config: config,
      controllerClassList: controllerClassList,
      packageName: argResults['packageName'],
      controllerPath: argResults['controllerPath'],
      entityPath: argResults['entityPath'],
    );
    log.info('*** ${tableList.length} Controller File created ***');
  }

  await connection.close();
}

ArgResults checkArgs(List<String> arguments) {
  var parser = ArgParser();
  parser.addFlag('verbose', defaultsTo: true, abbr: 'v');
  parser.addOption('packageName');
  parser.addOption('entityPath');
  parser.addOption('controllerPath');
  var results = parser.parse(arguments);
  bool verbose = results['verbose'];
  if (verbose) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      stdout.write(colorLog(record));
    });
  }

  return results;
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
