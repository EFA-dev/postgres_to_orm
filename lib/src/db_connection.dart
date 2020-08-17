import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:safe_config/safe_config.dart';

class DBConnection {
  static Future<PostgreSQLConnection> createConnection(DatabaseConfiguration database) async {
    var conn = PostgreSQLConnection(
      database.host,
      database.port,
      database.databaseName,
      username: database.username,
      password: database.password,
    );

    return conn;
  }
}
