import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/team_player.dart';

class TeamPlayerController extends ResourceController {
  @Operation.get()
  Future<Response> getAllTeamPlayers() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getTeamPlayerByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addTeamPlayer(@Bind.body() TeamPlayer teamPlayer) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updateTeamPlayer(
      @Bind.path('id') int id, @Bind.body() TeamPlayer teamPlayer) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deleteTeamPlayer(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
