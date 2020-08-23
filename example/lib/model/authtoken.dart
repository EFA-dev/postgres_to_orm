import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/user.dart';
import 'package:postgres_to_orm_example/model/authclient.dart';

class Authtoken extends ManagedObject<_Authtoken> implements _Authtoken {}

class _Authtoken {
  @primaryKey
  int id;

  String scope;

  String issuedate;

  String expirationdate;

  String type;

  @Relate(#codes)
  Authtoken code;

  @Relate(#accesstokens)
  Authtoken accesstoken;

  @Relate(#refreshtokens)
  Authtoken refreshtoken;

  @Relate(#authtokens)
  User user;

  @Relate(#authtokens)
  Authclient authclient;
}
