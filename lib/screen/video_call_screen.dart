import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_clone/modal/participant.dart';

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
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
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
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
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

  Widget _buildParticipantTile(Participant participant, {bool isMainView = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMainView ? 20 : 16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: participant.isSelf 
              ? [Color(0xFF667eea), Color(0xFF764ba2)]
              : [participant.avatarColor.withValues(alpha:  0.8), participant.avatarColor],
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
                  color: Colors.white.withValues(alpha:  0.2),
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
                if (participant.isMuted && !participant.isVideoOn) SizedBox(width: 6),
                if (!participant.isVideoOn)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.videocam_off, color: Colors.white, size: 16),
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
            color: _isMuted ? Colors.red : Colors.white.withValues(alpha:  0.2),
            onPressed: _toggleMute,
            label: _isMuted ? 'Unmute' : 'Mute',
          ),
          _buildControlButton(
            icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
            color: _isVideoOff ? Colors.red : Colors.white.withValues(alpha:  0.2),
            onPressed: _toggleVideo,
            label: _isVideoOff ? 'Start Video' : 'Stop Video',
          ),
          _buildControlButton(
            icon: _isScreenSharing ? Icons.stop_screen_share : Icons.screen_share,
            color: _isScreenSharing ? Colors.green : Colors.white.withValues(alpha:  0.2),
            onPressed: _toggleScreenShare,
            label: _isScreenSharing ? 'Stop Share' : 'Share',
          ),
          _buildControlButton(
            icon: _isRecording ? Icons.stop : Icons.fiber_manual_record,
            color: _isRecording ? Colors.red : Colors.white.withValues(alpha:  0.2),
            onPressed: _toggleRecording,
            label: _isRecording ? 'Stop Rec' : 'Record',
          ),
          _buildControlButton(
            icon: Icons.more_horiz,
            color: Colors.white.withValues(alpha:  0.2),
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
                  color: color == Colors.red ? Colors.red.withValues(alpha:  0.3) : Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
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
    _showFeedback(_isScreenSharing ? 'Screen sharing started' : 'Screen sharing stopped');
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
