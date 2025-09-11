import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/google_sing_in_controler.dart';
import 'package:zoom_clone/controlers/phone_number_login_controller.dart';
import 'package:zoom_clone/screen/join_meeting_screen.dart';
import 'package:zoom_clone/screen/home%20screen/home_screen.dart';
import 'package:zoom_clone/screen/splash_screen.dart';
import 'package:zoom_clone/screen/video_call_screen.dart';
import 'package:zoom_clone/them_data/dart_them.dart';
import 'package:zoom_clone/them_data/light_them.dart';
import 'firebase_options.dart';

// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   fontFamily: 'SF Pro Display',
//   colorScheme: const ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFF2563EB), // Blue (main brand color)
//     onPrimary: Color(0xFFFFFFFF), // White text/icons on blue
//     secondary: Color(0xFF22C55E), // Green (accept/confirm)
//     onSecondary: Color(0xFFFFFFFF), // Dark text/icons on background
//     surface: Color(0xFFFFFFFF), // White for cards/sheets
//     onSurface: Color(0xFF111827), // Dark text on surfaces
//     error: Color(0xFFEF4444), // Red (end call/error)
//     onError: Color(0xFFFFFFFF), // White on red
//   ),
// );

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   fontFamily: 'SF Pro Display',
//   colorScheme: const ColorScheme(
//     brightness: Brightness.dark,
//     primary: Color(0xFF3B82F6), // Bright blue
//     onPrimary: Color(0xFFFFFFFF), // White text/icons on blue
//     secondary: Color(0xFF22C55E), // Green (accept/confirm)
//     onSecondary: Color(0xFFFFFFFF), // White text/icons
//     surface: Color(0xFF1E1E2E), // Dark card/dialog
//     onSurface: Color(0xFFFFFFFF), // White on surfaces
//     error: Color(0xFFEF4444), // Red (end call/error)
//     onError: Color(0xFFFFFFFF), // White on red
//   ),
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(GoogleSingInControler()); // Initialize the Google Sign-In controller
  Get.put(PhoneNumberLoginController());
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MeetSpace Pro',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   fontFamily: 'SF Pro Display',
      // ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/call': (context) => VideoCallScreen(),
        '/join': (context) => JoinMeetingScreen(),
      },
    );
  }
}
