class Contest {
  final int id;
  final int matchId;
  final String title;
  final int allowedSporters;
  final double entryFee;
  final bool isGrandLeague;
  final bool oncePerUser;
  final double? prizePool;

  Contest({
    required this.id,
    required this.matchId,
    required this.title,
    required this.allowedSporters,
    required this.entryFee,
    required this.isGrandLeague,
    required this.oncePerUser,
    this.prizePool,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      matchId: json['match_id'],
      title: json['title'],
      allowedSporters: json['allowed_sporters'],
      entryFee: double.parse(json['entry_fee'].toString()),
      isGrandLeague: json['is_grand_league'],
      oncePerUser: json['once_per_user'],
      prizePool: double.parse(json['prize_pool'].toString()),
    );
  }
}
