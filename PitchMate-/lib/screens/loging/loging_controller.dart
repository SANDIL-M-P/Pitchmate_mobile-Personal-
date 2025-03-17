import 'dart:async';

/// This controller fakes a login call that always takes 2 seconds.
/// You can customize the success/failure logic as needed.
class LogingController {
  Future<bool> signIn(String username, String password) async {
    // Simulate a "network delay"
    await Future.delayed(const Duration(seconds: 2));

    // Fake validation logic:
    // e.g., only "player1" with password "pitchmate" can log in successfully
    if (username == 'player1' && password == 'pitchmate') {
      return true; // "Login successful"
    } else {
      return false; // "Login failed"
    }
  }
}
