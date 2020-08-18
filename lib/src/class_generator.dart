import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/managed_object_set.dart';
import 'package:postgres_to_orm/models/model_class_set.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';

class ClassGenerator {
  final BuildConfiguration config;
  final List<Table> tableList;

  ClassGenerator({
    @required this.config,
    @required this.tableList,
  });

  List<ManagedObjectSet> generateManagedObjectClass() {
    var managedObjectList = <ManagedObjectSet>[];
    for (var table in tableList) {
      // Logger.root.info('~~~ Processing: ${table.managedObjectName}');

      final managedObject = Class((builder) {
        var clasbuilder = builder
          ..name = table.managedObjectName
          ..extend = refer('ManagedObject<${table.modelName}>')
          ..implements.add(refer(table.modelName));

        return clasbuilder;
      });

      final emitter = DartEmitter();
      final formated = DartFormatter().format('${managedObject.accept(emitter)}');
      managedObjectList.add(ManagedObjectSet(table.name, formated));

      Logger.root.info('~~~ Completed: ${table.managedObjectName}');
    }

    return managedObjectList;
  }

  Future<List<ModelClassSet>> generateModelClass() async {
    var modelClassList = <ModelClassSet>[];

    for (var table in tableList) {
      // Logger.root.info('~~~ Processing: ${table.modelName}');

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
      modelClassList.add(ModelClassSet(table.name, formated));
      Logger.root.info('~~~ Completed: ${table.modelName}');
    }

    return modelClassList;
  }
}
