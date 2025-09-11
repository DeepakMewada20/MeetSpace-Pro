import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';
import 'package:zoom_clone/screen/profile_page/profile_page.dart';
import 'package:zoom_clone/them_data/dart_them.dart';
import 'package:zoom_clone/widgets/header.dart';

// Enhanced Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  UserProfiledataSaveController userProfileInsteance = Get.put(
    UserProfiledataSaveController(),
  );
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  Widget _profileImage() {
    return GestureDetector(
      onTap: () => Get.to(() => ProfilePage()),
      child: userProfileInsteance.user == null
          ? Icon(Icons.person)
          : Image.network(userProfileInsteance.photoUrl!, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: DarkGradients.backgroundGradient,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          // ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                HeaderWidget(
                  title: 'MeetSpace Pro',
                  subtitle: 'Premium Video Meetings',
                  leddingIcon: Icons.video_call,
                  actionIcon: _profileImage(),
                ),
                SizedBox(height: 20),
                // Welcome Message
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Colors.yellowAccent,
                        size: 40,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Good ${_getTimeOfDay()}!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ready to connect with your team?',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Action Buttons
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionCard(
                          icon: Icons.add_circle_outline,
                          title: 'Start New Meeting',
                          subtitle: 'Begin an instant meeting',
                          gradient: [Color(0xFF667eea), Color(0xFF764ba2)],
                          onTap: () => _startNewMeeting(context),
                        ),

                        SizedBox(height: 20),

                        _buildActionCard(
                          icon: Icons.meeting_room,
                          title: 'Join Meeting',
                          subtitle: 'Enter meeting ID to join',
                          gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
                          onTap: () => Navigator.pushNamed(context, '/join'),
                        ),

                        SizedBox(height: 20),

                        _buildActionCard(
                          icon: Icons.schedule,
                          title: 'Schedule Meeting',
                          subtitle: 'Plan for later',
                          gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          onTap: () => _showScheduleDialog(),
                        ),

                        SizedBox(height: 20),
                        // Recent Meetings
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.history, color: Colors.white70),
                              SizedBox(width: 12),
                              Text(
                                'Recent Meetings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  void _startNewMeeting(BuildContext context) {
    String meetingId = _generateMeetingId();
    Navigator.pushNamed(
      context,
      '/call',
      arguments: {'meetingId': meetingId, 'isHost': true},
    );
  }

  String _generateMeetingId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Schedule Meeting'),
        content: Text('This feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
