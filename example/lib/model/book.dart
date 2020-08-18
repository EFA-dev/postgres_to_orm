import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/author.dart';

class Book extends ManagedObject<_Book> implements _Book {}

class _Book {
  @primaryKey
  int id;

  String name;

  @Relate(#books)
  Author author;
}
