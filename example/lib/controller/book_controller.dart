import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/book.dart';

class BookController extends ResourceController {
  BookController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllBooks() async {
    final bookQuery = Query<Book>(context);
    final books = await bookQuery.fetch();
    return Response.ok(books);
  }

  @Operation.get('id')
  Future<Response> getBookByID(@Bind.path('id') int id) async {
    final bookQuery = Query<Book>(context)..where((x) => x.id).equalTo(id);
    final book = await bookQuery.fetchOne();
    if (book == null) {
      return Response.notFound();
    }
    return Response.ok(book);
  }

  @Operation.post()
  Future<Response> addBook(@Bind.body() Book book) async {
    final bookQuery = Query<Book>(context)..values = book;
    final insertedBook = await bookQuery.insert();
    return Response.ok(insertedBook);
  }

  @Operation.put('id')
  Future<Response> updateBook(
      @Bind.path('id') int id, @Bind.body() Book book) async {
    final bookQuery = Query<Book>(context)
      ..values = book
      ..where((x) => x.id).equalTo(id);
    final updatedBook = await bookQuery.updateOne();
    if (updatedBook == null) {
      return Response.notFound();
    }
    return Response.ok(updatedBook);
  }

  @Operation.delete('id')
  Future<Response> deleteBook(@Bind.path('id') int id) async {
    final bookQuery = Query<Book>(context)..where((x) => x.id).equalTo(id);
    final int deletedBook = await bookQuery.delete();
    if (deletedBook == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedBook Book"};
    return Response.ok(response);
  }
}
