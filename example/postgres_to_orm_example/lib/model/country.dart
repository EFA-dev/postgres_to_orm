import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/city.dart';

class Country extends ManagedObject<_Country> implements _Country {}

class _Country {
  @primaryKey
  int id;

  String name;

  City capital;
}
