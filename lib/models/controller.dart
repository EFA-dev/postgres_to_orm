import 'package:meta/meta.dart';
import 'package:postgres_to_orm/src/extensions.dart';

// region [p]
class Controller {
  final String name;

  final List<OperationMethod> methods;

  Controller({
    @required this.name,
    @required this.methods,
  });
}

// endregion

// region [b]

/// @Operation.get('id')
class Operation {
  //* get post put delete
  final String name;

  //* id
  final String parameter;

  String get peraperedParameter {
    return parameter != null ? "'$parameter'" : '';
  }

  Operation._({
    @required this.name,
    this.parameter,
  });

  factory Operation.getAll() => Operation._(name: 'get');
  factory Operation.post() => Operation._(name: 'post');
  factory Operation.getSingle(String parameter) => Operation._(name: 'get', parameter: parameter);
  factory Operation.put(String parameter) => Operation._(name: 'put', parameter: parameter);
  factory Operation.delete(String parameter) => Operation._(name: 'delete', parameter: parameter);

  @override
  String toString() {
    var fullName = 'Operation.$name($peraperedParameter)';
    return fullName;
  }
}

// endregion

// region [g]
//  Future<Response> getUserById(@Bind.path('id') int id) async
class OperationMethod {
  OperationMethod({
    this.name,
    this.operation,
    this.parameterList = const [],
    this.body,
  });

  //* getAllCities
  final String name;

  //* Get operation, post operation..
  final Operation operation;

  //* Method bind parameter settings
  final List<MethodParameter> parameterList;

  final String body;
}

// endregion

// region [r]

class OperationMethodBody {
  static String getAllBody(String tableName) {
    var query = tableName.camelCase + 'Query';
    var responseField = tableName.camelCase.pluralize;
    var type = tableName.pascalCase;

    return '''
    final $query = Query<${type}>(context);
    final $responseField = await $query.fetch();
    return Response.ok($responseField);
    ''';
  }

  static String getSingleById(String tableName, String primaryColumnName) {
    var query = tableName.camelCase + 'Query';
    var responseField = tableName.camelCase;
    var type = tableName.pascalCase;
    var columnName = primaryColumnName.camelCase;

    return '''
    final $query = Query<${type}>(context)..where((x) => x.$columnName).equalTo($columnName);
    final $responseField = await $query.fetchOne();
    if ($responseField == null) {
      return Response.notFound();
    }
    return Response.ok($responseField);
    ''';
  }

  static String post(String tableName) {
    var query = tableName.camelCase + 'Query';
    var type = tableName.pascalCase;
    var responseField = 'inserted' + tableName.pascalCase;
    var parameter = tableName.camelCase;
    return '''
    final $query = Query<$type>(context)..values = $parameter;
    final $responseField = await $query.insert();
    return Response.ok($responseField);
    ''';
  }

  static String put(String tableName, String primaryColumnName) {
    var query = tableName.camelCase + 'Query';
    var responseField = 'updated' + tableName.pascalCase;
    var type = tableName.pascalCase;
    var columnName = primaryColumnName.camelCase;
    var bodyParameter = tableName.camelCase;

    return '''
    final $query = Query<$type>(context)
      ..values = $bodyParameter
      ..where((x) => x.$columnName).equalTo($columnName);
    final $responseField = await $query.updateOne();
    if ($responseField == null) {
      return Response.notFound();
    }
    return Response.ok($responseField);
    ''';
  }

  static String delete(String tableName, String primaryColumnName) {
    var query = tableName.camelCase + 'Query';
    var responseField = 'deleted' + tableName.pascalCase;
    var type = tableName.pascalCase;
    var columnName = primaryColumnName.camelCase;

    return '''
    final $query = Query<$type>(context)
      ..where((x) => x.$columnName).equalTo($columnName);
    final int $responseField = await $query.delete();
    if ($responseField == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted \$$responseField $type"};
    return Response.ok(response);
    ''';
  }
}

// endregion

// region [pk]
class MethodParameter {
  final Bind bind;
  final String parameterType;
  final String parameterName;

  MethodParameter({
    @required this.bind,
    this.parameterType,
    this.parameterName,
  });
}
// endregion

// region [bl]
// @Bind.path('id')
class Bind {
  final String name;
  final String parameter;

  String get peraperedParameter {
    return parameter != null ? "'$parameter'" : '';
  }

  Bind({this.name, this.parameter});

  factory Bind.path(String parameter) => Bind(name: 'path', parameter: parameter);
  factory Bind.query(String parameter) => Bind(name: 'query', parameter: parameter);
  factory Bind.header(String parameter) => Bind(name: 'header', parameter: parameter);
  factory Bind.body() => Bind(name: 'body');

  @override
  String toString() {
    var fullName = 'Bind.$name($peraperedParameter)';
    return fullName;
  }
}

// endregion
