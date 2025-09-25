import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone/modal/user_profile_modal.dart';
import 'package:zoom_clone/widgets/snackbar_and_toast_widget.dart';

class UserProfiledataSaveController extends GetxController {
  RxBool accoundDelitting = false.obs;
  RxBool requiresRecentLogin = false.obs;
  UserProfileModal? user;
  User? flutterUser;
  @override
  onInit() async {
    super.onInit();
    flutterUser = FirebaseAuth.instance.currentUser;
    if (flutterUser != null) {
      user = await _getUserData(flutterUser!.uid);
    }
  }

  Future uploadUserProfileData({
    required File? profileImage,
    required String? email,
    required String? displayName,
    required String? bio,
    required String? phoneNumber,
    required String? jobTitle,
    required String? companyName,
  }) async {
    String? profilePhotoUrl;
    if (user == null) {
      Get.snackbar(
        "Data not saved!!",
        "please login first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      await _saveProfileLocal(
        UserProfileModal(
          uid: flutterUser!.uid,
          email: email ?? '',
          displayName: displayName ?? '',
          profileImage: profileImage,
          profileImagePath: profileImage?.path ?? '',
          bio: bio ?? '',
          phoneNumber: phoneNumber ?? '',
          jobTitle: jobTitle ?? '',
          companyName: companyName ?? '',
        ),
      );
      if (profileImage != null && profileImage.path.isNotEmpty) {
        profilePhotoUrl = await _uploadeUserProfilePhoto(
          profileImage: profileImage,
        );
      }
      await FirebaseFirestore.instance
          .collection("users")
          .doc(flutterUser!.uid)
          .set({
            "uid": flutterUser!.uid,
            "email": email,
            "displayName": displayName,
            "bio": bio,
            "phoneNumber": phoneNumber,
            "jobTitle": jobTitle,
            "companyName": companyName,
            "profileImageUrl": profilePhotoUrl,
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print("Error uploading profile data: ${e.toString()}");
    }
  }

  Future<String?> _uploadeUserProfilePhoto({required File profileImage}) async {
    String? profilePhotoUrl;
    try {
      // 1 Create a reference to the location you want to upload to in Firebase Storage
      final storageRefrence = FirebaseStorage.instance
          .ref()
          .child("user_profile_details")
          .child(flutterUser!.uid)
          .child("profilePhoto.jpg");
      // 2 This starts the upload:
      UploadTask uploadTask = storageRefrence.putFile(profileImage);
      // 3 Waits till the file is uploaded then stores the download url
      TaskSnapshot snapshot = await uploadTask;
      profilePhotoUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(
        "###########################################################Error uploading profile photo: ${e.toString()}",
      );
    }
    return profilePhotoUrl;
  }

  Future<UserProfileModal?> _getUserData(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_profile');
    if (userDataString != null) {
      final userDataMap = jsonDecode(userDataString);
      return UserProfileModal.fromJson(userDataMap);
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        return null; // no profile for this uid
      }

      final data = doc.data()!; // Map<String, dynamic>
      return UserProfileModal.fromJson(data); // your model's factory
    }
  }

  Future<void> deleteUserProfileData() async {
    if (flutterUser == null) {
      Get.snackbar(
        "Data not deleted!!",
        "please login first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    accoundDelitting.value = true;
    try {
      // Optionally, you can also delete the user's profile photo from Firebase Storage
      try {
        await FirebaseStorage.instance
            .ref()
            .child("user_profile_details")
            .child(flutterUser!.uid)
            .child("profilePhoto.jpg")
            .delete();
      } on FirebaseException catch (e) {
        if (e.code == "object-not-found") {
          print("profile photo not aplloded ##############################");
        } else {
          rethrow;
        }
      }
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(flutterUser!.uid)
            .delete();
      } on FirebaseException catch (e) {
        if (e.code == "object-not-found") {} 
        else {
          rethrow;
        }
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        requiresRecentLogin.value = true;
      } else {}
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print("Error deleting profile data: ${e.toString()}");
    } finally {
      accoundDelitting.value = false;
    }
  }

  Future<void> _saveProfileLocal(UserProfileModal profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(profile.toJson()));
  }

  void _getErrormassage(String errorCode) {
    switch (errorCode) {
      case "network-request-failed":
        {
          SnackbarAndToastWidget.tostMessage("No internet connection");
        }
      case "requires-recent-login":
        {
          SnackbarAndToastWidget.tostMessage("Please re-login to continue");
        }
      case "user-not-found":
        {
          SnackbarAndToastWidget.tostMessage("User not found");
        }
      case "internal-error":
        {
          SnackbarAndToastWidget.tostMessage("Internal error");
        }
      case "network-request-failed":
        {
          SnackbarAndToastWidget.tostMessage("Network request failed");
        }
      case "too-many-requests":
        {
          SnackbarAndToastWidget.tostMessage("Too many requests");
        }
        break;
      default:
        {
          SnackbarAndToastWidget.tostMessage("Something went wrong");
        }
    }
  }
}
