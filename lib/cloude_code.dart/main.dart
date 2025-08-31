import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetSpace Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display',
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/call': (context) => VideoCallScreen(),
        '/join': (context) => JoinMeetingScreen(),
      },
    );
  }
}

// Splash Screen with Animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.video_call,
                          size: 60,
                          color: Color(0xFF667eea),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'MeetSpace Pro',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Connect. Collaborate. Create.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Enhanced Home Screen with Bottom Navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298), Color(0xFF667eea)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _animationController.value,
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.video_call,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MeetSpace Pro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Premium Video Meetings',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 60),

                        // Welcome Message
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
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
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),

                        // Action Buttons
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildActionCard(
                                icon: Icons.add_circle_outline,
                                title: 'Start New Meeting',
                                subtitle: 'Begin an instant meeting',
                                gradient: [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2),
                                ],
                                onTap: () => _startNewMeeting(context),
                              ),

                              SizedBox(height: 20),

                              _buildActionCard(
                                icon: Icons.meeting_room,
                                title: 'Join Meeting',
                                subtitle: 'Enter meeting ID to join',
                                gradient: [
                                  Color(0xFFf093fb),
                                  Color(0xFFf5576c),
                                ],
                                onTap: () =>
                                    Navigator.pushNamed(context, '/join'),
                              ),

                              SizedBox(height: 20),

                              _buildActionCard(
                                icon: Icons.schedule,
                                title: 'Schedule Meeting',
                                subtitle: 'Plan for later',
                                gradient: [
                                  Color(0xFF4facfe),
                                  Color(0xFF00f2fe),
                                ],
                                onTap: () => _showScheduleDialog(),
                              ),
                            ],
                          ),
                        ),

                        // Recent Meetings
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1e3c72).withOpacity(0.9), Color(0xFF2a5298)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomBarItem(Icons.home, 'Home', true),
              _buildBottomBarItem(Icons.chat_bubble_outline, 'Chat', false),
              _buildBottomBarItem(Icons.settings_outlined, 'Settings', false),
              _buildBottomBarItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        print('Tapped $label');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white60,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white60,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
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
              color: gradient.first.withOpacity(0.3),
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
                color: Colors.white.withOpacity(0.2),
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

// Enhanced Join Meeting Screen
class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  _JoinMeetingScreenState createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf093fb), Color(0xFFf5576c), Color(0xFF4facfe)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Join Meeting',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 60),

                  // Form Container
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 30,
                            offset: Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.meeting_room,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),

                          SizedBox(height: 32),

                          Text(
                            'Meeting Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),

                          SizedBox(height: 24),

                          _buildTextField(
                            controller: _meetingIdController,
                            label: 'Meeting ID',
                            icon: Icons.tag,
                            keyboardType: TextInputType.number,
                          ),

                          SizedBox(height: 20),

                          _buildTextField(
                            controller: _nameController,
                            label: 'Your Display Name',
                            icon: Icons.person_outline,
                          ),

                          SizedBox(height: 40),

                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF667eea).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _joinMeeting,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Join Meeting',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Spacer(),

                          Center(
                            child: Text(
                              'Enter the meeting ID shared by the host',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF667eea)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  void _joinMeeting() {
    if (_meetingIdController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/call',
        arguments: {
          'meetingId': _meetingIdController.text,
          'userName': _nameController.text,
          'isHost': false,
        },
      );
    } else {
      _showErrorSnackbar('Please fill all fields');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _meetingIdController.dispose();
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

// Enhanced Video Call Screen
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen>
    with TickerProviderStateMixin {
  bool _isMuted = false;
  bool _isVideoOff = false;
  final bool _isSpeakerOn = true;
  bool _isScreenSharing = false;
  bool _showControls = true;
  bool _isRecording = false;
  final List<Participant> _participants = [];
  String? _meetingId;
  bool? _isHost;
  String? _userName;

  late AnimationController _controlsController;
  late AnimationController _pulseController;
  late Animation<double> _controlsAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controlsController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsController,
      curve: Curves.easeInOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controlsController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _meetingId = args['meetingId'];
          _isHost = args['isHost'] ?? false;
          _userName = args['userName'] ?? 'You';
        });
        _initializeCall();
      }
    });

    // Auto-hide controls after 5 seconds
    Future.delayed(Duration(seconds: 5), _hideControls);
  }

  void _initializeCall() {
    _participants.addAll([
      Participant(id: 'self', name: _userName ?? 'You', isSelf: true),
      Participant(id: '1', name: 'Sarah Wilson', avatarColor: Colors.pink),
      Participant(id: '2', name: 'Mike Chen', avatarColor: Colors.orange),
      Participant(id: '3', name: 'Alex Johnson', avatarColor: Colors.green),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Grid
            _buildVideoGrid(),

            // Top Bar
            AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, child) {
                return AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                    child: _buildTopBar(),
                  ),
                );
              },
            ),

            // Bottom Controls
            AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  bottom: _showControls ? 0 : -200,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: _buildBottomControls(),
                  ),
                );
              },
            ),

            // Recording Indicator
            if (_isRecording)
              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 20,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'REC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.videocam, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'ID: $_meetingId',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _copyMeetingId,
                  child: Icon(Icons.copy, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),

          Spacer(),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '${_participants.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          GestureDetector(
            onTap: _endCall,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    if (_participants.isEmpty) {
      return Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: _participants.length == 1
          ? _buildSingleParticipant()
          : _buildMultipleParticipants(),
    );
  }

  Widget _buildSingleParticipant() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: _buildParticipantTile(_participants.first, isMainView: true),
    );
  }

  Widget _buildMultipleParticipants() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _participants.length > 4 ? 3 : 2,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _participants.length,
      itemBuilder: (context, index) {
        return _buildParticipantTile(_participants[index]);
      },
    );
  }

  Widget _buildParticipantTile(
    Participant participant, {
    bool isMainView = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMainView ? 20 : 16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: participant.isSelf
              ? [Color(0xFF667eea), Color(0xFF764ba2)]
              : [
                  participant.avatarColor.withOpacity(0.8),
                  participant.avatarColor,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: isMainView ? 20 : 10,
            offset: Offset(0, isMainView ? 10 : 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Video Stream or Avatar
          if (participant.isVideoOn)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMainView ? 20 : 16),
                color: Colors.black26,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam,
                      color: Colors.white70,
                      size: isMainView ? 40 : 24,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Video Stream',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isMainView ? 16 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Center(
              child: Container(
                width: isMainView ? 120 : 80,
                height: isMainView ? 120 : 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    participant.name.split(' ').map((n) => n[0]).take(2).join(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMainView ? 36 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Status indicators
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (participant.isMuted)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mic_off, color: Colors.white, size: 16),
                  ),
                if (participant.isMuted && !participant.isVideoOn)
                  SizedBox(width: 6),
                if (!participant.isVideoOn)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.videocam_off,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),

          // Name overlay
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                participant.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMainView ? 16 : 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _isMuted ? Icons.mic_off : Icons.mic,
            color: _isMuted ? Colors.red : Colors.white.withOpacity(0.2),
            onPressed: _toggleMute,
            label: _isMuted ? 'Unmute' : 'Mute',
          ),
          _buildControlButton(
            icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
            color: _isVideoOff ? Colors.red : Colors.white.withOpacity(0.2),
            onPressed: _toggleVideo,
            label: _isVideoOff ? 'Start Video' : 'Stop Video',
          ),
          _buildControlButton(
            icon: _isScreenSharing
                ? Icons.stop_screen_share
                : Icons.screen_share,
            color: _isScreenSharing
                ? Colors.green
                : Colors.white.withOpacity(0.2),
            onPressed: _toggleScreenShare,
            label: _isScreenSharing ? 'Stop Share' : 'Share',
          ),
          _buildControlButton(
            icon: _isRecording ? Icons.stop : Icons.fiber_manual_record,
            color: _isRecording ? Colors.red : Colors.white.withOpacity(0.2),
            onPressed: _toggleRecording,
            label: _isRecording ? 'Stop Rec' : 'Record',
          ),
          _buildControlButton(
            icon: Icons.more_horiz,
            color: Colors.white.withOpacity(0.2),
            onPressed: _showMoreOptions,
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color == Colors.red
                      ? Colors.red.withOpacity(0.3)
                      : Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(Duration(seconds: 5), _hideControls);
    }
  }

  void _hideControls() {
    if (mounted) {
      setState(() {
        _showControls = false;
      });
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _participants.where((p) => p.isSelf).forEach((p) {
        p.isMuted = _isMuted;
      });
    });
    _showFeedback(_isMuted ? 'Microphone muted' : 'Microphone unmuted');
  }

  void _toggleVideo() {
    setState(() {
      _isVideoOff = !_isVideoOff;
      _participants.where((p) => p.isSelf).forEach((p) {
        p.isVideoOn = !_isVideoOff;
      });
    });
    _showFeedback(_isVideoOff ? 'Camera turned off' : 'Camera turned on');
  }

  void _toggleScreenShare() {
    setState(() {
      _isScreenSharing = !_isScreenSharing;
    });
    _showFeedback(
      _isScreenSharing ? 'Screen sharing started' : 'Screen sharing stopped',
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      _pulseController.repeat(reverse: true);
      _showFeedback('Recording started');
    } else {
      _pulseController.stop();
      _showFeedback('Recording stopped');
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Color(0xFF667eea)),
              title: Text('Chat'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Color(0xFF667eea)),
              title: Text('Participants'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF667eea)),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF667eea),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyMeetingId() {
    if (_meetingId != null) {
      Clipboard.setData(ClipboardData(text: _meetingId!));
      _showFeedback('Meeting ID copied to clipboard');
    }
  }

  void _endCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('End Meeting?'),
        content: Text('Are you sure you want to leave this meeting?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('End Meeting'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controlsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Enhanced Participant Model
class Participant {
  final String id;
  final String name;
  final bool isSelf;
  final Color avatarColor;
  bool isVideoOn;
  bool isMuted;

  Participant({
    required this.id,
    required this.name,
    this.isSelf = false,
    this.avatarColor = Colors.blue,
    this.isVideoOn = true,
    this.isMuted = false,
  });
}
