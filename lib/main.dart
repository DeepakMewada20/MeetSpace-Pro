import 'package:flutter/material.dart';
import 'package:zoom_clone/join_meeting_screen.dart';
import 'package:zoom_clone/screen/home_screen.dart';
import 'dart:math' as math;

import 'package:zoom_clone/screen/splash_screen.dart';
import 'package:zoom_clone/video_call_screen.dart';

void main() {
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetSpace Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'SF Pro Display',
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/call': (context) => VideoCallScreen(),
        '/join': (context) => JoinMeetingScreen(),
      },
    );
  }
}