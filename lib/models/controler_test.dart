import 'package:meta/meta.dart';
import 'package:postgres_to_orm/models/table.dart';
import 'package:postgres_to_orm/src/extensions.dart';

class ControllerTest {
  final List<TestMethodGroup> testMethodGroupList;

  ControllerTest({
    @required this.testMethodGroupList,
  });
}

class TestMethodGroup {
  final String description;
  final List<TestMethod> testMethodList;

  TestMethodGroup({
    @required this.description,
    @required this.testMethodList,
  });
}

class TestMethod {
  final String decription;
  final String body;

  TestMethod({
    @required this.decription,
    @required this.body,
  });

  factory TestMethod.get200(Table table) => TestMethod(
        decription: 'Get /${table.name.camelCase.pluralize} returns 200 OK',
        body: TestMethodBody.get200(table),
      );

  factory TestMethod.get404() => TestMethod(
        decription: 'Get /whatever returns 404 Not Found',
        body: TestMethodBody.get404(),
      );

  factory TestMethod.getSingle404(Table table) => TestMethod(
        decription: 'Get /${table.name.camelCase.pluralize}/1 returns 404 Not Found',
        body: TestMethodBody.getSingle404(table),
      );

  factory TestMethod.getSingleAfterPost200(Table table) => TestMethod(
        decription: 'Get /${table.name.camelCase.pluralize}/1 returns 200 OK after post',
        body: TestMethodBody.getSingleAfterPost200(table),
      );

  factory TestMethod.postEmptyBody400(Table table) => TestMethod(
        decription: 'Post empty body /${table.name.camelCase.pluralize} returns 400 Bad Request',
        body: TestMethodBody.postEmptyBody400(table),
      );
  factory TestMethod.postRightBody200(Table table) => TestMethod(
        decription: 'Post right body /${table.name.camelCase.pluralize} returns 200 OK',
        body: TestMethodBody.postRightBody200(table),
      );

  factory TestMethod.postMissingKeyBody400(Table table) => TestMethod(
        decription: 'Post missing key body /${table.name.camelCase.pluralize} returns 400 Bad Request',
        body: TestMethodBody.postMissingKeyBody400(table),
      );

  factory TestMethod.putEmptyBody400(Table table) => TestMethod(
        decription: 'Put empty body /${table.name.camelCase.pluralize} returns 400 Bad Request',
        body: TestMethodBody.putEmptyBody400(table),
      );
  factory TestMethod.putRightBody200(Table table) => TestMethod(
        decription: 'Put right body /${table.name.camelCase.pluralize} returns 200 OK',
        body: TestMethodBody.putRightBody200(table),
      );

  factory TestMethod.delete200(Table table) => TestMethod(
        decription: 'Delete /${table.name.camelCase.pluralize}/1 returns 200 OK',
        body: TestMethodBody.delete200(table),
      );

  factory TestMethod.delete400(Table table) => TestMethod(
        decription: 'Delete /${table.name.camelCase.pluralize} returns 400 Bad Request',
        body: TestMethodBody.delete400(table),
      );

  factory TestMethod.delete404(Table table) => TestMethod(
        decription: 'Delete /${table.name.camelCase.pluralize}/2 returns 404 Not Found',
        body: TestMethodBody.delete404(table),
      );
}

class TestMethodBody {
  static String get200(Table table) {
    var route = table.name.camelCase.pluralize;
    return '''
      () async {
        final response = await harness.agent.get("/${route}");
        expect(response.statusCode, 200);
      }
    ''';
  }

  static String get404() {
    return '''
      () async {
        final response = await harness.agent.get("/whatever");
        expect(response.statusCode, 404);
      }
    ''';
  }

  static String getSingle404(Table table) {
    var route = table.name.camelCase.pluralize;
    return '''
      () async {
        final response = await harness.agent.get("/${route}/1");
        expect(response.statusCode, 404);
      }
    ''';
  }

  static String getSingleAfterPost200(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        await harness.agent.post("/$route", body: {
          //TODO: Fill body
        });
        final response = await harness.agent.get("/$route/1");
        expect(response.statusCode, 200);
      }
    ''';
  }

  static String postEmptyBody400(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response=  await harness.agent.post("/$route", body: {});
        expect(response.statusCode, 400);
      }
    ''';
  }

  static String postRightBody200(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response=  await harness.agent.post("/$route", body: {
        //TODO: Fill body
        });
        expect(response.statusCode, 200);
      }
    ''';
  }

  static String postMissingKeyBody400(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response=  await harness.agent.post("/$route", body: {
        //TODO: Fill some body key
        });
        expect(response.statusCode, 400);
      }
    ''';
  }

  static String putEmptyBody400(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response=  await harness.agent.put("/$route", body: {});
        expect(response.statusCode, 400);
      }
    ''';
  }

  static String putRightBody200(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response=  await harness.agent.put("/$route", body: {
        //TODO: Fill body
        });
        expect(response.statusCode, 200);
      }
    ''';
  }

  static String delete200(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response = await harness.agent.delete("/$route/1");
        expect(response.statusCode, 200);
      }
      ''';
  }

  static String delete400(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response = await harness.agent.delete("/$route/");
        expect(response.statusCode, 400);
      }
      ''';
  }

  static String delete404(Table table) {
    var route = table.name.camelCase.pluralize;

    return '''
      () async {
        final response = await harness.agent.delete("/$route/2");
        expect(response.statusCode, 404);
      }
      ''';
  }
}
