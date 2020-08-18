import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/team.dart';
import 'package:postgres_to_orm_example/model/player.dart';

class TeamPlayer extends ManagedObject<_TeamPlayer> implements _TeamPlayer {}

class _TeamPlayer {
  @primaryKey
  int id;

  @Relate(#teamPlayers)
  Team team;

  @Relate(#teamPlayers)
  Player player;
}
