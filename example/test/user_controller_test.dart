import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/user.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /users returns 200 OK", () async {
      final response = await harness.agent.get("/users");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /users/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/users/1");
      expect(response.statusCode, 404);
    });
    test("Get /users/1 returns 200 OK after post", () async {
      await harness.agent.post("/users", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/users/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /users returns 400 Bad Request", () async {
      final response = await harness.agent.post("/users", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /users returns 200 OK", () async {
      final response = await harness.agent.post("/users", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /users returns 400 Bad Request", () async {
      final response = await harness.agent.post("/users", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /users returns 400 Bad Request", () async {
      final response = await harness.agent.put("/users", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /users returns 200 OK", () async {
      final response = await harness.agent.put("/users", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /users/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/users/1");
      expect(response.statusCode, 200);
    });
    test("Delete /users returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/users/");
      expect(response.statusCode, 400);
    });
    test("Delete /users/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/users/2");
      expect(response.statusCode, 404);
    });
  });
}
