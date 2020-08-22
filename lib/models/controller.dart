import 'package:meta/meta.dart';

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
  //* getAllCities
  final String name;

  //* Get operation, post operation..
  final Operation operation;

  //* Method bind parameter settings
  final List<MethodParameter> parameterList;

  OperationMethod({
    this.name,
    this.operation,
    this.parameterList,
  });
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
