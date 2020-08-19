import 'package:postgres_to_orm/src/extensions.dart';

class Constraint {
  final String type;
  final String fromTableNameRaw;
  final String fromColumnNameRaw;
  final String toTableNameRaw;
  final String toTableColumnNameRaw;
  final String schema;

  bool get isPrimaryKey => type == 'PRIMARY KEY';

  String get fromTableName {
    return fromTableNameRaw.removeFirstUnderscore;
  }

  String get fromColumnName {
    return fromColumnNameRaw.removeFirstUnderscore;
  }

  String get toTableName {
    return toTableNameRaw.removeFirstUnderscore;
  }

  String get toTableColumnName {
    return toTableColumnNameRaw.removeFirstUnderscore;
  }

  Constraint({
    this.type,
    this.fromTableNameRaw,
    this.fromColumnNameRaw,
    this.toTableNameRaw,
    this.toTableColumnNameRaw,
    this.schema,
  });
}
