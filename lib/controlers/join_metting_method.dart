import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/user_profiledata_save_controller.dart';
import 'package:zoom_clone/modal/join_metting_modal.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:zoom_clone/screen/waiting_approval_screen.dart';
import 'package:zoom_clone/screen/wating_room_screen.dart';
import 'package:zoom_clone/widgets/snackbar_and_toast_widget.dart';

void joinMettingMethod(
  JoinMettingNotifire notifier,
  JoinMeetingState state,
  String name,
  String meetingId,
) async {
  //current user
  UserProfiledataSaveController userProfileInstance =
      Get.find<UserProfiledataSaveController>();
  final user = userProfileInstance.user;

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
      .collection("participants")
      .doc(userProfileInstance.user!.uid)
      .set({
        'userId': user!.uid,
        'name': name.isNotEmpty ? name : user.displayName ?? "Guest",
        'status': 'waiting',
        'joinedAt': DateTime.now(),
        'isHost': false,
        'isMicrophoneOn': state.isMicOn,
        'isCameraOn': state.isCameraOn,
        'photoUrl': user.photoURL ?? "",
      });
  Get.to(
    () => WaitingRoomScreen(
      meetingId: meetingId,
      userName: name,
      userId: user.uid,
    ),
  );
  // Get.to(() => HostWaitingListScreen(meetingId: meetingId));
}
