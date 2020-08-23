import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/authtoken.dart';

class Authclient extends ManagedObject<_Authclient> implements _Authclient {}

class _Authclient {
  @primaryKey
  String id;

  String hashedsecret;

  String salt;

  String redirecturi;

  String allowedscope;

  ManagedSet<Authtoken> authtokens;
}
