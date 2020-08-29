import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/team_player.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /teamPlayers returns 200 OK", () async {
      final response = await harness.agent.get("/teamPlayers");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /teamPlayers/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/teamPlayers/1");
      expect(response.statusCode, 404);
    });
    test("Get /teamPlayers/1 returns 200 OK after post", () async {
      await harness.agent.post("/teamPlayers", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/teamPlayers/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /teamPlayers returns 400 Bad Request", () async {
      final response = await harness.agent.post("/teamPlayers", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /teamPlayers returns 200 OK", () async {
      final response = await harness.agent.post("/teamPlayers", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /teamPlayers returns 400 Bad Request",
        () async {
      final response = await harness.agent.post("/teamPlayers", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /teamPlayers returns 400 Bad Request", () async {
      final response = await harness.agent.put("/teamPlayers", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /teamPlayers returns 200 OK", () async {
      final response = await harness.agent.put("/teamPlayers", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /teamPlayers/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/teamPlayers/1");
      expect(response.statusCode, 200);
    });
    test("Delete /teamPlayers returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/teamPlayers/");
      expect(response.statusCode, 400);
    });
    test("Delete /teamPlayers/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/teamPlayers/2");
      expect(response.statusCode, 404);
    });
  });
}
