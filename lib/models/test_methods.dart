import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/controler_test.dart';

class TestMethods {
  final String tableName;
  final String mainMethod;

  TestMethods({
    @required this.tableName,
    @required this.mainMethod,
  });
}
