import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/aqueduct_version_pgsql.dart';

class AqueductVersionPgsqlController extends ResourceController {
  AqueductVersionPgsqlController(this.context);

  final ManagedContext context;
}
