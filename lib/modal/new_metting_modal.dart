class StartMettingState {
  final String mettingId;
  final bool isMicOn;
  final bool iscameraOn;
  final bool? loading;

  StartMettingState({
    required this.mettingId,
    this.isMicOn = false,
    this.iscameraOn = false,
    this.loading = false,
  });

  StartMettingState copyWith({
    String? mettingId,
    bool? ismicrophoneoff,
    bool? iscameraoff,
    bool? loading,
  }) {
    return StartMettingState(
      mettingId: mettingId ?? this.mettingId,
      isMicOn: ismicrophoneoff ?? isMicOn,
      iscameraOn: iscameraoff ?? iscameraOn,
      loading: loading ?? this.loading,
    );
  }
}
