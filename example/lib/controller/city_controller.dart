import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/city.dart';

class CityController extends ResourceController {
  CityController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllCities() async {
    final cityQuery = Query<City>(context);
    final cities = await cityQuery.fetch();
    return Response.ok(cities);
  }

  @Operation.get('id')
  Future<Response> getCityByID(@Bind.path('id') int id) async {
    final cityQuery = Query<City>(context)..where((x) => x.id).equalTo(id);
    final city = await cityQuery.fetchOne();
    if (city == null) {
      return Response.notFound();
    }
    return Response.ok(city);
  }

  @Operation.post()
  Future<Response> addCity(@Bind.body() City city) async {
    final cityQuery = Query<City>(context)..values = city;
    final insertedCity = await cityQuery.insert();
    return Response.ok(insertedCity);
  }

  @Operation.put('id')
  Future<Response> updateCity(
      @Bind.path('id') int id, @Bind.body() City city) async {
    final cityQuery = Query<City>(context)
      ..values = city
      ..where((x) => x.id).equalTo(id);
    final updatedCity = await cityQuery.updateOne();
    if (updatedCity == null) {
      return Response.notFound();
    }
    return Response.ok(updatedCity);
  }

  @Operation.delete('id')
  Future<Response> deleteCity(@Bind.path('id') int id) async {
    final cityQuery = Query<City>(context)..where((x) => x.id).equalTo(id);
    final int deletedCity = await cityQuery.delete();
    if (deletedCity == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedCity City"};
    return Response.ok(response);
  }
}
