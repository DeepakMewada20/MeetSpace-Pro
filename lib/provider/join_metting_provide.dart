import 'package:flutter_riverpod/legacy.dart';
import 'package:zoom_clone/modal/join_metting_modal.dart';

class JoinMettingNotifire extends StateNotifier<JoinMeetingState> {
  JoinMettingNotifire()
    : super(
        JoinMeetingState(isCameraOn: true, isMicOn: true, errorMessage: null),
      );

  void toggleMic(bool value) {
    state = state.copywith(isMicOn: value);
  }

  void toogleCamera(bool value) {
    state = state.copywith(isCameraOn: value);
  }

  void setErrorMessage(String message) {
    state = state.copywith(errorMessage: message);
  }
}

final joinMettingProvide =
    StateNotifierProvider.autoDispose<JoinMettingNotifire, JoinMeetingState>((
      ref,
    ) {
      return JoinMettingNotifire();
    });
