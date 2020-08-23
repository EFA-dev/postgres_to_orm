import 'package:postgres_to_orm/models/column.dart';
import 'package:postgres_to_orm/models/managed_set.dart';
import 'package:postgres_to_orm/models/relate.dart';
import 'package:recase/recase.dart';

class Table {
  final String name;
  List<Column> columnList = [];
  List<ManagedSet> managedSetList = [];
  List<Relate> relateList = [];

  String get managedObjectName => name.pascalCase;
  String get modelName => '_$managedObjectName';

  Column get primarColumn => columnList.firstWhere((element) => element.primaryKey, orElse: () => null);

  Table({this.name});
}
