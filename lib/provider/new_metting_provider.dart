import 'dart:math';

import 'package:flutter_riverpod/legacy.dart';
import 'package:zoom_clone/modal/new_metting_provider.dart';

class MettingNotifier extends StateNotifier<MettingState> {
  MettingNotifier()
      : super(MettingState(
          ismicrophoneoff: false,
          iscameraoff: false,
          mettingId: Random().nextInt(999999).toString(),
        ));
} 