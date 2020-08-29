import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/aqueduct_version_pgsql.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /aqueductVersionPgsqls returns 200 OK", () async {
      final response = await harness.agent.get("/aqueductVersionPgsqls");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /aqueductVersionPgsqls/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/aqueductVersionPgsqls/1");
      expect(response.statusCode, 404);
    });
    test("Get /aqueductVersionPgsqls/1 returns 200 OK after post", () async {
      await harness.agent.post("/aqueductVersionPgsqls", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/aqueductVersionPgsqls/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /aqueductVersionPgsqls returns 400 Bad Request",
        () async {
      final response =
          await harness.agent.post("/aqueductVersionPgsqls", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /aqueductVersionPgsqls returns 200 OK", () async {
      final response =
          await harness.agent.post("/aqueductVersionPgsqls", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /aqueductVersionPgsqls returns 400 Bad Request",
        () async {
      final response =
          await harness.agent.post("/aqueductVersionPgsqls", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /aqueductVersionPgsqls returns 400 Bad Request",
        () async {
      final response =
          await harness.agent.put("/aqueductVersionPgsqls", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /aqueductVersionPgsqls returns 200 OK", () async {
      final response = await harness.agent.put("/aqueductVersionPgsqls", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /aqueductVersionPgsqls/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/aqueductVersionPgsqls/1");
      expect(response.statusCode, 200);
    });
    test("Delete /aqueductVersionPgsqls returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/aqueductVersionPgsqls/");
      expect(response.statusCode, 400);
    });
    test("Delete /aqueductVersionPgsqls/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/aqueductVersionPgsqls/2");
      expect(response.statusCode, 404);
    });
  });
}
