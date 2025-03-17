import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart'; // Make sure to add this dependency

class MatchersScreen extends StatefulWidget {
  const MatchersScreen({Key? key}) : super(key: key);

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  _MatchersScreenState createState() => _MatchersScreenState();
}

class _MatchersScreenState extends State<MatchersScreen>
    with TickerProviderStateMixin {
  // Dummy data for matches.
  List<Map<String, String>>? _matches; // Change to nullable to simulate loading
  String? error; // To handle potential errors

  // Animation controllers
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;
  late AnimationController _matchesController;
  late Animation<double> _matchesAnimation;

  // Add card slide animation controller similar to SessionsScreen
  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _headerAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );

    // Matches list animation
    _matchesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _matchesAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _matchesController, curve: Curves.easeInOut),
    );

    // Add card animation controller similar to SessionsScreen
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

    // Start animations
    _headerController.forward();

    // Simulate data loading with a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _matches = const [
          {
            'matchID': 'M001',
            'date': '2025-03-25',
            'result': 'Win',
            'venue': 'National Stadium',
            'opponent': 'Team A',
          },
          {
            'matchID': 'M002',
            'date': '2025-04-10',
            'result': 'Loss',
            'venue': 'City Field',
            'opponent': 'Team B',
          },
        ];
        _matchesController.forward();
      });
    });

    // Start card animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _matchesController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;
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
              // Animated header
              AnimatedBuilder(
                animation: _headerAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _headerAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _headerAnimation.value)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Matches',
                          style: GoogleFonts.lato(
                            color: MatchersScreen.primaryYellow,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Match list with loading state
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _cardSlideAnimation,
                        child: Text(
                          'Recent Matches',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MatchersScreen.primaryYellow,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Conditionally show shimmer or actual content
                      Expanded(
                        child: error != null
                            ? Center(
                                child: Text(
                                  'Error: $error',
                                  style: TextStyle(color: textColor),
                                ),
                              )
                            : _matches == null
                                ? _buildShimmerMatchesList(cardColor)
                                : _buildMatchesList(
                                    cardColor, textColor, subTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer effect during loading
  Widget _buildShimmerMatchesList(Color cardColor) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: ListView.separated(
        itemCount: 3, // Show 3 shimmer cards while loading
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildShimmerMatchCard(cardColor);
        },
      ),
    );
  }

  // Shimmer card for loading state
  Widget _buildShimmerMatchCard(Color cardColor) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        color: cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon circle placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              // Match details placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 110,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon placeholder
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
    );
  }

  // Actual match list with animation
  Widget _buildMatchesList(
      Color cardColor, Color textColor, Color subTextColor) {
    return ListView.separated(
      itemCount: _matches?.length ?? 0,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final match = _matches![index];
        // Staggered animation for each match card
        return AnimatedBuilder(
          animation: _matchesAnimation,
          builder: (context, child) {
            // Calculate the animation value with staggering effect
            final delay = index * 0.2;
            final startTime = delay;
            final endTime = startTime + 0.8;

            // Calculate the animation value accounting for the stagger
            double animationValue = 0.0;
            if (_matchesAnimation.value >= startTime &&
                _matchesAnimation.value <= endTime) {
              animationValue =
                  (_matchesAnimation.value - startTime) / (endTime - startTime);
            } else if (_matchesAnimation.value > endTime) {
              animationValue = 1.0;
            }

            return Opacity(
              opacity: animationValue,
              child: Transform.translate(
                offset: Offset(50 * (1 - animationValue), 0),
                child:
                    _buildMatchCard(match, cardColor, textColor, subTextColor),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMatchCard(
    Map<String, String> match,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return InkWell(
      onTap: () {
        // Optionally, navigate to a detailed match screen.
      },
      child: Card(
        color: cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon indicating match result.
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: MatchersScreen.primaryYellow.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    match['result'] == 'Win'
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: MatchersScreen.primaryYellow,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Match details.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Match ID: ${match['matchID'] ?? ''}',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${match['date'] ?? ''}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Result: ${match['result'] ?? ''}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Venue: ${match['venue'] ?? ''}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Opponent: ${match['opponent'] ?? ''}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: MatchersScreen.primaryYellow,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
