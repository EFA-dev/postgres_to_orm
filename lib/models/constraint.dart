class Constraint {
  final String type;
  final String tableName;
  final String columnName;
  final String foreignTableName;
  final String foreignColumnName;
  final String schema;

  bool get isPrimaryKey => type == 'PRIMARY KEY';

  Constraint({
    this.type,
    this.tableName,
    this.columnName,
    this.foreignTableName,
    this.foreignColumnName,
    this.schema,
  });
}
