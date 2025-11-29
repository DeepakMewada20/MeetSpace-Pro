import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone/provider/app_sing_provider.dart';
import 'package:zoom_clone/provider/waiting_participents_provider.dart';
import 'package:zoom_clone/screen/waiting_approval_screen.dart';

class MettingRoomScreen extends StatefulWidget {
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
  State<MettingRoomScreen> createState() => _MettingRoomScreenState();
}

class _MettingRoomScreenState extends State<MettingRoomScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  late AppConfigaretion appConfig = Get.arguments as AppConfigaretion;
  @override
  Widget build(BuildContext context) {
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
              title: "Meeting Room",
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
                      return IconButton(onPressed: () {
                        Get.to(
                          () => HostWaitingListScreen(
                            meetingId: widget.mettingId,
                          ),
                        );
                      }, icon: snapshot.hasData
                          ? Stack(
                              children: [
                                const Icon(
                                  Icons.people,
                                  size: 28,
                                ),
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
                          : const Icon(
                              Icons.people,
                              size: 28,
                            ));
                    },
                  ),
              ],
            ),
        ),
      ),
    );
  }
}
