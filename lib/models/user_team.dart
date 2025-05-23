import 'package:ideal11/models/user_team_player.dart';

class UserTeam {
  final int? id;
  final int userId;
  final int matchId;
  final String? title;
  final List<UserTeamPlayer> players;

  UserTeam({
    this.id,
    required this.userId,
    required this.matchId,
    this.title,
    required this.players,
  });

  Map<String, dynamic> toJson() => {
    "user_team": {
      "user_id": userId,
      "match_id": matchId,
      "title": title,
      "user_team_players_attributes": players.map((p) => p.toJson()).toList(),
    },
  };

  factory UserTeam.fromJson(Map<String, dynamic> json) {
    return UserTeam(
      id: json['id'],
      userId: json['user_id'],
      matchId: json['match_id'],
      title: json['title'],
      players: List<UserTeamPlayer>.from(
        json["user_team_players"].map((x) => UserTeamPlayer.fromJson(x)),
      ),
    );
  }
}
