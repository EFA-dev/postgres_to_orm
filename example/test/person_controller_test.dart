import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/person.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /people returns 200 OK", () async {
      final response = await harness.agent.get("/people");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /people/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/people/1");
      expect(response.statusCode, 404);
    });
    test("Get /people/1 returns 200 OK after post", () async {
      await harness.agent.post("/people", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/people/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /people returns 400 Bad Request", () async {
      final response = await harness.agent.post("/people", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /people returns 200 OK", () async {
      final response = await harness.agent.post("/people", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /people returns 400 Bad Request", () async {
      final response = await harness.agent.post("/people", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /people returns 400 Bad Request", () async {
      final response = await harness.agent.put("/people", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /people returns 200 OK", () async {
      final response = await harness.agent.put("/people", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /people/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/people/1");
      expect(response.statusCode, 200);
    });
    test("Delete /people returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/people/");
      expect(response.statusCode, 400);
    });
    test("Delete /people/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/people/2");
      expect(response.statusCode, 404);
    });
  });
}
