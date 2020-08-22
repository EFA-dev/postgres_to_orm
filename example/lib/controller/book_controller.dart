import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/book.dart';

class BookController extends ResourceController {
  @Operation.get()
  Future<Response> getAllBooks() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getBookByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addBook(@Bind.body() Book book) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateBook(
      @Bind.path('id') int id, @Bind.body() Book book) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteBook(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
