import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  final String userId;
  final String name;
  final String status;
  final DateTime joinedAt;
  final bool isCameraOn;
  final bool isMicOn;
  final String userPhotoUrl;

  Participant({
    required this.userId,
    required this.name,
    required this.status,
    required this.joinedAt,
    required this.isCameraOn,
    required this.isMicOn,
    required this.userPhotoUrl,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      userId: map['userId'],
      name: map['name'],
      status: map['status'],
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      isCameraOn: map['isCameraOn'],
      isMicOn: map['isMicOn'],
      userPhotoUrl: map['userPhotoUrl'],
    );
  }

  factory Participant.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Participant(
      userId: map['userId'],
      name: map['name'],
      status: map['status'],
      joinedAt: (map['joinedAt'] as Timestamp).toDate(),
      isCameraOn: map['isCameraOn'],
      isMicOn: map['isMicOn'],
      userPhotoUrl: map['userPhotoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'status': status,
      'joinedAt': joinedAt,
      'isCameraOn': isCameraOn,
      'isMicOn': isMicOn,
      'userPhotoUrl': userPhotoUrl,
    };
  }
}
