import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/google_sing_in_controler.dart';
import 'package:zoom_clone/controlers/phone_number_login_controller.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';
import 'package:zoom_clone/screen/join_meeting_screen.dart';
import 'package:zoom_clone/screen/home%20screen/home_screen.dart';
import 'package:zoom_clone/screen/splash_screen.dart';
import 'package:zoom_clone/screen/video_call_screen.dart';
import 'package:zoom_clone/them_data/dart_them.dart';
import 'package:zoom_clone/them_data/light_them.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut<GoogleSingInControler>(
    () => GoogleSingInControler(),
  ); // Initialize the Google Sign-In controller
  Get.lazyPut<PhoneNumberLoginController>(() => PhoneNumberLoginController());
  Get.put<UserProfiledataSaveController>(
    UserProfiledataSaveController(),
  );
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        title: 'MeetSpace Pro',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: SplashScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/join': (context) => JoinMeetingScreen(),
          '/call': (context) => VideoCallScreen(),
        },
      ),
    );
  }
}
