import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/provider/new_metting_provider.dart';
import 'package:zoom_clone/screen/metting_room_screen.dart';

void startMeeting(
  WidgetRef ref,
  BuildContext context,
  TextEditingController nameController,
) async{
  // Implementation for starting a meeting
  final currentuser = FirebaseAuth.instance.currentUser;
  final state = ref.read(MettingNotifier().mettingProvider);

  await FirebaseFirestore.instance
      .collection('meetings')
      .doc(state.mettingId)
      .set({
        'hostId': currentuser?.uid,
        'hostName': nameController.text.isNotEmpty
            ? nameController.text
            : currentuser?.displayName,
        'meetingId': state.mettingId,
        'isMicrophoneOff': state.ismicrophoneoff,
        'isCameraOff': state.iscameraoff,
        'createdAt': DateTime.now(),
      });
  Get.to(
    () => MettingRoomScreen(
      userName: nameController.text.isNotEmpty
          ? nameController.text
          : currentuser?.displayName ?? "Host",
      roomId: state.mettingId,
      isHost: true,
    ),
  );
}
