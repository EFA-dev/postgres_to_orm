import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/user.dart';

class UserController extends ResourceController {
  UserController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllUsers() async {
    final userQuery = Query<User>(context);
    final users = await userQuery.fetch();
    return Response.ok(users);
  }

  @Operation.get('id')
  Future<Response> getUserByID(@Bind.path('id') int id) async {
    final userQuery = Query<User>(context)..where((x) => x.id).equalTo(id);
    final user = await userQuery.fetchOne();
    if (user == null) {
      return Response.notFound();
    }
    return Response.ok(user);
  }

  @Operation.post()
  Future<Response> addUser(@Bind.body() User user) async {
    final userQuery = Query<User>(context)..values = user;
    final insertedUser = await userQuery.insert();
    return Response.ok(insertedUser);
  }

  @Operation.put('id')
  Future<Response> updateUser(
      @Bind.path('id') int id, @Bind.body() User user) async {
    final userQuery = Query<User>(context)
      ..values = user
      ..where((x) => x.id).equalTo(id);
    final updatedUser = await userQuery.updateOne();
    if (updatedUser == null) {
      return Response.notFound();
    }
    return Response.ok(updatedUser);
  }

  @Operation.delete('id')
  Future<Response> deleteUser(@Bind.path('id') int id) async {
    final userQuery = Query<User>(context)..where((x) => x.id).equalTo(id);
    final int deletedUser = await userQuery.delete();
    if (deletedUser == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedUser User"};
    return Response.ok(response);
  }
}
