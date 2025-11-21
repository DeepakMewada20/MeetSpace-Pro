import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone/provider/app_sing_provider.dart';

class MettingRoomScreen extends StatefulWidget {
  final String userName;
  final String roomId;
  final bool isHost;
  const MettingRoomScreen({
    required this.userName,
    required this.roomId,
    required this.isHost,
    super.key,
  });

  @override
  State<MettingRoomScreen> createState() => _MettingRoomScreenState();
}

class _MettingRoomScreenState extends State<MettingRoomScreen> {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  late AppConfigaretion appConfig = Get.arguments as AppConfigaretion;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        
        child: ZegoUIKitPrebuiltVideoConference(
          appID: appConfig.appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.

          appSign: appConfig.appSing, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.

          userID: userID,

          userName: widget.userName,

          conferenceID: widget.roomId.trim(),

          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
        ),
      ),
    );
  }
}
