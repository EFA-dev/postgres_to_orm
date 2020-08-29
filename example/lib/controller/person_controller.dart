import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/person.dart';

class PersonController extends ResourceController {
  PersonController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllPeople() async {
    final personQuery = Query<Person>(context);
    final people = await personQuery.fetch();
    return Response.ok(people);
  }

  @Operation.get('id')
  Future<Response> getPersonByID(@Bind.path('id') int id) async {
    final personQuery = Query<Person>(context)..where((x) => x.id).equalTo(id);
    final person = await personQuery.fetchOne();
    if (person == null) {
      return Response.notFound();
    }
    return Response.ok(person);
  }

  @Operation.post()
  Future<Response> addPerson(@Bind.body() Person person) async {
    final personQuery = Query<Person>(context)..values = person;
    final insertedPerson = await personQuery.insert();
    return Response.ok(insertedPerson);
  }

  @Operation.put('id')
  Future<Response> updatePerson(
      @Bind.path('id') int id, @Bind.body() Person person) async {
    final personQuery = Query<Person>(context)
      ..values = person
      ..where((x) => x.id).equalTo(id);
    final updatedPerson = await personQuery.updateOne();
    if (updatedPerson == null) {
      return Response.notFound();
    }
    return Response.ok(updatedPerson);
  }

  @Operation.delete('id')
  Future<Response> deletePerson(@Bind.path('id') int id) async {
    final personQuery = Query<Person>(context)..where((x) => x.id).equalTo(id);
    final int deletedPerson = await personQuery.delete();
    if (deletedPerson == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedPerson Person"};
    return Response.ok(response);
  }
}
