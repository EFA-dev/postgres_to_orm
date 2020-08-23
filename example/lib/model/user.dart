import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/authtoken.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int id;

  String hashedpassword;

  String salt;

  ManagedSet<Authtoken> authtokens;

  @Relate(#usernames)
  User username;
}
