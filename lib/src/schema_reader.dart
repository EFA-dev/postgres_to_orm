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

    //* Table Releations
    for (var table in tableList) {
      var constraintList = await getTableConstrints(table.name);
      var foreignTableConstraintList = await getTableConstrints(table.name, forTable: false);

      //* Primary Key Constraint
      var primaryKeyConstraint = constraintList.firstWhere((element) => element.isPrimaryKey);
      if (primaryKeyConstraint != null) {
        table.columnList.firstWhere((element) => element.name == primaryKeyConstraint.columnName).primaryKey = true;
        constraintList.removeWhere((element) => element.isPrimaryKey);
      }

      //* Foreign Table relations
      for (var foreignTableConstraint in foreignTableConstraintList) {
        //* Self referencing
        if (foreignTableConstraint.tableName == foreignTableConstraint.foreignTableName) {
          table.managedSetList.add(ManagedSet(
            typeName: ReCase(foreignTableConstraint.tableName).pascalCase,
            name: pluralize(ReCase(foreignTableConstraint.columnName).camelCase.replaceFirst('_', '')),
            fileName: ReCase(foreignTableConstraint.tableName).snakeCase,
          ));
        } else {
          //* This is for one to one relation
          var checkConstraint =
              constraintList.firstWhere((element) => element.foreignTableName == foreignTableConstraint.tableName, orElse: () => null);

          if (checkConstraint == null) {
            table.managedSetList.add(ManagedSet(
              typeName: ReCase(foreignTableConstraint.tableName).pascalCase,
              name: pluralize(ReCase(foreignTableConstraint.tableName).camelCase),
              fileName: ReCase(foreignTableConstraint.tableName).snakeCase,
            ));
          }
        }
      }

      //* Current Table relations
      for (var constraint in constraintList) {
        //* Self referencing
        if (constraint.tableName == constraint.foreignTableName) {
          table.relateList.add(
            Relate(
              relateType: pluralize(ReCase(constraint.columnName).camelCase.replaceFirst('_', '')),
              typeName: ReCase(constraint.tableName).pascalCase,
              name: ReCase(constraint.columnName).camelCase.replaceFirst('_', ''),
              fileName: ReCase(constraint.tableName).snakeCase,
            ),
          );
        } else {
          //* Check is there any constraint to this table
          var checkConstraint = foreignTableConstraintList.firstWhere(
            (element) => element.foreignTableName == constraint.tableName,
            orElse: () => null,
          );

          var fileName = ReCase(constraint.foreignTableName).snakeCase;

          if (checkConstraint == null) {
            table.relateList.add(
              Relate(
                relateType: ReCase(pluralize(table.name)).camelCase,
                typeName: ReCase(constraint.foreignTableName).pascalCase,
                name: constraint.foreignTableName.replaceFirst('_', ''),
                fileName: fileName,
              ),
            );
          } else {
            //* To check is there any column that use for foreign key constraint
            //* This is need for one to one relation
            var hasConstraintColumn = table.columnList.any(
              (element) => element.name == constraint.columnName.replaceFirst('_', ''),
            );
            if (hasConstraintColumn == false) {
              table.relateList.add(
                Relate(
                  relateType: ReCase(checkConstraint.columnName).camelCase,
                  typeName: ReCase(constraint.foreignTableName).pascalCase,
                  name: constraint.foreignTableName.replaceFirst('_', ''),
                  fileName: fileName,
                ),
              );
            } else {
              table.relateList.add(
                Relate(
                  relateType: null,
                  typeName: ReCase(constraint.foreignTableName).pascalCase,
                  name: constraint.columnName.replaceFirst('_', ''),
                  fileName: fileName,
                ),
              );
            }
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
