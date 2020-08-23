import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';

class AqueductVersionPgsql extends ManagedObject<_AqueductVersionPgsql>
    implements _AqueductVersionPgsql {}

class _AqueductVersionPgsql {
  String dateofupgrade;

  @Relate(#versionnumbers)
  AqueductVersionPgsql versionnumber;
}
