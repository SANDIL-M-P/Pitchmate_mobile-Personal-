import 'package:flutter/material.dart';

class FeedbackDetailScreen extends StatelessWidget {
  final Map<String, dynamic> feedback;

  const FeedbackDetailScreen({Key? key, required this.feedback})
      : super(key: key);

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;

    final Gradient backgroundGradient = isDark
        ? LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          'Feedback Detail',
          style: TextStyle(
            color: primaryYellow,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: primaryYellow),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Staff Name & Role Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        feedback['staffName'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        feedback['role'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Date
                  Text(
                    'Date: ${feedback['date'] ?? ''}',
                    style: TextStyle(fontSize: 14, color: subTextColor),
                  ),
                  const SizedBox(height: 12),
                  // Star Rating Row
                  Row(
                    children: List.generate(5, (i) {
                      if (i < (feedback['rating'] as int)) {
                        return Icon(Icons.star, color: primaryYellow, size: 24);
                      } else {
                        return Icon(Icons.star_border,
                            color: subTextColor, size: 24);
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  // Full Message
                  Text(
                    feedback['message'] ?? '',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
