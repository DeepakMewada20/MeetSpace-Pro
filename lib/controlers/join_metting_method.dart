import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:zoom_clone/screen/waiting_approval_screen.dart';
import 'package:zoom_clone/screen/wating_room_screen.dart';
import 'package:zoom_clone/widgets/snackbar_and_toast_widget.dart';

void joinMettingMethod(
  WidgetRef ref,
  BuildContext context,
  TextEditingController nameController,
  TextEditingController meetingIdController,
) async {
  //current user
  User? user = FirebaseAuth.instance.currentUser;

  final name = nameController.text.trim();
  final meetingId = meetingIdController.text.trim();

  //reverpod
  final state = ref.watch(joinMettingProvide);
  final notifier = ref.read(joinMettingProvide.notifier);

  final doc = await FirebaseFirestore.instance
      .collection("mettings")
      .doc(meetingId)
      .get();

  if (!doc.exists) {
    notifier.setErrorMessage("worng metting ID");
    SnackbarAndToastWidget.errorSnackbar(
      "Metting ID not Found!",
      "Please enter correct metting ID or contect your host",
    );
    return;
  }
  await FirebaseFirestore.instance
      .collection("mettings")
      .doc(meetingId)
      .collection("waitingList")
      .doc(user!.uid)
      .set({
        'name': name.isNotEmpty ? name : user.displayName ?? "Guest",
        'status': 'waiting',
        'joinedAt': DateTime.now(),
        'isCameraOn': state.isCameraOn,
        'isMicOn': state.isMicOn,
        'userId': user.uid,
        'userPhotoUrl': user.photoURL ?? "",
      });

  Get.to(
    () => WaitingRoomScreen(
      meetingId: meetingId,
      userName: name.isNotEmpty ? name : user.displayName ?? "Guest",
      userId: user.uid,
    ),
  );
  // Get.to(()=>HostWaitingListScreen(meetingId: meetingId));
  
}
