import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/authtoken.dart';

class AuthtokenController extends ResourceController {
  AuthtokenController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllAuthtokens() async {
    final authtokenQuery = Query<Authtoken>(context);
    final authtokens = await authtokenQuery.fetch();
    return Response.ok(authtokens);
  }

  @Operation.get('id')
  Future<Response> getAuthtokenByID(@Bind.path('id') int id) async {
    final authtokenQuery = Query<Authtoken>(context)
      ..where((x) => x.id).equalTo(id);
    final authtoken = await authtokenQuery.fetchOne();
    if (authtoken == null) {
      return Response.notFound();
    }
    return Response.ok(authtoken);
  }

  @Operation.post()
  Future<Response> addAuthtoken(@Bind.body() Authtoken authtoken) async {
    final authtokenQuery = Query<Authtoken>(context)..values = authtoken;
    final insertedAuthtoken = await authtokenQuery.insert();
    return Response.ok(insertedAuthtoken);
  }

  @Operation.put('id')
  Future<Response> updateAuthtoken(
      @Bind.path('id') int id, @Bind.body() Authtoken authtoken) async {
    final authtokenQuery = Query<Authtoken>(context)
      ..values = authtoken
      ..where((x) => x.id).equalTo(id);
    final updatedAuthtoken = await authtokenQuery.updateOne();
    if (updatedAuthtoken == null) {
      return Response.notFound();
    }
    return Response.ok(updatedAuthtoken);
  }

  @Operation.delete('id')
  Future<Response> deleteAuthtoken(@Bind.path('id') int id) async {
    final authtokenQuery = Query<Authtoken>(context)
      ..where((x) => x.id).equalTo(id);
    final int deletedAuthtoken = await authtokenQuery.delete();
    if (deletedAuthtoken == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedAuthtoken Authtoken"};
    return Response.ok(response);
  }
}
