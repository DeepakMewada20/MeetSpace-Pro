class JoinMeetingState {
  final bool isMicOn;
  final bool isCameraOn;
  final String? errorMessage;

  JoinMeetingState({
    required this.isCameraOn,
    required this.isMicOn,
    required this.errorMessage,
  });

  JoinMeetingState copywith({
    bool? isMicOn,
    bool? isCameraOn,
    String? errorMessage,
  }) {
    return JoinMeetingState(
      isMicOn: isMicOn ?? this.isMicOn,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
