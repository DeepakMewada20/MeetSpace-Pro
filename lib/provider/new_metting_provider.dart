import 'package:flutter_riverpod/legacy.dart';
import 'package:zoom_clone/modal/new_metting_provider.dart';

class StartMettingNotifier extends StateNotifier<MettingState> {
  StartMettingNotifier()
    : super(
        MettingState(
          isMicOn: true,
          iscameraOn: true,
          mettingId: generateMeetingId(),
        ),
      );

  void toggleMicrophone(bool value) {
    state = state.copyWith(ismicrophoneoff: value);
  }

  void toggleCamera(bool value) {
    state = state.copyWith(iscameraoff: value);
  }

  static String generateMeetingId() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  final mettingProvider =
      StateNotifierProvider.autoDispose<StartMettingNotifier, MettingState>((
        ref,
      ) {
        return StartMettingNotifier();
      });
}
