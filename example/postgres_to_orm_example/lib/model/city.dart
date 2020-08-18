import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/country.dart';

class City extends ManagedObject<_City> implements _City {}

class _City {
  @primaryKey
  int id;

  String name;

  @Relate(#capital)
  Country country;
}
