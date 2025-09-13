import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SnackbarAndToastWidget {
  static void errorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Get.theme.colorScheme.error,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void successSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Get.theme.colorScheme.primary,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void tostMessage(String message) {
    Fluttertoast.showToast(
      msg: "Successfully signed out",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
