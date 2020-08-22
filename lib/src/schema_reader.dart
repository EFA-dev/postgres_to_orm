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
import 'package:postgres_to_orm/src/extensions.dart';

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

    //* Add all column
    for (var table in tableList) {
      var columnList = await getTableColumns(table.name);
      table.columnList = columnList;
    }

    //* Table Releations
    for (var table in tableList) {
      var constraintList = await getTableConstrints(table.name);
      var foreignTableConstraintList = await getTableConstrints(table.name, forTable: false);

      //* Primary Key Constraint
      var primaryKeyConstraint = constraintList.firstWhere((element) => element.isPrimaryKey, orElse: () => null);
      if (primaryKeyConstraint != null) {
        table.columnList.firstWhere((element) => element.nameRaw == primaryKeyConstraint.fromColumnName).primaryKey = true;
        constraintList.removeWhere((element) => element.isPrimaryKey);
      }

      //* Foreign Table relations
      for (var foreignTableConstraint in foreignTableConstraintList) {
        //* Self referencing
        if (foreignTableConstraint.fromTableName == foreignTableConstraint.toTableName) {
          table.managedSetList.add(ManagedSet(
            typeName: foreignTableConstraint.fromTableName.pascalCase,
            name: foreignTableConstraint.fromColumnName.camelCase.pluralize,
            importFileName: foreignTableConstraint.fromTableName.snakeCase,
          ));
        } else {
          //* This is for one to one relation
          var checkConstraint =
              constraintList.firstWhere((element) => element.toTableName == foreignTableConstraint.fromTableName, orElse: () => null);

          if (checkConstraint == null) {
            table.managedSetList.add(ManagedSet(
              typeName: foreignTableConstraint.fromTableName.pascalCase,
              name: foreignTableConstraint.fromTableName.camelCase.pluralize,
              importFileName: foreignTableConstraint.fromTableName.snakeCase,
            ));
          }
        }
      }

      //* Current Table relations
      for (var constraint in constraintList) {
        //* Self referencing
        if (constraint.fromTableName == constraint.toTableName) {
          table.relateList.add(
            Relate(
              relateSymbol: constraint.fromColumnName.camelCase.pluralize,
              typeName: constraint.fromTableName.pascalCase,
              name: constraint.fromColumnName.camelCase,
              importFileName: constraint.fromTableName.snakeCase,
            ),
          );
        } else {
          //* Check is there any constraint to this table
          var checkConstraint = foreignTableConstraintList.firstWhere(
            (element) => element.toTableName == constraint.fromTableName,
            orElse: () => null,
          );

          var fileName = constraint.toTableName.snakeCase;

          if (checkConstraint == null) {
            table.relateList.add(
              Relate(
                relateSymbol: table.name.camelCase.pluralize,
                typeName: constraint.toTableName.pascalCase,
                name: constraint.toTableName,
                importFileName: fileName,
              ),
            );
          } else {
            //* To check is there any column that use for foreign key constraint
            //* This is need for one to one relation
            var hasConstraintColumn = table.columnList.any(
              (column) => column.nameRaw == constraint.fromColumnName,
            );
            if (hasConstraintColumn == false) {
              table.relateList.add(
                Relate(
                  relateSymbol: checkConstraint.fromColumnName.camelCase,
                  typeName: constraint.toTableName.pascalCase,
                  name: constraint.toTableName,
                  importFileName: fileName,
                ),
              );
            } else {
              table.relateList.add(
                Relate(
                  relateSymbol: null,
                  typeName: constraint.toTableName.pascalCase,
                  name: constraint.fromColumnName.camelCase,
                  importFileName: fileName,
                ),
              );
            }
          }
        }

        table.columnList.removeWhere((element) => element.nameRaw == constraint.fromColumnName);
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
      var nameRaw = row[0];
      var dataType = row[1];
      var isNullable = row[2] == 'YES' ? true : false;
      final isIdentity = row[3] == 'YES' ? true : false;
      final isSelfReferencing = row[3] == 'YES' ? true : false;

      columnList.add(Column(
        nameRaw: nameRaw,
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
      String fromTableName = row[1];
      String fromColumnName = row[2];
      String toTableName = row[3];
      String toTableColumnName = row[4];
      String schema = row[5];

      constraintList.add(Constraint(
        type: type,
        fromTableNameRaw: fromTableName,
        fromColumnNameRaw: fromColumnName,
        toTableNameRaw: toTableName,
        toTableColumnNameRaw: toTableColumnName,
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
