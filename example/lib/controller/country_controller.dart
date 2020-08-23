import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/country.dart';

class CountryController extends ResourceController {
  CountryController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllCountries() async {
    final countryQuery = Query<Country>(context);
    final countries = await countryQuery.fetch();
    return Response.ok(countries);
  }

  @Operation.get('id')
  Future<Response> getCountryByID(@Bind.path('id') int id) async {
    final countryQuery = Query<Country>(context)
      ..where((x) => x.id).equalTo(id);
    final country = await countryQuery.fetchOne();
    if (country == null) {
      return Response.notFound();
    }
    return Response.ok(country);
  }

  @Operation.post()
  Future<Response> addCountry(@Bind.body() Country country) async {
    final countryQuery = Query<Country>(context)..values = country;
    final insertedCountry = await countryQuery.insert();
    return Response.ok(insertedCountry);
  }

  @Operation.put('id')
  Future<Response> updateCountry(
      @Bind.path('id') int id, @Bind.body() Country country) async {
    final countryQuery = Query<Country>(context)
      ..values = country
      ..where((x) => x.id).equalTo(id);
    final updatedCountry = await countryQuery.updateOne();
    if (updatedCountry == null) {
      return Response.notFound();
    }
    return Response.ok(updatedCountry);
  }

  @Operation.delete('id')
  Future<Response> deleteCountry(@Bind.path('id') int id) async {
    final countryQuery = Query<Country>(context)
      ..where((x) => x.id).equalTo(id);
    final int deletedCountry = await countryQuery.delete();
    if (deletedCountry == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedCountry Country"};
    return Response.ok(response);
  }
}
