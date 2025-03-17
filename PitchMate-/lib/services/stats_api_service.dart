// services/stats_api_service.dart
import 'dart:async';

class StatsApiService {
  Future<Map<String, dynamic>> fetchStats(int type) async {
    // Simulate fetching stats from an API
    await Future.delayed(const Duration(seconds: 1));
    return {
      'innings': 10,
      'runs': 500,
      'average': 50.0,
      'balls': 300,
      'catches': 5,
      'runOuts': 2,
      'stumpings': 1,
      'dismissals': 8,
    };
  }

  Future<Map<String, dynamic>> fetchBowlingStats() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'innings': 10,
      'runs': 560,
      'average': 30.0,
      'balls': 400,
    };
  }

  Future<Map<String, dynamic>> fetchFieldingStats() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'catches': 15,
      'runOuts': 3,
      'stumpings': 2,
      'dismissals': 5,
    };
  }
}
