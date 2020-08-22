import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/controller.dart';
import 'package:postgres_to_orm/models/controller_class.dart';
import 'package:postgres_to_orm/models/managed_object_set.dart';
import 'package:postgres_to_orm/models/model_class_set.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';
import 'package:postgres_to_orm/src/extensions.dart';

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
        builder
          ..name = table.managedObjectName
          ..extend = refer('ManagedObject<${table.modelName}>')
          ..implements.add(refer(table.modelName));

        return builder;
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

          if (relate.relateSymbol != null) {
            fieldBuilder..annotations.add(refer('Relate(#${relate.relateSymbol})'));
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

  // Generate Controller Class as Formated String
  Future<List<ControllerClass>> generateControllerClass() async {
    var controllerClassList = <ControllerClass>[];

    for (var table in tableList) {
      var classContent = '';

      var controller = generateController(table);
      var controllerClass = Class((builder) {
        builder
          ..name = controller.name
          ..extend = refer('ResourceController');

        for (var controllerMethod in controller.methods) {
          //* get, post, put, delete,..
          var _method = Method((m) {
            m.annotations.add(refer(controllerMethod.operation.toString()));
            m.name = controllerMethod.name;
            m.returns = refer('Future<Response>');
            m.modifier = MethodModifier.async;
            m.body = Code('return Response.ok("");');

            for (var methodParameter in controllerMethod.parameterList) {
              //* (Bind.path(id) int Id)
              if (methodParameter.parameterName != null) {
                var parameter = Parameter((p) {
                  p.name = methodParameter.parameterName;
                  p.annotations.add(refer(methodParameter.bind.toString()));
                  p.type = refer(methodParameter.parameterType);

                  return p;
                });

                m.requiredParameters.add(parameter);
              }
            }
            return m;
          });
          builder.methods.add(_method);
        }

        return builder;
      });

      final emitter = DartEmitter();
      classContent += '${controllerClass.accept(emitter)}';
      final formated = DartFormatter().format(classContent);

      controllerClassList.add(ControllerClass(tableName: table.name, controller: formated));
    }

    return controllerClassList;
  }

  Controller generateController(Table table) {
    var operationMethodList = <OperationMethod>[];

    if (table.primarColumn != null) {
      //* Get All
      var getAll = OperationMethod(
        name: 'getAll' + table.name.pascalCase.pluralize,
        operation: Operation.getAll(),
      );
      operationMethodList.add(getAll);

      //* Get Single
      var getSingle = OperationMethod(
          name: 'get' + table.name.pascalCase + 'ByID',
          operation: Operation.getSingle(table.primarColumn.name.camelCase),
          parameterList: [
            MethodParameter(
              bind: Bind.path(table.primarColumn.name),
              parameterType: table.primarColumn.dataType,
              parameterName: table.primarColumn.name.camelCase,
            )
          ]);
      operationMethodList.add(getSingle);

      //* Post
      var post = OperationMethod(name: 'add' + table.name.pascalCase, operation: Operation.post(), parameterList: [
        MethodParameter(
          bind: Bind.body(),
          parameterName: table.name.camelCase,
          parameterType: table.name.pascalCase,
        )
      ]);
      operationMethodList.add(post);

      //* put
      var put = OperationMethod(
        name: 'update' + table.name.pascalCase,
        operation: Operation.put(table.primarColumn.name.camelCase),
        parameterList: [
          MethodParameter(
            bind: Bind.path(table.primarColumn.name),
            parameterType: table.primarColumn.dataType,
            parameterName: table.primarColumn.name.camelCase,
          ),
          MethodParameter(
            bind: Bind.body(),
            parameterName: table.name.camelCase,
            parameterType: table.name.pascalCase,
          )
        ],
      );
      operationMethodList.add(put);

      //* delete
      var delete = OperationMethod(
        name: 'delete' + table.name.pascalCase,
        operation: Operation.delete(table.primarColumn.name.camelCase),
        parameterList: [
          MethodParameter(
            bind: Bind.path(table.primarColumn.name),
            parameterType: table.primarColumn.dataType,
            parameterName: table.primarColumn.name.camelCase,
          )
        ],
      );
      operationMethodList.add(delete);
    }

    var controller = Controller(name: table.name.pascalCase + 'Controller', methods: operationMethodList);

    return controller;
  }
}
