// models/match.dart
class Match {
  final String opponent;
  final String date;
  final String location;

  Match({
    required this.opponent,
    required this.date,
    required this.location,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      opponent: json['opponent'],
      date: json['date'],
      location: json['location'],
    );
  }
}
