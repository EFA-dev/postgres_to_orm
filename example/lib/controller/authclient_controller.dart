import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/authclient.dart';

class AuthclientController extends ResourceController {
  AuthclientController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllAuthclients() async {
    final authclientQuery = Query<Authclient>(context);
    final authclients = await authclientQuery.fetch();
    return Response.ok(authclients);
  }

  @Operation.get('id')
  Future<Response> getAuthclientByID(@Bind.path('id') String id) async {
    final authclientQuery = Query<Authclient>(context)
      ..where((x) => x.id).equalTo(id);
    final authclient = await authclientQuery.fetchOne();
    if (authclient == null) {
      return Response.notFound();
    }
    return Response.ok(authclient);
  }

  @Operation.post()
  Future<Response> addAuthclient(@Bind.body() Authclient authclient) async {
    final authclientQuery = Query<Authclient>(context)..values = authclient;
    final insertedAuthclient = await authclientQuery.insert();
    return Response.ok(insertedAuthclient);
  }

  @Operation.put('id')
  Future<Response> updateAuthclient(
      @Bind.path('id') String id, @Bind.body() Authclient authclient) async {
    final authclientQuery = Query<Authclient>(context)
      ..values = authclient
      ..where((x) => x.id).equalTo(id);
    final updatedAuthclient = await authclientQuery.updateOne();
    if (updatedAuthclient == null) {
      return Response.notFound();
    }
    return Response.ok(updatedAuthclient);
  }

  @Operation.delete('id')
  Future<Response> deleteAuthclient(@Bind.path('id') String id) async {
    final authclientQuery = Query<Authclient>(context)
      ..where((x) => x.id).equalTo(id);
    final int deletedAuthclient = await authclientQuery.delete();
    if (deletedAuthclient == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedAuthclient Authclient"};
    return Response.ok(response);
  }
}
