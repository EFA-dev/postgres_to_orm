import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/country.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /countries returns 200 OK", () async {
      final response = await harness.agent.get("/countries");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /countries/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/countries/1");
      expect(response.statusCode, 404);
    });
    test("Get /countries/1 returns 200 OK after post", () async {
      await harness.agent.post("/countries", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/countries/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /countries returns 400 Bad Request", () async {
      final response = await harness.agent.post("/countries", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /countries returns 200 OK", () async {
      final response = await harness.agent.post("/countries", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /countries returns 400 Bad Request", () async {
      final response = await harness.agent.post("/countries", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /countries returns 400 Bad Request", () async {
      final response = await harness.agent.put("/countries", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /countries returns 200 OK", () async {
      final response = await harness.agent.put("/countries", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /countries/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/countries/1");
      expect(response.statusCode, 200);
    });
    test("Delete /countries returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/countries/");
      expect(response.statusCode, 400);
    });
    test("Delete /countries/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/countries/2");
      expect(response.statusCode, 404);
    });
  });
}
