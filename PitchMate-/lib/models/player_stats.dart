// models/player_stats.dart
class PlayerStats {
  final String name;
  final String position;
  final int games;
  final int wins;
  final int losses;
  final double era;

  PlayerStats({
    required this.name,
    required this.position,
    required this.games,
    required this.wins,
    required this.losses,
    required this.era,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      name: json['name'],
      position: json['position'],
      games: json['games'],
      wins: json['wins'],
      losses: json['losses'],
      era: (json['era'] as num).toDouble(),
    );
  }
}
