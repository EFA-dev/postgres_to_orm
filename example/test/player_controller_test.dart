import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/player.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /players returns 200 OK", () async {
      final response = await harness.agent.get("/players");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /players/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/players/1");
      expect(response.statusCode, 404);
    });
    test("Get /players/1 returns 200 OK after post", () async {
      await harness.agent.post("/players", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/players/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /players returns 400 Bad Request", () async {
      final response = await harness.agent.post("/players", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /players returns 200 OK", () async {
      final response = await harness.agent.post("/players", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /players returns 400 Bad Request", () async {
      final response = await harness.agent.post("/players", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /players returns 400 Bad Request", () async {
      final response = await harness.agent.put("/players", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /players returns 200 OK", () async {
      final response = await harness.agent.put("/players", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /players/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/players/1");
      expect(response.statusCode, 200);
    });
    test("Delete /players returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/players/");
      expect(response.statusCode, 400);
    });
    test("Delete /players/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/players/2");
      expect(response.statusCode, 404);
    });
  });
}
