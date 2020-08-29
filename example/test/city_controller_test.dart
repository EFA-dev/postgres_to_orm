import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/city.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /cities returns 200 OK", () async {
      final response = await harness.agent.get("/cities");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /cities/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/cities/1");
      expect(response.statusCode, 404);
    });
    test("Get /cities/1 returns 200 OK after post", () async {
      await harness.agent.post("/cities", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/cities/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /cities returns 400 Bad Request", () async {
      final response = await harness.agent.post("/cities", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /cities returns 200 OK", () async {
      final response = await harness.agent.post("/cities", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /cities returns 400 Bad Request", () async {
      final response = await harness.agent.post("/cities", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /cities returns 400 Bad Request", () async {
      final response = await harness.agent.put("/cities", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /cities returns 200 OK", () async {
      final response = await harness.agent.put("/cities", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /cities/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/cities/1");
      expect(response.statusCode, 200);
    });
    test("Delete /cities returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/cities/");
      expect(response.statusCode, 400);
    });
    test("Delete /cities/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/cities/2");
      expect(response.statusCode, 404);
    });
  });
}
