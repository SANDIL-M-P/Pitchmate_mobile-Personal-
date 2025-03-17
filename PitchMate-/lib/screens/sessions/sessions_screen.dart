import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/doctor/doctor_booking_screen.dart';
import 'package:flutter_application_1/screens/sessions/session_detail_screen.dart';
import 'package:flutter_application_1/services/sessions_api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with TickerProviderStateMixin {
  List<Map<String, String>>? sessions; // Nullable list to hold sessions
  String? error; // To handle API errors
  final SessionsApiService _apiService = SessionsApiService();

  // Overall screen animation controllers
  late AnimationController _mainAnimController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideFromTopAnimation;

  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardSlideAnimation;

  // Animation controllers and animations
  late AnimationController _quickInfoController;
  late Animation<double> _quickInfoAnimation1;
  late Animation<double> _quickInfoAnimation2;
  late AnimationController _sessionsController;
  late Animation<double> _sessionsAnimation;

  @override
  void initState() {
    super.initState();
    _loadSessions(); // Fetch data when the widget initializes

    // Quick info row animations
    _quickInfoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _quickInfoAnimation1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickInfoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _quickInfoAnimation2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quickInfoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
    _quickInfoController.forward(); // Start the animation when the screen loads

    // Sessions list animation
    _sessionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sessionsAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sessionsController, curve: Curves.easeInOut),
    );

    // Overall screen animations matching the Stats screen
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _slideFromTopAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOutQuint),
      ),
    );
    _mainAnimController.forward();

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
// Start the card animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _cardAnimationController.forward();
    });
  }

  // Asynchronous method to load sessions
  void _loadSessions() async {
    try {
      final data = await _apiService.fetchUpcomingSessions();
      setState(() {
        sessions = data; // Update sessions when data is received
        _sessionsController.forward(); // Start sessions list animation
      });
    } catch (e) {
      setState(() {
        error = e.toString(); // Set error if the API call fails
      });
    }
  }

  @override
  void dispose() {
    _quickInfoController.dispose();
    _sessionsController.dispose();
    _mainAnimController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;
    final Color headerContainerColor =
        isDark ? Colors.grey[900]! : Colors.grey[200]!;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color containerColor = isDark ? Colors.grey[900]! : Colors.grey[200]!;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _cardAnimationController,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
          ),
          child: Text(
            'Sessions & Bookings',
            style: GoogleFonts.lato(
              color: SessionsScreen.primaryYellow,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideFromTopAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Add some spacing at the top to compensate for the AppBar
                    const SizedBox(height: 20),

                    // Quick info row with staggered animation
                    _buildQuickInfoRow(
                      cardColor,
                      subTextColor,
                      textColor,
                      error != null
                          ? 'Error'
                          : (sessions?.length.toString() ?? 'Loading...'),
                    ),
                    const SizedBox(height: 24),

                    // Upcoming sessions section
                    if (error != null)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, opacity, child) {
                          return Opacity(
                            opacity: opacity,
                            child: Center(
                              child: Text(
                                'Error: $error',
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          );
                        },
                      )
                    else if (sessions == null)
                      SlideTransition(
                        position: _cardSlideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upcoming Activities',
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: SessionsScreen.primaryYellow,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return _buildShimmerSessionCard(cardColor);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      _buildUpcomingSessionsSection(
                        context,
                        cardColor,
                        subTextColor,
                        textColor,
                        sessions!,
                      ),
                    const SizedBox(height: 24),

                    // Doctor booking section
                    (sessions == null && error == null)
                        ? _buildShimmerDoctorBooking(containerColor)
                        : _buildDoctorBookingSection(
                            context,
                            containerColor,
                            subTextColor,
                            textColor,
                          ),
                    // Add some extra space at the bottom
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header container with fade-in animation.
  Widget _buildHeader(Color headerContainerColor) {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardAnimationController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              headerContainerColor,
              headerContainerColor.withOpacity(0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          'Sessions and Doctor Booking',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SessionsScreen.primaryYellow,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Row displaying quick info cards with staggered animation.
  Widget _buildQuickInfoRow(
    Color cardColor,
    Color subTextColor,
    Color textColor,
    String upcomingValue,
  ) {
    // If we're still loading (sessions is null and no error), show shimmer effect
    final bool isLoading = sessions == null && error == null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedBuilder(
          animation: _quickInfoAnimation1,
          builder: (context, child) {
            return Opacity(
              opacity: _quickInfoAnimation1.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _quickInfoAnimation1.value)),
                child: isLoading
                    ? _buildShimmerInfoCard()
                    : _buildInfoCard(
                        label: 'Upcoming',
                        value: upcomingValue,
                        icon: Icons.event_available,
                        cardColor: cardColor,
                        iconColor: SessionsScreen.primaryYellow,
                        subTextColor: subTextColor,
                        textColor: textColor,
                      ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _quickInfoAnimation2,
          builder: (context, child) {
            return Opacity(
              opacity: _quickInfoAnimation2.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _quickInfoAnimation2.value)),
                child: isLoading
                    ? _buildShimmerInfoCard()
                    : _buildInfoCard(
                        label: 'Past',
                        value: '10',
                        icon: Icons.event_note,
                        cardColor: cardColor,
                        iconColor: SessionsScreen.primaryYellow,
                        subTextColor: subTextColor,
                        textColor: textColor,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Single info card widget.
  /// Changed here: replaced `Expanded` with `SizedBox(width: ...)`
  Widget _buildInfoCard({
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color iconColor,
    required Color subTextColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: 140, // Give both cards a uniform width
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 12),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: subTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Horizontally scrollable list for upcoming sessions with slide-in animation.
  Widget _buildUpcomingSessionsSection(
    BuildContext context,
    Color cardColor,
    Color subTextColor,
    Color textColor,
    List<Map<String, String>> sessions,
  ) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Activities',
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SessionsScreen.primaryYellow,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return AnimatedBuilder(
                  animation: _sessionsAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _sessionsAnimation.value,
                      child: Transform.translate(
                        offset: Offset(50 * (1 - _sessionsAnimation.value), 0),
                        child: _buildSessionCard(context, session, cardColor,
                            subTextColor, textColor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Card for an individual session with navigation to details.
  Widget _buildSessionCard(
    BuildContext context,
    Map<String, String> session,
    Color cardColor,
    Color subTextColor,
    Color textColor,
  ) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SessionDetailScreen(session: session),
            ),
          );
        },
        child: Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: SessionsScreen.primaryYellow.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'] ?? 'Activity Title',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${session['date'] ?? ''}',
                  style: GoogleFonts.lato(color: subTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Time: ${session['time'] ?? ''}',
                  style: GoogleFonts.lato(color: subTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Location: ${session['location'] ?? ''}',
                  style: GoogleFonts.lato(color: subTextColor),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: SessionsScreen.primaryYellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section for booking a doctor visit with fade-in animation.
  Widget _buildDoctorBookingSection(
    BuildContext context,
    Color containerColor,
    Color subTextColor,
    Color textColor,
  ) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Doctor Visit',
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SessionsScreen.primaryYellow,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: SessionsScreen.primaryYellow,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need a check-up?',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Book a doctor visit or check previous appointments.',
                        style: GoogleFonts.lato(
                          color: subTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DoctorBookingScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SessionsScreen.primaryYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSessionCard(Color colorScheme) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerInfoCard() {
    return SizedBox(
      width: 140,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerDoctorBooking(Color colorScheme) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
