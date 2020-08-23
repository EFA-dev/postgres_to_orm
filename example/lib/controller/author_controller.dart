import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/author.dart';

class AuthorController extends ResourceController {
  AuthorController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllAuthors() async {
    final authorQuery = Query<Author>(context);
    final authors = await authorQuery.fetch();
    return Response.ok(authors);
  }

  @Operation.get('id')
  Future<Response> getAuthorByID(@Bind.path('id') int id) async {
    final authorQuery = Query<Author>(context)..where((x) => x.id).equalTo(id);
    final author = await authorQuery.fetchOne();
    if (author == null) {
      return Response.notFound();
    }
    return Response.ok(author);
  }

  @Operation.post()
  Future<Response> addAuthor(@Bind.body() Author author) async {
    final authorQuery = Query<Author>(context)..values = author;
    final insertedAuthor = await authorQuery.insert();
    return Response.ok(insertedAuthor);
  }

  @Operation.put('id')
  Future<Response> updateAuthor(
      @Bind.path('id') int id, @Bind.body() Author author) async {
    final authorQuery = Query<Author>(context)
      ..values = author
      ..where((x) => x.id).equalTo(id);
    final updatedAuthor = await authorQuery.updateOne();
    if (updatedAuthor == null) {
      return Response.notFound();
    }
    return Response.ok(updatedAuthor);
  }

  @Operation.delete('id')
  Future<Response> deleteAuthor(@Bind.path('id') int id) async {
    final authorQuery = Query<Author>(context)..where((x) => x.id).equalTo(id);
    final int deletedAuthor = await authorQuery.delete();
    if (deletedAuthor == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedAuthor Author"};
    return Response.ok(response);
  }
}
