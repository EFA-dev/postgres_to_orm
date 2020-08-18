import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';

class Person extends ManagedObject<_Person> implements _Person {}

class _Person {
  @primaryKey
  int id;

  String name;

  ManagedSet<Person> parentIds;

  @Relate(#parentIds)
  Person parentId;
}
