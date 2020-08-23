import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:postgres_to_orm_example/model/user.dart';
import 'package:postgres_to_orm_example/utility/html_template.dart';

class AqueductChannel extends ApplicationChannel implements AuthRedirectControllerDelegate {
  final HTMLRenderer htmlRenderer = HTMLRenderer();
  AuthServer authServer;
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = AqueductTestConfiguration(options.configurationFilePath);

    context = contextWithConnectionInfo(config.database);

    final authStorage = null; //ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    /* OAuth 2.0 Endpoints */
    router.route("/auth/token").link(() => AuthController(authServer));

    router.route("/auth/form").link(() => AuthRedirectController(authServer, delegate: this));

    // /* Create an account */
    // router.route("/register").link(() => Authorizer.basic(authServer)).link(() => RegisterController(context, authServer));

    // /* Gets profile for user with bearer token */
    // router.route("/me").link(() => Authorizer.bearer(authServer)).link(() => IdentityController(context));

    // /* Gets all users or one specific user by id */
    // router.route("/users/[:id]").link(() => Authorizer.bearer(authServer)).link(() => UserController(context, authServer));

    return router;
  }

  /*
   * Helper methods
   */

  ManagedContext contextWithConnectionInfo(DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
      connectionInfo.username,
      connectionInfo.password,
      connectionInfo.host,
      connectionInfo.port,
      connectionInfo.databaseName,
    );

    return ManagedContext(dataModel, psc);
  }

  @override
  Future<String> render(
    AuthRedirectController forController,
    Uri requestUri,
    String responseType,
    String clientID,
    String state,
    String scope,
  ) async {
    final map = {"response_type": responseType, "client_id": clientID, "state": state};

    map["path"] = requestUri.path;
    if (scope != null) {
      map["scope"] = scope;
    }

    return htmlRenderer.renderHTML("web/login.html", map);
  }
}

class AqueductTestConfiguration extends Configuration {
  AqueductTestConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration database;
}
