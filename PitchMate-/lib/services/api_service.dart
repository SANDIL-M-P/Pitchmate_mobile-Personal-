// services/api_service.dart
import 'dart:async';
import '../models/player_stats.dart';
import '../models/match.dart';

class ApiService {
  // Simulated fetch for player stats with a delay
  Future<PlayerStats> fetchPlayerStats() async {
    // Simulate network latency
    await Future.delayed(Duration(seconds: 2));
    final jsonData = {
      'name': 'Sandil Manmitha',
      'position': 'Pitcher',
      'games': 15,
      'wins': 8,
      'losses': 4,
      'era': 2.45,
    };
    return PlayerStats.fromJson(jsonData);
  }

  // Simulated fetch for upcoming matches with a delay
  Future<List<Match>> fetchUpcomingMatches() async {
    await Future.delayed(Duration(seconds: 2));
    final jsonList = [
      {
        'opponent': 'Tigers',
        'date': 'March 25, 2025',
        'location': 'National Stadium',
      },
      {
        'opponent': 'Hawks',
        'date': 'April 2, 2025',
        'location': 'City Field',
      }
    ];
    return jsonList.map((json) => Match.fromJson(json)).toList();
  }

  // You can also simulate create, update, and delete operations in a similar manner.
  // For example:
  Future<bool> createMatch(Match match) async {
    await Future.delayed(Duration(seconds: 1));
    // Assume success
    return true;
  }
}
