import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ConstenedValue extends GetxController {
  static const String? currentUserUid = null;
  static const String? currentUserEmail = null;
  static User? currentUser;

  @override
  void onInit() async {
    currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        currentUser = null;
      } else {
        currentUser = user;
      }
    });
    super.onInit();
  }
}
