import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

// Active Participant model
class ActiveParticipant {
  final String id;
  final String name;
  final bool isCameraOn;
  final bool isMicOn;
  final bool isHost;

  ActiveParticipant({
    required this.id,
    required this.name,
    required this.isCameraOn,
    required this.isMicOn,
    this.isHost = false,
  });
}

/// Show Active Participants Bottom Sheet
/// Call this from your ZegoCloud bottom bar button
void showActiveParticipantsSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ActiveParticipantsContent(scrollController: scrollController),
      ),
    ),
  );
}

class ActiveParticipantsContent extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const ActiveParticipantsContent({super.key, required this.scrollController});

  @override
  ConsumerState<ActiveParticipantsContent> createState() =>
      _ActiveParticipantsContentState();
}

class _ActiveParticipantsContentState
    extends ConsumerState<ActiveParticipantsContent> {
  List<ActiveParticipant> participants = [];

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  // Fetch participants from ZegoCloud
  void _fetchParticipants() {
    final zegoUsers = ZegoUIKit().getAllUsers();
    
    setState(() {
      participants = zegoUsers.map((user) {
        return ActiveParticipant(
          id: user.id,
          name: user.name,
          isCameraOn: user.camera.value,
          isMicOn: user.microphone.value,
          isHost: false, // Set based on your host logic
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Drag Handle
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.people, color: colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Participants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${participants.length}',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),

        Divider(color: colorScheme.outline.withValues(alpha: 0.2), height: 1),

        // Participants List
        Expanded(
          child: participants.isEmpty
              ? _buildEmptyState(colorScheme)
              : ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: participants.length,
                  itemBuilder: (context, index) =>
                      _buildParticipantTile(participants[index], colorScheme),
                ),
        ),
      ],
    );
  }

  Widget _buildParticipantTile(ActiveParticipant p, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
            child: Text(
              p.name[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & Host Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (p.isHost) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Host',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Control Buttons
          _buildControlButton(
            icon: p.isCameraOn ? Icons.videocam : Icons.videocam_off,
            isEnabled: p.isCameraOn,
            colorScheme: colorScheme,
            onTap: () => _toggleCamera(p),
          ),
          const SizedBox(width: 8),
          _buildControlButton(
            icon: p.isMicOn ? Icons.mic : Icons.mic_off,
            isEnabled: p.isMicOn,
            colorScheme: colorScheme,
            onTap: () => _toggleMic(p),
          ),
          const SizedBox(width: 8),
          _buildControlButton(
            icon: Icons.remove_circle_outline,
            isEnabled: false,
            colorScheme: colorScheme,
            color: colorScheme.error,
            onTap: () => _removeParticipant(p),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isEnabled,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ??
        (isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: buttonColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: buttonColor),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No participants yet',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Control Methods
  void _toggleCamera(ActiveParticipant p) {
    // Toggle camera using ZegoCloud API
    final user = ZegoUIKit().getUser(p.id);
    user.camera.value = !p.isCameraOn;
      
    setState(() {
      final index = participants.indexWhere((item) => item.id == p.id);
      if (index != -1) {
        participants[index] = ActiveParticipant(
          id: p.id,
          name: p.name,
          isCameraOn: !p.isCameraOn,
          isMicOn: p.isMicOn,
          isHost: p.isHost,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${p.name}\'s camera ${!p.isCameraOn ? "enabled" : "disabled"}',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleMic(ActiveParticipant p) {
    // Toggle mic using ZegoCloud API
    final user = ZegoUIKit().getUser(p.id);
    user.microphone.value = !p.isMicOn;
      
    setState(() {
      final index = participants.indexWhere((item) => item.id == p.id);
      if (index != -1) {
        participants[index] = ActiveParticipant(
          id: p.id,
          name: p.name,
          isCameraOn: p.isCameraOn,
          isMicOn: !p.isMicOn,
          isHost: p.isHost,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${p.name}\'s mic ${!p.isMicOn ? "unmuted" : "muted"}',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeParticipant(ActiveParticipant p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${p.name}?'),
        content: Text('This participant will be removed from the meeting.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Remove using ZegoCloud API
              ZegoUIKit().removeUserFromRoom([p.id]);
              
              setState(() {
                participants.removeWhere((item) => item.id == p.id);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${p.name} removed')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HOW TO ADD BUTTON IN ZEGOCLOUD BOTTOM BAR
// ============================================================================

/*
In your ZegoUIKitPrebuiltCall config:

ZegoUIKitPrebuiltCall(
  appID: yourAppID,
  appSign: yourAppSign,
  userID: userID,
  userName: userName,
  callID: callID,
  config: ZegoUIKitPrebuiltCallConfig(
    // ... other configs
    bottomMenuBarConfig: ZegoBottomMenuBarConfig(
      buttons: [
        ZegoMenuBarButtonName.toggleCameraButton,
        ZegoMenuBarButtonName.toggleMicrophoneButton,
        ZegoMenuBarButtonName.hangUpButton,
        ZegoMenuBarButtonName.switchCameraButton,
        // Add custom participants button
      ],
      extendButtons: [
        // Custom Participants Button (Only for Host)
        if (isHost)
          IconButton(
            icon: Icon(Icons.people, color: Colors.white),
            onPressed: () => showActiveParticipantsSheet(context),
          ),
      ],
    ),
  ),
);
*/