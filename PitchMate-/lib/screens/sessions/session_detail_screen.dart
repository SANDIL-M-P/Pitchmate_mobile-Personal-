import 'package:flutter/material.dart';

class SessionDetailScreen extends StatefulWidget {
  final Map<String, String> session;

  const SessionDetailScreen({Key? key, required this.session})
      : super(key: key);

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  late Future<Map<String, String>> _sessionDetailFuture;

  @override
  void initState() {
    super.initState();
    // Simulate fetching additional session details from an API.
    _sessionDetailFuture = _fetchSessionDetails(widget.session);
  }

  Future<Map<String, String>> _fetchSessionDetails(
      Map<String, String> session) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Optionally, you can merge in additional details here.
    return session;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black54;
    final Color dividerColor = isDark ? Colors.white38 : Colors.grey;

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
        // Use a FutureBuilder in the app bar to display the title when loaded.
        title: FutureBuilder<Map<String, String>>(
          future: _sessionDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Loading...',
                style: TextStyle(
                  color: SessionDetailScreen.primaryYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error',
                style: TextStyle(
                  color: SessionDetailScreen.primaryYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              );
            }
            final title = snapshot.data?['title'] ?? 'Unknown';
            return Text(
              title,
              style: TextStyle(
                color: SessionDetailScreen.primaryYellow,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            );
          },
        ),
        iconTheme:
            const IconThemeData(color: SessionDetailScreen.primaryYellow),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<Map<String, String>>(
          future: _sessionDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                "Error loading session details",
                style: TextStyle(color: textColor),
              ));
            } else if (!snapshot.hasData) {
              return Center(
                  child: Text(
                "No session details available",
                style: TextStyle(color: textColor),
              ));
            }
            final session = snapshot.data!;
            final String date = session['date'] ?? 'Unknown';
            final String time = session['time'] ?? 'Unknown';
            final String location = session['location'] ?? 'Unknown';

            return SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: SessionDetailScreen.primaryYellow,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          detail: date,
                          textColor: textColor,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.access_time,
                          detail: time,
                          textColor: textColor,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          detail: location,
                          textColor: textColor,
                        ),
                        const SizedBox(height: 24),
                        Divider(color: dividerColor, thickness: 1),
                        const SizedBox(height: 24),
                        Text(
                          'Additional Info',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: SessionDetailScreen.primaryYellow,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Here you can list more details about the session, such as the coach or doctor in charge, instructions, or what players need to bring.',
                          style: TextStyle(fontSize: 16, color: subTextColor),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _confirmJoinSession(context),
                            icon: Icon(
                              Icons.check_circle_outline,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                            label: Text(
                              'Join Session',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  SessionDetailScreen.primaryYellow,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String detail,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: SessionDetailScreen.primaryYellow),
        const SizedBox(width: 12),
        Text(
          detail,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ],
    );
  }

  void _confirmJoinSession(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Join'),
          content: const Text('Are you sure you want to join this session?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('You have joined this session!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SessionDetailScreen.primaryYellow,
              ),
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }
}
