import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone/modal/metting_room_modal.dart';

class MettingRoomNotifire extends StateNotifier<MettingRoomModal> {
  Timer? _timer;
  MettingRoomNotifire() : super(MettingRoomModal(elapsedTime: '00:00')) {

    _startTimer();
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(!mounted){
        timer.cancel();
        return;
      }
      final parts = state.elapsedTime.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);

      seconds++;
      if (seconds >= 60) {
        minutes++;
        seconds = 0;
      }

      final newElapsedTime =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      state = state.copyWith(elapsedTime: newElapsedTime);
    });
  }
  void removeUser(String userId , String mettingId) async {
    ZegoUIKit().removeUserFromRoom([userId]);
    await FirebaseFirestore.instance
      .collection("mettings")
      .doc(mettingId)
      .collection("participants")
      .doc(userId)
      .delete();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final mettingRoomProvider =
    StateNotifierProvider.autoDispose<MettingRoomNotifire, MettingRoomModal>((
  ref,
) {
  return MettingRoomNotifire();
});
