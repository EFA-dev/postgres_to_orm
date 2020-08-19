import 'package:postgres_to_orm/models/managed_set.dart';

class Relate extends ManagedSet {
  final String relateSymbol;

  Relate({
    this.relateSymbol,
    String name,
    String typeName,
    String importFileName,
  }) : super(
          name: name,
          typeName: typeName,
          importFileName: importFileName,
        );
}
