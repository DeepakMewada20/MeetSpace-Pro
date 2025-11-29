class MettingState {
  final String mettingId;
  final bool isMicOn;
  final bool iscameraOn;

  MettingState({
    required this.mettingId,
    this.isMicOn = false,
    this.iscameraOn = false,
  });

  MettingState copyWith({
    String? mettingId,
    bool? ismicrophoneoff,
    bool? iscameraoff,
  }) {
    return MettingState(
      mettingId: mettingId ?? this.mettingId,
      isMicOn: ismicrophoneoff ?? this.isMicOn,
      iscameraOn: iscameraoff ?? this.iscameraOn,
    );
  }
}
