import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/team.dart';

class TeamController extends ResourceController {
  @Operation.get()
  Future<Response> getAllTeams() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getTeamByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addTeam(@Bind.body() Team team) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateTeam(
      @Bind.path('id') int id, @Bind.body() Team team) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteTeam(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
