import 'package:flutter_riverpod/legacy.dart';
import 'package:zoom_clone/modal/new_metting_modal.dart';

class StartMettingNotifier extends StateNotifier<StartMettingState> {
  StartMettingNotifier()
    : super(
        StartMettingState(
          isMicOn: true,
          iscameraOn: true,
          mettingId: generateMeetingId(),
          loading: false,
        ),
      );

  void toggleMicrophone(bool value) {
    state = state.copyWith(ismicrophoneoff: value);
  }

  void toggleCamera(bool value) {
    state = state.copyWith(iscameraoff: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  static String generateMeetingId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }
}

final startMettingProvider =
    StateNotifierProvider.autoDispose<StartMettingNotifier, StartMettingState>((
      ref,
    ) {
      return StartMettingNotifier();
    });
