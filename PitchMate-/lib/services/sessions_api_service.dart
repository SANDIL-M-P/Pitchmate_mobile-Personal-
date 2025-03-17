// sessions_api_service.dart
import 'dart:async';

class SessionsApiService {
  Future<List<Map<String, String>>> fetchUpcomingSessions() async {
    // Simulate network latency.
    await Future.delayed(const Duration(seconds: 2));
    return const [
      {
        'title': 'Morning Practice',
        'date': 'March 01, 2025',
        'time': '8:00 AM - 10:00 AM',
        'location': 'City Field',
      },
      {
        'title': 'Friendly Match',
        'date': 'March 05, 2025',
        'time': '5:00 PM - 7:00 PM',
        'location': 'Local Stadium',
      },
      {
        'title': 'Doctor Check-Up',
        'date': 'March 10, 2025',
        'time': '10:00 AM',
        'location': 'Team Clinic',
      },
    ];
  }
}
