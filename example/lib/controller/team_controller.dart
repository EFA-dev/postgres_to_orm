import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/team.dart';

class TeamController extends ResourceController {
  TeamController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllTeams() async {
    final teamQuery = Query<Team>(context);
    final teams = await teamQuery.fetch();
    return Response.ok(teams);
  }

  @Operation.get('id')
  Future<Response> getTeamByID(@Bind.path('id') int id) async {
    final teamQuery = Query<Team>(context)..where((x) => x.id).equalTo(id);
    final team = await teamQuery.fetchOne();
    if (team == null) {
      return Response.notFound();
    }
    return Response.ok(team);
  }

  @Operation.post()
  Future<Response> addTeam(@Bind.body() Team team) async {
    final teamQuery = Query<Team>(context)..values = team;
    final insertedTeam = await teamQuery.insert();
    return Response.ok(insertedTeam);
  }

  @Operation.put('id')
  Future<Response> updateTeam(
      @Bind.path('id') int id, @Bind.body() Team team) async {
    final teamQuery = Query<Team>(context)
      ..values = team
      ..where((x) => x.id).equalTo(id);
    final updatedTeam = await teamQuery.updateOne();
    if (updatedTeam == null) {
      return Response.notFound();
    }
    return Response.ok(updatedTeam);
  }

  @Operation.delete('id')
  Future<Response> deleteTeam(@Bind.path('id') int id) async {
    final teamQuery = Query<Team>(context)..where((x) => x.id).equalTo(id);
    final int deletedTeam = await teamQuery.delete();
    if (deletedTeam == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedTeam Team"};
    return Response.ok(response);
  }
}
