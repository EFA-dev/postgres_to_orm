import 'harness/app.dart';
import 'package:postgres_to_orm_example/model/authclient.dart';

void main() {
  final harness = Harness()..install();
  tearDown(() async {
    await harness.resetData();
  });
  group("GET: ", () {
    test("Get /authclients returns 200 OK", () async {
      final response = await harness.agent.get("/authclients");
      expect(response.statusCode, 200);
    });
    test("Get /whatever returns 404 Not Found", () async {
      final response = await harness.agent.get("/whatever");
      expect(response.statusCode, 404);
    });
    test("Get /authclients/1 returns 404 Not Found", () async {
      final response = await harness.agent.get("/authclients/1");
      expect(response.statusCode, 404);
    });
    test("Get /authclients/1 returns 200 OK after post", () async {
      await harness.agent.post("/authclients", body: {
        //TODO: Fill body
      });
      final response = await harness.agent.get("/authclients/1");
      expect(response.statusCode, 200);
    });
  });
  group("POST: ", () {
    test("Post empty body /authclients returns 400 Bad Request", () async {
      final response = await harness.agent.post("/authclients", body: {});
      expect(response.statusCode, 400);
    });
    test("Post right body /authclients returns 200 OK", () async {
      final response = await harness.agent.post("/authclients", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
    test("Post missing key body /authclients returns 400 Bad Request",
        () async {
      final response = await harness.agent.post("/authclients", body: {
        //TODO: Fill some body key
      });
      expect(response.statusCode, 400);
    });
  });
  group("PUT: ", () {
    test("Put empty body /authclients returns 400 Bad Request", () async {
      final response = await harness.agent.put("/authclients", body: {});
      expect(response.statusCode, 400);
    });
    test("Put right body /authclients returns 200 OK", () async {
      final response = await harness.agent.put("/authclients", body: {
        //TODO: Fill body
      });
      expect(response.statusCode, 200);
    });
  });
  group("DELETE:", () {
    test("Delete /authclients/1 returns 200 OK", () async {
      final response = await harness.agent.delete("/authclients/1");
      expect(response.statusCode, 200);
    });
    test("Delete /authclients returns 400 Bad Request", () async {
      final response = await harness.agent.delete("/authclients/");
      expect(response.statusCode, 400);
    });
    test("Delete /authclients/2 returns 404 Not Found", () async {
      final response = await harness.agent.delete("/authclients/2");
      expect(response.statusCode, 404);
    });
  });
}
