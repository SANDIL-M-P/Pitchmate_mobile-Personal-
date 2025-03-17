import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/feedback/feedback_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // Make sure to add this dependency

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with TickerProviderStateMixin {
  // Nullable for loading state
  List<Map<String, dynamic>>? _feedbackList;
  String? error;

  // Animation controllers
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;
  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardSlideAnimation;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerController.forward();

    // Card slide animation
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Feedback items animation
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1000), // Increased duration for smoother animation
    );
    _feedbackAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );

    // Start card animation after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });

    // Simulate data loading with a delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _feedbackList = const [
          {
            'staffName': 'Coach Mike',
            'role': 'Coach',
            'rating': 4,
            'message':
                'Great performance in the last match, keep it up! Very consistent.',
            'date': 'Mar 10, 2025',
          },
          {
            'staffName': 'Dr. Smith',
            'role': 'Medical',
            'rating': 5,
            'message':
                'Excellent recovery from injury, well done. Keep following your training plan.',
            'date': 'Mar 12, 2025',
          },
          {
            'staffName': 'Coach John',
            'role': 'Coach',
            'rating': 3,
            'message':
                'Needs to work on stamina and consistency. Work on your endurance and fitness.',
            'date': 'Mar 15, 2025',
          },
        ];
        _feedbackController.forward();
      });
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardAnimationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;

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
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Animated "Feedback" header
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _headerAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _headerAnimation.value)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 24, right: 24),
                        child: Text(
                          'Feedback',
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: FeedbackScreen.primaryYellow,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Feedback content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SlideTransition(
                    position: _cardSlideAnimation,
                    child: error != null
                        ? Center(
                            child: Text(
                              "Error: $error",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          )
                        : _feedbackList == null
                            ? _buildShimmerFeedback(cardColor)
                            : _buildFeedbackList(
                                context, cardColor, textColor, subTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerFeedback(Color cardColor) {
    return ListView.builder(
      itemCount: 3, // Show 3 shimmer cards while loading
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar placeholder
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name placeholder
                          Container(
                            width: 120,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Role placeholder
                          Container(
                            width: 80,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Date placeholder
                          Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Message placeholder
                          Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 200,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow placeholder
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackList(
    BuildContext context,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return _feedbackList!.isEmpty
        ? Center(
            child: Text(
              "No feedback available",
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: _feedbackList!.length,
            itemBuilder: (context, index) {
              final feedback = _feedbackList![index];
              // Create a preview of the feedback message
              String previewMessage = feedback['message'] ?? '';
              if (previewMessage.length > 50) {
                previewMessage = '${previewMessage.substring(0, 50)}...';
              }

              // Fixed staggered animation for each feedback card
              return AnimatedBuilder(
                animation: _feedbackAnimation,
                builder: (context, child) {
                  // Calculate a more predictable animation value with fixed timing
                  final maxDelay = 0.4; // Max delay across all items
                  final itemDelay = (index / _feedbackList!.length) * maxDelay;
                  final animationValue =
                      (_feedbackAnimation.value - itemDelay).clamp(0.0, 1.0);

                  return Opacity(
                    opacity: animationValue,
                    child: Transform.translate(
                      offset: Offset(50 * (1 - animationValue), 0),
                      child: child!,
                    ),
                  );
                },
                child: _buildFeedbackCard(
                  context,
                  feedback,
                  previewMessage,
                  cardColor,
                  textColor,
                  subTextColor,
                ),
              );
            },
          );
  }

  // Individual feedback card
  Widget _buildFeedbackCard(
    BuildContext context,
    Map<String, dynamic> feedback,
    String previewMessage,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedbackDetailScreen(feedback: feedback),
            ),
          );
        },
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  backgroundColor:
                      FeedbackScreen.primaryYellow.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: FeedbackScreen.primaryYellow,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback['staffName'] ?? '',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        feedback['role'] ?? '',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: subTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${feedback['date'] ?? ''}',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: subTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        previewMessage,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: FeedbackScreen.primaryYellow,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
