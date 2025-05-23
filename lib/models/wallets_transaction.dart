class WalletsTransaction {
  String transactionType;
  String amount;
  String description;
  DateTime createdAt;

  WalletsTransaction({
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory WalletsTransaction.fromJson(Map<String, dynamic> json) =>
      WalletsTransaction(
        transactionType: json["transaction_type"],
        amount: json["amount"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "transaction_type": transactionType,
    "amount": amount,
    "description": description,
    "created_at": createdAt.toIso8601String(),
  };
}
