import 'package:postgres_to_orm/src/extensions.dart';

class Column {
  final String nameRaw;
  String dbDataType;
  bool primaryKey;
  bool nullable;
  bool unique;
  bool indexed;
  bool autoincrement;
  bool identity;
  bool selfReferencing;
  String defaultValue;

  String get dataType {
    switch (dbDataType) {
      case 'integer':
      case 'smallint':
      case 'bigint':
      case 'serial':
      case 'bigserial':
      case 'int':
        return 'int';
        break;

      case 'double precision':
      case 'real':
      case 'num':
        return 'double';
        break;

      case 'boolean':
        return 'bool';
        break;

      case 'date':
      case 'timestamp':
        return 'DateTime';
        break;

      case 'jsonb':
        return 'Document';
        break;

      default:
        return 'String';
    }
  }

  String get name {
    // return nameRaw.camelCase;
    return nameRaw.removeFirstUnderscore;
  }

  Column({
    this.nameRaw,
    this.dbDataType,
    this.primaryKey = false,
    this.nullable = false,
    this.unique = false,
    this.defaultValue,
    this.indexed,
    this.autoincrement,
    this.identity,
    this.selfReferencing,
  });
}
