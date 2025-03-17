import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/stats_api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);
  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> _battingStatsFuture;
  late Future<Map<String, dynamic>> _bowlingStatsFuture;
  late Future<Map<String, dynamic>> _fieldingStatsFuture;
  final StatsApiService _apiService = StatsApiService();

  // Animation controller for the cards (already used)
  late AnimationController _cardAnimationController;
  late Animation<Offset> _cardSlideAnimation;

  // Overall screen animation controllers
  late AnimationController _mainAnimController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideFromTopAnimation;

  @override
  void initState() {
    super.initState();
    _battingStatsFuture = _simulateApiCall(1);
    _bowlingStatsFuture = _simulateApiCall(2);
    _fieldingStatsFuture = _simulateApiCall(3);

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

    // Overall screen animations matching the Home screen
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
  }

  Future<Map<String, dynamic>> _simulateApiCall(int type) async {
    await Future.delayed(const Duration(seconds: 1));
    return _apiService.fetchStats(type);
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _mainAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true, // Add this line
      backgroundColor: colorScheme.surface,
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
            'Your Performance',
            style: GoogleFonts.lato(
              color: StatsScreen.primaryYellow,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: true,
        // Remove the flexibleSpace property
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.black]
                : [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter, // Change to match HomeScreen
            end: Alignment.bottomCenter, // Change to match HomeScreen
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideFromTopAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildStatsSection(
                      future: _battingStatsFuture,
                      title: 'Batting Stats',
                      icon: Icons.sports_cricket,
                      colorScheme: colorScheme,
                      labels: ['Innings', 'Runs', 'Avg', 'Balls'],
                      statsKeys: ['innings', 'runs', 'average', 'balls'],
                    ),
                    const SizedBox(height: 24),
                    _buildStatsSection(
                      future: _bowlingStatsFuture,
                      title: 'Bowling Stats',
                      icon: Icons.sports_baseball,
                      colorScheme: colorScheme,
                      labels: ['Innings', 'Runs', 'Avg', 'Balls'],
                      statsKeys: ['innings', 'runs', 'average', 'balls'],
                    ),
                    const SizedBox(height: 24),
                    _buildStatsSection(
                      future: _fieldingStatsFuture,
                      title: 'Fielding Stats',
                      icon: Icons.shield,
                      colorScheme: colorScheme,
                      labels: [
                        'Catches',
                        'Run Outs',
                        'Stumpings',
                        'Dismissals'
                      ],
                      statsKeys: [
                        'catches',
                        'runOuts',
                        'stumpings',
                        'dismissals'
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildPerformanceChart(colorScheme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection({
    required Future<Map<String, dynamic>> future,
    required String title,
    required IconData icon,
    required ColorScheme colorScheme,
    required List<String> labels,
    required List<String> statsKeys,
  }) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: FutureBuilder<Map<String, dynamic>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerCard(colorScheme);
          } else if (snapshot.hasError) {
            return _buildErrorCard(snapshot.error.toString(), colorScheme);
          } else if (!snapshot.hasData) {
            return _buildEmptyCard(title, colorScheme);
          } else {
            return _buildAnimatedStatsCard(
              title: title,
              icon: icon,
              stats: snapshot.data!,
              labels: labels,
              statsKeys: statsKeys,
              colorScheme: colorScheme,
            );
          }
        },
      ),
    );
  }

  Widget _buildShimmerCard(ColorScheme colorScheme) {
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.onSurface.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: colorScheme.surface,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error, ColorScheme colorScheme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.onErrorContainer,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String title, ColorScheme colorScheme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'No $title found',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStatsCard({
    required String title,
    required IconData icon,
    required Map<String, dynamic> stats,
    required List<String> labels,
    required List<String> statsKeys,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: () {
        // Add any tap functionality here
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        shadowColor: StatsScreen.primaryYellow.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                StatsScreen.primaryYellow.withOpacity(0.15),
                colorScheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: StatsScreen.primaryYellow,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      icon,
                      color: StatsScreen.primaryYellow,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  thickness: 1.5,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return _buildAnimatedStatItem(
                      label: labels[index],
                      value: stats[statsKeys[index]].toString(),
                      colorScheme: colorScheme,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedStatItem({
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: double.parse(value)),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            Text(
              animatedValue.toInt().toString(),
              style: GoogleFonts.lato(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: StatsScreen.primaryYellow,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPerformanceChart(ColorScheme colorScheme) {
    return SlideTransition(
      position: _cardSlideAnimation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        shadowColor: StatsScreen.primaryYellow.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerHighest,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Trend',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: StatsScreen.primaryYellow,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  return LineTooltipItem(
                                    '${touchedSpot.y.toInt()} Runs',
                                    TextStyle(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 20,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: colorScheme.onSurface.withOpacity(0.05),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: colorScheme.onSurface.withOpacity(0.05),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Inn ${value.toInt()}',
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          minX: 1,
                          maxX: 10,
                          minY: 0,
                          maxY: 120,
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(1, 30 * value),
                                FlSpot(2, 45 * value),
                                FlSpot(3, 60 * value),
                                FlSpot(4, 50 * value),
                                FlSpot(5, 70 * value),
                                FlSpot(6, 40 * value),
                                FlSpot(7, 90 * value),
                                FlSpot(8, 30 * value),
                                FlSpot(9, 100 * value),
                                FlSpot(10, 50 * value),
                              ],
                              isCurved: true,
                              curveSmoothness: 0.3,
                              color: StatsScreen.primaryYellow,
                              barWidth: 4,
                              dotData: FlDotData(
                                show: value ==
                                    1.0, // Only show dots at the end of animation
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: StatsScreen.primaryYellow,
                                    strokeWidth: 3,
                                    strokeColor: colorScheme.surface,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    StatsScreen.primaryYellow
                                        .withOpacity(0.4 * value),
                                    StatsScreen.primaryYellow
                                        .withOpacity(0.1 * value),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
