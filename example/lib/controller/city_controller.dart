import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/city.dart';

class CityController extends ResourceController {
  @Operation.get()
  Future<Response> getAllCities() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getCityByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addCity(@Bind.body() City city) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateCity(
      @Bind.path('id') int id, @Bind.body() City city) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteCity(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
