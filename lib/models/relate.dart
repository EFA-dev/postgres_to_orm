import 'package:postgres_to_orm/models/managed_set.dart';

class Relate extends ManagedSet {
  final String relateType;

  Relate({this.relateType, String name, String typeName, String fileName}) : super(name: name, typeName: typeName, fileName: fileName);
}
