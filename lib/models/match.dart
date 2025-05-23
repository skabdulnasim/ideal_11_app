class MatchModel {
  final int id;
  final String title;
  final String startDate;
  final String startTime;
  final String ground;
  final String city;
  final String state;

  MatchModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.startTime,
    required this.ground,
    required this.city,
    required this.state,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      title: json['title'],
      startDate: json['start_date'],
      startTime: json['start_time'],
      ground: json['ground'],
      city: json['city'],
      state: json['state'],
    );
  }
}
