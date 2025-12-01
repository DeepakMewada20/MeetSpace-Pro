import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone/provider/app_sing_provider.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:zoom_clone/provider/metting_room_notifire.dart';
import 'package:zoom_clone/provider/new_metting_provider.dart';
import 'package:zoom_clone/provider/waiting_participents_provider.dart';
import 'package:zoom_clone/screen/active_particepents_list.dart';
import 'package:zoom_clone/screen/waiting_approval_screen.dart';

class MettingRoomScreen extends ConsumerStatefulWidget {
  final String userName;
  final String mettingId;
  final bool isHost;
  final bool isCameraOn;
  final bool isMicOn;
  const MettingRoomScreen({
    required this.userName,
    required this.mettingId,
    required this.isHost,
    required this.isCameraOn,
    required this.isMicOn,
    super.key,
  });

  @override
  ConsumerState<MettingRoomScreen> createState() => _MettingRoomScreenState();
}

class _MettingRoomScreenState extends ConsumerState<MettingRoomScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  late AppConfigaretion appConfig = Get.arguments as AppConfigaretion;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mettingRoomProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: appConfig
              .appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.

          appSign: appConfig
              .appSing, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.

          userID: userID,

          userName: widget.userName,

          conferenceID: widget.mettingId.trim(),

          config: ZegoUIKitPrebuiltVideoConferenceConfig()
            ..turnOnCameraWhenJoining = widget.isCameraOn
            ..turnOnMicrophoneWhenJoining = widget.isMicOn
            ..layout = ZegoLayout.gallery()
            //top menu bar
            ..topMenuBarConfig = ZegoTopMenuBarConfig(
              isVisible: true,
              backgroundColor: Colors.transparent,
              title: "ID : ${widget.mettingId} |${state.elapsedTime}",
              buttons: [
                ZegoMenuBarButtonName.switchCameraButton,
                ZegoMenuBarButtonName.toggleScreenSharingButton,
              ],
              extendButtons: [
                if (widget.isHost)
                  StreamBuilder(
                    stream: fetchWaitingListparticipents(widget.mettingId),
                    builder: (context, snapshot) {
                      final int waitingCount = snapshot.data?.docs.length ?? 0;
                      return IconButton(
                        onPressed: () {
                          Get.to(
                            () => HostWaitingListScreen(
                              meetingId: widget.mettingId,
                            ),
                          );
                        },
                        icon: snapshot.hasData
                            ? Stack(
                                children: [
                                  const Icon(Icons.people, size: 28),
                                  if (waitingCount > 0)
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          waitingCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : const Icon(Icons.people, size: 28),
                      );
                    },
                  ),
              ],
            )
            ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
              maxCount: 6,
              style: ZegoMenuBarStyle
                  .light, // Specify the style of the bottom menu bar (dark or light
              buttons: [
                ZegoMenuBarButtonName.toggleMicrophoneButton,
                ZegoMenuBarButtonName.toggleCameraButton,
                ZegoMenuBarButtonName.leaveButton,
                ZegoMenuBarButtonName.chatButton,
              ],
              extendButtons: [
                // Custom Participants Button (Only for Host)
                if (widget.isHost)
                  if (widget.isHost) _buildThreeDotMenuButton(context),
              ],
            )
            //leave meeting button
            ..onLeave = () async {
              await ZegoUIKit().leaveRoom();

              final doc = await FirebaseFirestore.instance
                  .collection("mettings")
                  .doc(widget.mettingId)
                  .collection("participants")
                  .get();
              if (doc.docs.length <= 1 && widget.isHost) {
                await FirebaseFirestore.instance
                    .collection("mettings")
                    .doc(widget.mettingId)
                    .delete();
              }
              await FirebaseFirestore.instance
                  .collection("mettings")
                  .doc(widget.mettingId)
                  .collection("participants")
                  .doc(userID)
                  .delete();
              ref.invalidate(mettingRoomProvider);
              ref.invalidate(joinMettingProvide);
              ref.invalidate(startMettingProvider);
              Get.back();
            },
        ),
      ),
    );
  }

  // Add these methods:

  Widget _buildThreeDotMenuButton(BuildContext context) {
    final participantCount = ZegoUIKit().getAllUsers().length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white, size: 28),
          onPressed: () => _showHostMenu(context),
          tooltip: 'More Options',
        ),
        if (participantCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$participantCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showHostMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.settings, color: colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Host Controls',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
              _buildMenuOption(
                context,
                icon: Icons.speaker_notes_off,
                title: 'Mute All Participants',
                subtitle: 'Mute everyone\'s microphone',
                onTap: () {
                  Navigator.pop(context);
                  _muteAllParticipants(context);
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.people,
                title: 'Participants',
                subtitle: 'Manage meeting participants',
                badge: ZegoUIKit().getAllUsers().length.toString(),
                onTap: () {
                  Navigator.pop(context);
                  showActiveParticipantsSheet(context);
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.person_add,
                title: 'Waiting Room',
                subtitle: 'View waiting participants',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to your waiting room screen
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _muteAllParticipants(BuildContext context) {
    final users = ZegoUIKit().getAllUsers();
    for (var user in users) {
      if (user.microphone.value == true) {
        user.microphone.value = false;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.mic_off, color: Colors.white),
            const SizedBox(width: 12),
            Text('All participants muted'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
