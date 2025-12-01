import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/user_profiledata_save_controller.dart';
import 'package:zoom_clone/provider/app_sing_provider.dart';
import 'package:zoom_clone/provider/new_metting_provider.dart';
import 'package:zoom_clone/screen/metting_room_screen.dart';

void startMeeting(
  WidgetRef ref,
  BuildContext context,
  TextEditingController nameController,
) async {
  // Implementation for starting a meeting
  UserProfiledataSaveController userProfileInstance = Get.find<UserProfiledataSaveController>();
  // final currentuser = FirebaseAuth.instance.currentUser;
  final state = ref.watch(startMettingProvider);
  final notifier = ref.read(startMettingProvider.notifier);
  notifier.setLoading(true);
  await FirebaseFirestore.instance
      .collection('mettings')
      .doc(state.mettingId)
      .set({
        'hostId': userProfileInstance.user!.uid,
        'name': nameController.text.isNotEmpty
            ? nameController.text
            : userProfileInstance.user!.displayName,
        'status': 'approved',
        'joinedAt': DateTime.now(),
        'isHost' :true,
        'isMicrophoneOn': state.isMicOn,
        'isCameraOn': state.iscameraOn,
        'photoUrl' : userProfileInstance.user!.photoURL
      });
  final appConfig = await fetchAppconfig();
  Get.to(
    () => MettingRoomScreen(
      userName: nameController.text.isNotEmpty
          ? nameController.text
          : userProfileInstance.user!.displayName ?? "Host",
      mettingId: state.mettingId,
      isHost: true,
      isCameraOn: state.iscameraOn,
      isMicOn: state.isMicOn,
    ),
    arguments: appConfig,
  );
  notifier.setLoading(false);
}
