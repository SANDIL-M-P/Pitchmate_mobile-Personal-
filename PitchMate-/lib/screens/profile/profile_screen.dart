import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Dummy data representing the logged-in player's details.
  final String _username = 'player1';
  final String _fullName = 'John Doe';
  final String _email = 'player1@pitchmate.com';
  final String _contact = '123-456-7890';
  final String _profilePLC = 'Advanced Player PLC';
  final String _playerRole = 'Batsman';
  // New fields
  final String _birthday = '01-Jan-1990';
  final String _age = '30';
  final String _yearJoined = '2015';
  final String _battingStyle = 'Right-handed';
  final String _bowlingStyle = 'Right-arm Fast';
  final String _education = 'Springfield High';
  final String _team = 'ODI, T20, Test';

  // Dummy achievements list.
  final List<Map<String, dynamic>> _achievements = const [
    {
      'title': 'Top Scorer',
      'matchOpponent': 'Tigers',
      'matchLocation': 'National Stadium',
    },
    {
      'title': 'Best Fielder',
      'matchOpponent': 'Hawks',
      'matchLocation': 'City Field',
    },
  ];

  static const Color primaryYellow = Color(0xFFF5A623);

  @override
  Widget build(BuildContext context) {
    // Detect current theme.
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Profile',
          style: TextStyle(color: primaryYellow),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryYellow),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {
              // TODO: Implement edit profile flow.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Edit Profile not implemented yet!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              // TODO: Implement settings flow.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings not implemented yet!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header (Avatar, Name, Email)
            _buildHeaderSection(textColor),
            const SizedBox(height: 20),
            // Expanded Profile Information
            _buildProfileInfoSection(textColor, subTextColor),
            const SizedBox(height: 20),
            // Achievements Section
            _buildAchievementsSection(textColor, subTextColor),
            const SizedBox(height: 20),
            // Logout Button
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  /// Fixed header: Profile detail (avatar, name, email).
  Widget _buildHeaderSection(Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Circle Avatar.
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 16),
          // Welcome text and player details.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryYellow,
                ),
              ),
              Text(
                'Username: $_username',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              Text(
                'Email: $_email',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Expanded Profile Info: Shows contact, profilePLC, role and new fields.
  Widget _buildProfileInfoSection(Color textColor, Color subTextColor) {
    return Card(
      color: Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact: $_contact',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Profile PLC: $_profilePLC',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Role: $_playerRole',
                style: TextStyle(fontSize: 16, color: textColor)),
            const Divider(height: 24, color: Colors.white38),
            // New fields.
            Text('Birthday: $_birthday',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Age: $_age',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Year Joined: $_yearJoined',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Batting Style: $_battingStyle',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Bowling Style: $_bowlingStyle',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Education: $_education',
                style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text('Team: $_team',
                style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
      ),
    );
  }

  /// Achievements Section.
  Widget _buildAchievementsSection(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryYellow,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _achievements.length,
          itemBuilder: (context, index) {
            final achievement = _achievements[index];
            return Card(
              color: Colors.grey[850],
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement['title'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryYellow,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Match: ${achievement['matchOpponent'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                    Text(
                      'Location: ${achievement['matchLocation'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: subTextColor),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Logout Button.
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement log out functionality.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out!')),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.black),
        label: const Text(
          'Log Out',
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
