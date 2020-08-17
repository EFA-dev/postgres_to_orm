import 'package:inflection2/inflection2.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:postgres_to_orm/models/column.dart';
import 'package:postgres_to_orm/models/constraint.dart';
import 'package:postgres_to_orm/models/managed_set.dart';
import 'package:postgres_to_orm/models/primary_key.dart';
import 'package:postgres_to_orm/models/relate.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/build_configuration.dart';
import 'package:postgres_to_orm/src/query_collection.dart';
import 'package:recase/recase.dart';

class SchemaReader {
  final BuildConfiguration config;
  final PostgreSQLConnection connection;

  SchemaReader(this.config, this.connection);

  Future<List<Table>> getTables() async {
    if (connection.isClosed) {
      await connection.open();
    }

    List<List<dynamic>> results = await connection.query(QueryCollection.selectAllTable(schema: config.dbSchema));

    var tableList = <Table>[];
    for (final row in results) {
      final String tableName = row[1];
      tableList.add(Table(name: tableName));
    }

    //Add all column
    for (var table in tableList) {
      var columnList = await getTableColumns(table.name);
      table.columnList = columnList;
    }

    //Releations
    for (var table in tableList) {
      //* Primary Key
      var constraintList = await getTableConstrints(table.name);
      var foreignTableConstraintList = await getTableConstrints(table.name, forTable: false);

      var primaryKeyConstraint = constraintList.firstWhere((element) => element.isPrimaryKey);
      if (primaryKeyConstraint != null) {
        table.columnList.firstWhere((element) => element.name == primaryKeyConstraint.columnName).primaryKey = true;
        constraintList.removeWhere((element) => element.isPrimaryKey);
      }

      for (var foraignTableConstraint in foreignTableConstraintList) {
        var checkConstraint =
            constraintList.firstWhere((element) => element.foreignTableName == foraignTableConstraint.tableName, orElse: () => null);

        if (checkConstraint == null) {
          table.managedSetList.add(ManagedSet(
            name: pluralize(foraignTableConstraint.tableName.replaceFirst('_', '')),
            typeName: ReCase(foraignTableConstraint.tableName).pascalCase,
          ));
        }
      }

      for (var constraint in constraintList) {
        Logger.root.info(constraint.tableName);

        var checkConstraint =
            foreignTableConstraintList.firstWhere((element) => element.foreignTableName == constraint.tableName, orElse: () => null);

        if (checkConstraint == null) {
          table.relateList.add(
            Relate(
              relateType: ReCase(pluralize(table.name)).camelCase,
              typeName: ReCase(constraint.foreignTableName).pascalCase,
              name: constraint.foreignTableName.replaceFirst('_', ''),
            ),
          );
        } else {
          var hasConstraintColumn = table.columnList.any((element) => element.name == constraint.columnName.replaceFirst('_', ''));
          if (hasConstraintColumn == false) {
            table.relateList.add(
              Relate(
                relateType: ReCase(checkConstraint.columnName).camelCase,
                typeName: ReCase(constraint.foreignTableName).pascalCase,
                name: constraint.foreignTableName.replaceFirst('_', ''),
              ),
            );
          } else {
            table.relateList.add(
              Relate(
                relateType: null,
                typeName: ReCase(constraint.foreignTableName).pascalCase,
                name: constraint.foreignTableName.replaceFirst('_', ''),
              ),
            );
          }
        }

        table.columnList.removeWhere((element) => element.name == constraint.columnName);
      }
    }

    return tableList;
  }

  Future<List<Column>> getTableColumns(String tableName) async {
    if (connection.isClosed) {
      await connection.open();
    }

    var results = await connection.query(QueryCollection.getAllColumn(tableName, schema: config.dbSchema));

    var columnList = <Column>[];
    for (var row in results) {
      var name = row[0];
      var dataType = row[1];
      var isNullable = row[2] == 'YES' ? true : false;
      final isIdentity = row[3] == 'YES' ? true : false;
      final isSelfReferencing = row[3] == 'YES' ? true : false;

      columnList.add(Column(
        name: name,
        dbDataType: dataType,
        nullable: isNullable,
        identity: isIdentity,
        selfReferencing: isSelfReferencing,
      ));
    }

    return columnList;
  }

  Future<List<Constraint>> getTableConstrints(String tableName, {bool forTable = true}) async {
    if (connection.isClosed) {
      await connection.open();
    }

    String query;
    if (forTable) {
      query = QueryCollection.getTableConstraints(tableName, schema: config.dbSchema);
    } else {
      query = QueryCollection.getForeignTableConstraints(tableName, schema: config.dbSchema);
    }

    var result = await connection.query(query);

    var constraintList = <Constraint>[];
    for (var row in result) {
      String type = row[0];
      String tableName = row[1];
      String columnName = row[2];
      String foreignTableName = row[3];
      String foreignColumnName = row[4];
      String schema = row[5];

      constraintList.add(Constraint(
        type: type,
        tableName: tableName,
        columnName: columnName,
        foreignTableName: foreignTableName,
        foreignColumnName: foreignColumnName,
        schema: schema,
      ));
    }

    return constraintList;
  }

  Future<List<PrimaryKey>> getAllPrimaryKey() async {
    if (connection.isClosed) {
      await connection.open();
    }

    List<List<dynamic>> result = await connection.query(QueryCollection.getAllPrimaryKey(schema: config.dbSchema));
    var primaryKeyList = <PrimaryKey>[];
    for (var row in result) {
      var tableName = row[0];
      var columnName = row[1];
      primaryKeyList.add(PrimaryKey(tableName, columnName));
    }
    return primaryKeyList;
  }
}
