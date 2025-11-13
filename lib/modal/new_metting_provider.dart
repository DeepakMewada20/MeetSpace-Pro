class MettingState {
  final String mettingId;
  final bool ismicrophoneoff;
  final bool iscameraoff;

  MettingState({
    required this.mettingId,
    this.ismicrophoneoff = false,
    this.iscameraoff = false,
  });

  MettingState copyWith({
    String? mettingId,
    bool? ismicrophoneoff,
    bool? iscameraoff,
  }) {
    return MettingState(
      mettingId: mettingId ?? this.mettingId,
      ismicrophoneoff: ismicrophoneoff ?? this.ismicrophoneoff,
      iscameraoff: iscameraoff ?? this.iscameraoff,
    );
  }
}
