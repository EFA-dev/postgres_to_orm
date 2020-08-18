import 'package:postgres_to_orm_example/postgres_to_orm_example.dart';
import 'package:postgres_to_orm_example/model/team_player.dart';

class Team extends ManagedObject<_Team> implements _Team {}

class _Team {
  @primaryKey
  int id;

  String name;

  ManagedSet<TeamPlayer> teamPlayers;
}
