class Column {
  final String name;
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

  Column({
    this.name,
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

// static ManagedPropertyType get integer => ManagedPropertyType.integer;

// static ManagedPropertyType get bigInteger => ManagedPropertyType.bigInteger;

// static ManagedPropertyType get string => ManagedPropertyType.string;

// static ManagedPropertyType get datetime => ManagedPropertyType.datetime;

// static ManagedPropertyType get boolean => ManagedPropertyType.boolean;

// static ManagedPropertyType get doublePrecision => ManagedPropertyType.doublePrecision;

// static ManagedPropertyType get map => ManagedPropertyType.map;

// static ManagedPropertyType get list => ManagedPropertyType.list;

// static ManagedPropertyType get document => ManagedPropertyType.document;
