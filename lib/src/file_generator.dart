import 'dart:io';

import 'package:postgres_to_orm/models/controller_class.dart';
import 'package:postgres_to_orm/src/extensions.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/managed_object_set.dart';
import 'package:postgres_to_orm/models/model_class_set.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';
import 'package:path/path.dart' as p;

class FileGenerator {
  final BuildConfiguration configuration;

  FileGenerator(this.configuration);

  Future<bool> generateEntityFile({
    @required BuildConfiguration config,
    @required List<Table> tableList,
    @required List<ManagedObjectSet> managedObjectSetList,
    @required List<ModelClassSet> modelClassSetList,
    String packageName,
    String entityPath,
  }) async {
    packageName = packageName ?? config.pubspec.name;
    entityPath = (entityPath ?? config.entityPath);

    var outputDirectory = Directory(entityPath);
    if (await outputDirectory.exists() == false) {
      await outputDirectory.create(recursive: true);
    }

    //* Package import reference
    var packageImport = "import 'package:${packageName}/${packageName}.dart';";

    for (var table in tableList) {
      var fileContent = '';

      fileContent += packageImport;

      //* Import References
      var importFileNameListFromRelate = table.relateList.map((e) => e.importFileName).toList();
      var importFileNameListFromManagedSet = table.managedSetList.map((e) => e.importFileName).toList();
      var imporList = [...importFileNameListFromRelate, ...importFileNameListFromManagedSet]..toSet().toList();

      for (var importFile in imporList) {
        //* Check for self referencing
        if (importFile != table.name.removeFirstUnderscore.toLowerCase()) {
          var import = p.join("import 'package:${packageName}/${entityPath.replaceAll(RegExp(r'.*lib/'), '')}/", "$importFile.dart';");
          fileContent += import;
        }
      }

      //* Class contents
      fileContent += managedObjectSetList.firstWhere((element) => element.tableName == table.name, orElse: () => null)?.managedObjectClass ?? '';
      fileContent += modelClassSetList.firstWhere((element) => element.tableName == table.name, orElse: () => null)?.modelClass ?? '';

      final formated = DartFormatter().format(fileContent);

      var fileName = table.name.removeFirstUnderscore + '.dart';
      var filePath = p.join(outputDirectory.path, fileName);
      var file = File(filePath);
      await file.writeAsString(formated);

      Logger.root.info('~~~ Completed: ${fileName}');
    }

    return Future.value(true);
  }

  Future<bool> generateControllerFile({
    @required BuildConfiguration config,
    @required List<ControllerClass> controllerClassList,
    String packageName,
    String controllerPath,
    String entityPath,
  }) async {
    packageName = packageName ?? config.pubspec.name;
    controllerPath = (controllerPath ?? config.controllerPath);
    entityPath = (entityPath ?? config.entityPath);

    var outputDirectory = Directory(controllerPath);
    if (await outputDirectory.exists() == false) {
      await outputDirectory.create(recursive: true);
    }

    for (var controllerClass in controllerClassList) {
      var fileName = controllerClass.tableName.snakeCase + '_controller.dart';

      final aqueductImport = "import 'package:aqueduct/aqueduct.dart';";

      var fileContent = aqueductImport;

      var import =
          p.join("import 'package:${packageName}/${entityPath.replaceAll(RegExp(r'.*lib/'), '')}/", "${controllerClass.tableName.snakeCase}.dart';");
      fileContent += import;

      fileContent += controllerClass.controller;

      final formated = DartFormatter().format(fileContent);

      var filePath = p.join(outputDirectory.path, fileName);
      var file = File(filePath);
      await file.writeAsString(formated);

      Logger.root.info('~~~ Completed: ${fileName}');
    }

    return Future.value(true);
  }
}
