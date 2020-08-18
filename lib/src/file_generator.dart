import 'dart:io';

import 'package:code_builder/code_builder.dart';
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
  }) async {
    var outputDirectory = Directory(configuration.outputPath);
    if (await outputDirectory.exists() == false) {
      await outputDirectory.create(recursive: true);
    }

    var packageName = await config.packageName;

    //* Package import reference
    var packageImport = "import 'package:${packageName}/${packageName}.dart';";

    for (var table in tableList) {
      var fileContent = '';

      fileContent += packageImport;

      //* Import References
      var referansFilesFromRelate = table.relateList.map((e) => e.fileName).toList();
      var referansFilesFromManagedSet = table.managedSetList.map((e) => e.fileName).toList();
      var importList = [...referansFilesFromRelate, ...referansFilesFromManagedSet]..toSet().toList();

      for (var className in importList) {
        //* Check for self referencing
        if (className != table.name.replaceFirst('_', '').toLowerCase()) {
          var import = p.join("import 'package:${packageName}/${config.outputPath.replaceAll("lib/", '')}/", "$className.dart';");
          fileContent += import;
        }
      }

      //* Class contents
      fileContent += managedObjectSetList.firstWhere((element) => element.tableName == table.name).managedObjectClass;
      fileContent += modelClassSetList.firstWhere((element) => element.tableName == table.name).modelClass;

      final formated = DartFormatter().format(fileContent);

      var fileName = table.name.replaceFirst('_', '') + '.dart';
      var filePath = p.join(outputDirectory.path, fileName);
      var file = File(filePath);
      await file.writeAsString(formated);

      Logger.root.info('~~~ Completed: ${fileName}');
    }

    return Future.value(true);
  }
}
