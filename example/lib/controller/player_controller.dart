import 'package:aqueduct/aqueduct.dart';
import 'package:postgres_to_orm_example/model/player.dart';

class PlayerController extends ResourceController {
  @Operation.get()
  Future<Response> getAllPlayers() async {
    return Response.ok("");
  }

  @Operation.get('id')
  Future<Response> getPlayerByID(@Bind.path('id') int id) async {
    return Response.ok("");
  }

  @Operation.post()
  Future<Response> addPlayer(@Bind.body() Player player) async {
    return Response.ok("");
  }

  @Operation.put('id')
  Future<Response> updatePlayer(
      @Bind.path('id') int id, @Bind.body() Player player) async {
    return Response.ok("");
  }

  @Operation.delete('id')
  Future<Response> deletePlayer(@Bind.path('id') int id) async {
    return Response.ok("");
  }
}
