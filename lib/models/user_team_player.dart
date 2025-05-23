class UserTeamPlayer {
  final int? id;
  final int matchTeamPlayerId;
  final bool isCaptain;
  final bool isViceCaptain;

  UserTeamPlayer({
    this.id,
    required this.matchTeamPlayerId,
    this.isCaptain = false,
    this.isViceCaptain = false,
  });

  Map<String, dynamic> toJson() => {
    "match_team_player_id": matchTeamPlayerId,
    "is_c": isCaptain,
    "is_vc": isViceCaptain,
  };

  factory UserTeamPlayer.fromJson(Map<String, dynamic> json) => UserTeamPlayer(
    id: json["id"],
    matchTeamPlayerId: json["match_team_player_id"],
    isCaptain: json["is_c"],
    isViceCaptain: json["is_vc"],
  );
}
