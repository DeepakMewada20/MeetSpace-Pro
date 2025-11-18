
import 'package:flutter_riverpod/legacy.dart';
import 'package:zoom_clone/modal/new_metting_provider.dart';

class MettingNotifier extends StateNotifier<MettingState> {
  MettingNotifier()
    : super(
        MettingState(
          ismicrophoneoff: false,
          iscameraoff: false,
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
    return  'meet_space_pro_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  final mettingProvider =
      StateNotifierProvider.autoDispose<MettingNotifier, MettingState>((ref) {
        return MettingNotifier();
      });
}
