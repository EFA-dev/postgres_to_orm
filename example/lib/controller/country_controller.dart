import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/country.dart';

class CountryController extends ResourceController {
  @Operation.get()
  Future<Response> getAllCountries() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getCountryByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addCountry(@Bind.body() Country country) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateCountry(
      @Bind.path('id') int id, @Bind.body() Country country) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteCountry(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
