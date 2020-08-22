import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/person.dart';

class PersonController extends ResourceController {
  @Operation.get()
  Future<Response> getAllPeople() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getPersonByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addPerson(@Bind.body() Person person) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updatePerson(
      @Bind.path('id') int id, @Bind.body() Person person) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deletePerson(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
