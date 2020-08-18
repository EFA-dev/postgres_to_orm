import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:postgres_to_orm/models/table.dart';

class ClassGenerator {
  static List<String> generateManagedObjectClass(List<Table> tableList) {
    var managedObjectList = <String>[];
    for (var table in tableList) {
      Logger.root.info('*** Processing: ${table.managedObjectName} ***');

      final managedObject = Class((builder) {
        return builder
          ..name = table.managedObjectName
          ..extend = refer('ManagedObject<${table.modelName}>')
          ..implements.add(refer(table.modelName));
      });

      final emitter = DartEmitter();
      final formated = DartFormatter().format('${managedObject.accept(emitter)}');
      managedObjectList.add(formated);

      Logger.root.info('*** Completed: ${table.managedObjectName} ***');
    }

    return managedObjectList;
  }

  static Future<List<String>> generateModelClass(List<Table> tableList) async {
    var modelClassList = <String>[];

    for (var table in tableList) {
      var fieldList = <Field>[];

      //* Columns
      for (var column in table.columnList) {
        var normalField = Field((fieldBuilder) {
          fieldBuilder
            ..name = column.name
            ..type = refer(column.dataType);

          if (column.primaryKey) {
            fieldBuilder.annotations.add(refer('primaryKey'));
          }

          return fieldBuilder;
        });

        fieldList.add(normalField);
      }

      //* ManagedSet
      for (var managedSet in table.managedSetList) {
        var normalField = Field((fieldBuilder) {
          fieldBuilder
            ..name = managedSet.name
            ..type = refer('ManagedSet<${managedSet.typeName}>');

          return fieldBuilder;
        });

        fieldList.add(normalField);
      }

      //* Relate
      for (var relate in table.relateList) {
        var normalField = Field((fieldBuilder) {
          fieldBuilder
            ..name = relate.name
            ..type = refer('${relate.typeName}');

          if (relate.relateType != null) {
            fieldBuilder..annotations.add(refer('Relate(#${relate.relateType})'));
          }

          return fieldBuilder;
        });

        fieldList.add(normalField);
      }

      final model = Class((builder) {
        builder
          ..name = table.modelName
          ..fields.addAll(fieldList);
      });

      final emitter = DartEmitter();
      final formated = DartFormatter().format('${model.accept(emitter)}');
      Logger.root.info(formated);
      modelClassList.add(formated);
    }

    return modelClassList;
  }
}
