import 'package:flutter/material.dart';
// Enhanced Participant Model
class Participant {
  final String id;
  final String name;
  final bool isSelf;
  final Color avatarColor;
  bool isVideoOn;
  bool isMuted;

  Participant({
    required this.id,
    required this.name,
    this.isSelf = false,
    this.avatarColor = Colors.blue,
    this.isVideoOn = true,
    this.isMuted = false,
  });
}