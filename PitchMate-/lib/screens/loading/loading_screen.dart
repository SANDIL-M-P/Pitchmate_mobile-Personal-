import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/loging/login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    // AnimationController for slower fade-in effect.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Increased fade duration
    );

    // Start fade-in animation.
    _fadeController.forward();

    // Navigate to login screen after 4 seconds.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the theme’s background color
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        // FadeTransition applies the slower fade-in effect.
        child: FadeTransition(
          opacity: _fadeController,
          child: Image.asset(
            'lib/images/pitchmate-logo.png',
            width: 300,
            height: 500,
            // fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
