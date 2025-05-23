class ContestPrize {
  final int fromRank;
  final int toRank;
  final double prize;
  int? rankCount;
  double? prizePool;

  ContestPrize({
    required this.fromRank,
    required this.toRank,
    required this.prize,
    required rankCount,
    required prizePool,
  });

  factory ContestPrize.fromJson(Map<String, dynamic> json) {
    return ContestPrize(
      fromRank: json['from_rank'],
      toRank: json['to_rank'],
      prize: double.parse(json['prize_amount'].toString()),
      rankCount: (json['to_rank'] - json['from_rank']) + 1,
      prizePool:
          ((json['to_rank'] - json['from_rank']) + 1) *
          double.parse(json['prize_amount'].toString()),
    );
  }
}
