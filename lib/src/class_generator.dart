import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/controler_test.dart';
import 'package:postgres_to_orm/models/controller.dart';
import 'package:postgres_to_orm/models/controller_class.dart';
import 'package:postgres_to_orm/models/managed_object_set.dart';
import 'package:postgres_to_orm/models/model_class_set.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/models/test_methods.dart';
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

  List<ModelClassSet> generateModelClass() {
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

  //* Generate Controller Class
  List<ControllerClass> generateControllerClass() {
    var controllerClassList = <ControllerClass>[];

    for (var table in tableList) {
      var classContent = '';

      var controller = _generateController(table);
      var controllerClass = Class((classBuilder) {
        classBuilder
          ..name = controller.name
          ..extend = refer('ResourceController');

        //* Managed Context Field
        classBuilder.fields.add(
          Field(
            (f) {
              f.name = 'context';
              f.type = refer('ManagedContext');
              f.modifier = FieldModifier.final$;
              return f;
            },
          ),
        );

        //* Class Constructor
        classBuilder.constructors.add(
          Constructor(
            (constructor) {
              constructor.requiredParameters.add(
                Parameter(
                  (parameter) {
                    parameter.name = 'context';
                    parameter.toThis = true;
                    return parameter;
                  },
                ),
              );
            },
          ),
        );

        //* Methods get, post, put, delete,..
        for (var controllerMethod in controller.methods) {
          var _method = Method((methodBuilder) {
            methodBuilder.annotations.add(refer(controllerMethod.operation.toString()));
            methodBuilder.name = controllerMethod.name;
            methodBuilder.returns = refer('Future<Response>');
            methodBuilder.modifier = MethodModifier.async;
            methodBuilder.body = Code(controllerMethod.body ?? "");

            for (var methodParameter in controllerMethod.parameterList) {
              //* (Bind.path(id) int Id)
              if (methodParameter.parameterName != null) {
                var parameter = Parameter((p) {
                  p.name = methodParameter.parameterName;
                  p.annotations.add(refer(methodParameter.bind.toString()));
                  p.type = refer(methodParameter.parameterType);

                  return p;
                });

                methodBuilder.requiredParameters.add(parameter);
              }
            }
            return methodBuilder;
          });
          classBuilder.methods.add(_method);
        }

        return classBuilder;
      });

      final emitter = DartEmitter();
      classContent += '${controllerClass.accept(emitter)}';
      final formated = DartFormatter().format(classContent);

      controllerClassList.add(ControllerClass(tableName: table.name, controller: formated));
    }

    return controllerClassList;
  }

  Controller _generateController(Table table) {
    var operationMethodList = <OperationMethod>[];

    if (table.primarColumn != null) {
      //* Get All
      var getAll = OperationMethod(
        name: 'getAll' + table.name.pascalCase.pluralize,
        operation: Operation.getAll(),
        body: OperationMethodBody.getAllBody(table.name),
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
        ],
        body: OperationMethodBody.getSingleById(table.name, table.primarColumn.name),
      );
      operationMethodList.add(getSingle);

      //* Post
      var post = OperationMethod(
        name: 'add' + table.name.pascalCase,
        operation: Operation.post(),
        parameterList: [
          MethodParameter(
            bind: Bind.body(),
            parameterName: table.name.camelCase,
            parameterType: table.name.pascalCase,
          )
        ],
        body: OperationMethodBody.post(table.name),
      );
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
        body: OperationMethodBody.put(table.name, table.primarColumn.name),
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
        body: OperationMethodBody.delete(table.name, table.primarColumn.name),
      );
      operationMethodList.add(delete);
    }

    var controller = Controller(name: table.name.pascalCase + 'Controller', methods: operationMethodList);

    return controller;
  }

  //* Generate Controler Test file
  List<TestMethods> generateTestMethods(String packageName) {
    var testMetodsList = <TestMethods>[];

    packageName = packageName ?? config.pubspec.name;

    for (var table in tableList) {
      //* Main Methods
      var mainMethod = Method((methodBuilder) {
        methodBuilder.name = 'main';
        methodBuilder.returns = Reference('void');
        final emitter = DartEmitter();

        var mainMethodBody = '';

        //* Harness Field
        var harnesField = Field((fieldbuilder) {
          fieldbuilder.name = 'harness';
          fieldbuilder.modifier = FieldModifier.final$;
          fieldbuilder.assignment = Code('Harness()..install()');
          return fieldbuilder;
        });
        mainMethodBody += harnesField.accept(emitter).toString();

        //* TearDown method
        var tearDownMethod = Method((tearDownMethodBuilder) {
          tearDownMethodBuilder.name = 'tearDown';

          tearDownMethodBuilder.requiredParameters.add(Parameter((paramBuilder) {
            var method = Method((m) {
              m.modifier = MethodModifier.async;
              m.body = Code(' await harness.resetData();');
              return m;
            });

            paramBuilder.name = method.accept(emitter).toString();
            return paramBuilder;
          }));

          return tearDownMethodBuilder;
        });

        mainMethodBody += tearDownMethod.accept(emitter).toString();

        //* All Test In Controller
        var controllerTest = _generateControllerTest(table);

        for (var testMethodGroup in controllerTest.testMethodGroupList) {
          var testGroupMethod = Method((groupMethodBuilder) {
            var groupMethodBody = '';

            for (var test in testMethodGroup.testMethodList) {
              var testMethod = Method((testMethodBuilder) {
                testMethodBuilder.name = 'test';

                var parameter = Parameter((parameterBuilder) {
                  parameterBuilder.name = '"${test.decription}", ${test.body}';
                });
                testMethodBuilder.requiredParameters.add(parameter);
                return testMethodBuilder;
              });

              groupMethodBody += testMethod.accept(emitter).toString();
            }

            groupMethodBuilder.name = 'group';
            groupMethodBuilder.requiredParameters.add(
              Parameter(
                (p) => p..name = '"${testMethodGroup.description}",(){ ${Code(groupMethodBody).toString()} }',
              ),
            );

            return groupMethodBuilder;
          });

          mainMethodBody += testGroupMethod.accept(emitter).toString();
        }

        methodBuilder.body = Code(mainMethodBody);
        return methodBuilder;
      });

      final emitter = DartEmitter();
      final formated = DartFormatter().format('${mainMethod.accept(emitter)}');
      testMetodsList.add(TestMethods(tableName: table.name, mainMethod: formated));
      Logger.root.info('~~~ Completed: ${table.modelName}');
    }

    return testMetodsList;
  }

  ControllerTest _generateControllerTest(Table table) {
    //* GET
    var getTestMetodList = <TestMethod>[];

    //* Get 200
    var get200 = TestMethod.get200(table);
    getTestMetodList.add(get200);

    //* Get 404
    var get404 = TestMethod.get404();
    getTestMetodList.add(get404);

    //* Get Single 404
    var getSingle404 = TestMethod.getSingle404(table);
    getTestMetodList.add(getSingle404);

    //* Get Single 200 After Post
    var getSingleAfterPost200 = TestMethod.getSingleAfterPost200(table);
    getTestMetodList.add(getSingleAfterPost200);

    var getGroup = TestMethodGroup(description: 'GET: ', testMethodList: getTestMetodList);

    //* POST
    var postTestMethodList = <TestMethod>[];

    //* Post Empty Body 400
    var postEmptyBody400 = TestMethod.postEmptyBody400(table);
    postTestMethodList.add(postEmptyBody400);

    //* Post Right Body 200
    var postRightBody200 = TestMethod.postRightBody200(table);
    postTestMethodList.add(postRightBody200);

    //* Post Missing Key Body 400
    var postMissingKeyBody400 = TestMethod.postMissingKeyBody400(table);
    postTestMethodList.add(postMissingKeyBody400);

    var postGroup = TestMethodGroup(
      description: 'POST: ',
      testMethodList: postTestMethodList,
    );

    //* PUT
    var putTestMethodList = <TestMethod>[];

    //* Put Empty Body 400
    var putEmptyBody400 = TestMethod.putEmptyBody400(table);
    putTestMethodList.add(putEmptyBody400);

    //* Put Right Body 200
    var putRightBody200 = TestMethod.putRightBody200(table);
    putTestMethodList.add(putRightBody200);

    var putGroup = TestMethodGroup(
      description: 'PUT: ',
      testMethodList: putTestMethodList,
    );

    //* DELETE
    var deleteTestMethodList = <TestMethod>[];

    //* Delete 200
    var delete200 = TestMethod.delete200(table);
    deleteTestMethodList.add(delete200);

    //* Delete 400
    var delete400 = TestMethod.delete400(table);
    deleteTestMethodList.add(delete400);

    //* Delete 404
    var delete404 = TestMethod.delete404(table);
    deleteTestMethodList.add(delete404);

    var deleteGroup = TestMethodGroup(
      description: 'DELETE:',
      testMethodList: deleteTestMethodList,
    );

    return ControllerTest(
      testMethodGroupList: [
        getGroup,
        postGroup,
        putGroup,
        deleteGroup,
      ],
    );
  }
}
