import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/player.dart';

class PlayerController extends ResourceController {
  PlayerController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllPlayers() async {
    final playerQuery = Query<Player>(context);
    final players = await playerQuery.fetch();
    return Response.ok(players);
  }

  @Operation.get('id')
  Future<Response> getPlayerByID(@Bind.path('id') int id) async {
    final playerQuery = Query<Player>(context)..where((x) => x.id).equalTo(id);
    final player = await playerQuery.fetchOne();
    if (player == null) {
      return Response.notFound();
    }
    return Response.ok(player);
  }

  @Operation.post()
  Future<Response> addPlayer(@Bind.body() Player player) async {
    final playerQuery = Query<Player>(context)..values = player;
    final insertedPlayer = await playerQuery.insert();
    return Response.ok(insertedPlayer);
  }

  @Operation.put('id')
  Future<Response> updatePlayer(
      @Bind.path('id') int id, @Bind.body() Player player) async {
    final playerQuery = Query<Player>(context)
      ..values = player
      ..where((x) => x.id).equalTo(id);
    final updatedPlayer = await playerQuery.updateOne();
    if (updatedPlayer == null) {
      return Response.notFound();
    }
    return Response.ok(updatedPlayer);
  }

  @Operation.delete('id')
  Future<Response> deletePlayer(@Bind.path('id') int id) async {
    final playerQuery = Query<Player>(context)..where((x) => x.id).equalTo(id);
    final int deletedPlayer = await playerQuery.delete();
    if (deletedPlayer == 0) {
      return Response.notFound();
    }
    final response = {"message": "deleted $deletedPlayer Player"};
    return Response.ok(response);
  }
}
