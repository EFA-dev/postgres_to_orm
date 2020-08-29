import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/author.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /authors returns 200 OK", () async {
      final response = await harness.agent.get("/authors");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /authors/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/authors/1");
      expect(response.statusCode, 404);
    });
    test("Get /authors/1 returns 200 OK after post", () async {
      await harness.agent.post("/authors", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/authors/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /authors returns 400 Bad Request", () async {
      final response = await harness.agent.post("/authors", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /authors returns 200 OK", () async {
      final response = await harness.agent.post("/authors", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /authors returns 400 Bad Request", () async {
      final response = await harness.agent.post("/authors", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /authors returns 400 Bad Request", () async {
      final response = await harness.agent.put("/authors", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /authors returns 200 OK", () async {
      final response = await harness.agent.put("/authors", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /authors/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/authors/1");
      expect(response.statusCode, 200);
    });
    test("Delete /authors returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/authors/");
      expect(response.statusCode, 400);
    });
    test("Delete /authors/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/authors/2");
      expect(response.statusCode, 404);
    });
  });
}
