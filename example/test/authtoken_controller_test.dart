import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/authtoken.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /authtokens returns 200 OK", () async {
      final response = await harness.agent.get("/authtokens");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /authtokens/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/authtokens/1");
      expect(response.statusCode, 404);
    });
    test("Get /authtokens/1 returns 200 OK after post", () async {
      await harness.agent.post("/authtokens", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/authtokens/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /authtokens returns 400 Bad Request", () async {
      final response = await harness.agent.post("/authtokens", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /authtokens returns 200 OK", () async {
      final response = await harness.agent.post("/authtokens", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /authtokens returns 400 Bad Request", () async {
      final response = await harness.agent.post("/authtokens", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /authtokens returns 400 Bad Request", () async {
      final response = await harness.agent.put("/authtokens", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /authtokens returns 200 OK", () async {
      final response = await harness.agent.put("/authtokens", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /authtokens/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/authtokens/1");
      expect(response.statusCode, 200);
    });
    test("Delete /authtokens returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/authtokens/");
      expect(response.statusCode, 400);
    });
    test("Delete /authtokens/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/authtokens/2");
      expect(response.statusCode, 404);
    });
  });
}
