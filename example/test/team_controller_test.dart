import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/team.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /teams returns 200 OK", () async {
      final response = await harness.agent.get("/teams");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /teams/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/teams/1");
      expect(response.statusCode, 404);
    });
    test("Get /teams/1 returns 200 OK after post", () async {
      await harness.agent.post("/teams", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/teams/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /teams returns 400 Bad Request", () async {
      final response = await harness.agent.post("/teams", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /teams returns 200 OK", () async {
      final response = await harness.agent.post("/teams", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /teams returns 400 Bad Request", () async {
      final response = await harness.agent.post("/teams", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /teams returns 400 Bad Request", () async {
      final response = await harness.agent.put("/teams", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /teams returns 200 OK", () async {
      final response = await harness.agent.put("/teams", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /teams/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/teams/1");
      expect(response.statusCode, 200);
    });
    test("Delete /teams returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/teams/");
      expect(response.statusCode, 400);
    });
    test("Delete /teams/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/teams/2");
      expect(response.statusCode, 404);
    });
  });
}
