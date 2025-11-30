class MettingRoomModal {
  final String elapsedTime;

  MettingRoomModal({required this.elapsedTime});

  MettingRoomModal copyWith({
    String? elapsedTime,}){
      return MettingRoomModal(elapsedTime: elapsedTime ?? this.elapsedTime);
    }
}
