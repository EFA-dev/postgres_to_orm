import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/book.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /books returns 200 OK", () async {
      final response = await harness.agent.get("/books");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /books/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/books/1");
      expect(response.statusCode, 404);
    });
    test("Get /books/1 returns 200 OK after post", () async {
      await harness.agent.post("/books", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/books/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /books returns 400 Bad Request", () async {
      final response = await harness.agent.post("/books", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /books returns 200 OK", () async {
      final response = await harness.agent.post("/books", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /books returns 400 Bad Request", () async {
      final response = await harness.agent.post("/books", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /books returns 400 Bad Request", () async {
      final response = await harness.agent.put("/books", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /books returns 200 OK", () async {
      final response = await harness.agent.put("/books", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /books/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/books/1");
      expect(response.statusCode, 200);
    });
    test("Delete /books returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/books/");
      expect(response.statusCode, 400);
    });
    test("Delete /books/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/books/2");
      expect(response.statusCode, 404);
    });
  });
}
