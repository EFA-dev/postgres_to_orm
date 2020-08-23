import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/team_player.dart';

class TeamPlayerController extends ResourceController {
  TeamPlayerController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllTeamPlayers() async {
    final teamPlayerQuery = Query<TeamPlayer>(context);
    final teamPlayers = await teamPlayerQuery.fetch();
    return Response.ok(teamPlayers);
  }

  @Operation.get('id')
  Future<Response> getTeamPlayerByID(@Bind.path('id') int id) async {
    final teamPlayerQuery = Query<TeamPlayer>(context)
      ..where((x) => x.id).equalTo(id);
    final teamPlayer = await teamPlayerQuery.fetchOne();
    if (teamPlayer == null) {
      return Response.notFound();
    }
    return Response.ok(teamPlayer);
  }

  @Operation.post()
  Future<Response> addTeamPlayer(@Bind.body() TeamPlayer teamPlayer) async {
    final teamPlayerQuery = Query<TeamPlayer>(context)..values = teamPlayer;
    final insertedTeamPlayer = await teamPlayerQuery.insert();
    return Response.ok(insertedTeamPlayer);
  }

  @Operation.put('id')
  Future<Response> updateTeamPlayer(
      @Bind.path('id') int id, @Bind.body() TeamPlayer teamPlayer) async {
    final teamPlayerQuery = Query<TeamPlayer>(context)
      ..values = teamPlayer
      ..where((x) => x.id).equalTo(id);
    final updatedTeamPlayer = await teamPlayerQuery.updateOne();
    if (updatedTeamPlayer == null) {
      return Response.notFound();
    }
    return Response.ok(updatedTeamPlayer);
  }

  @Operation.delete('id')
  Future<Response> deleteTeamPlayer(@Bind.path('id') int id) async {
    final teamPlayerQuery = Query<TeamPlayer>(context)
      ..where((x) => x.id).equalTo(id);
    final int deletedTeamPlayer = await teamPlayerQuery.delete();
    if (deletedTeamPlayer == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedTeamPlayer TeamPlayer"};
    return Response.ok(response);
  }
}
