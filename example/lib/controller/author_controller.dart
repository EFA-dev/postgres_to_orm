import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/author.dart';

class AuthorController extends ResourceController {
  @Operation.get()
  Future<Response> getAllAuthors() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getAuthorByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addAuthor(@Bind.body() Author author) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateAuthor(
      @Bind.path('id') int id, @Bind.body() Author author) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteAuthor(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
