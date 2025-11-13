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
  User? _flutterUser;
  @override
  void onInit() async {
    super.onInit();
    _flutterUser = FirebaseAuth.instance.currentUser;
    if (_flutterUser != null) {
      user = UserProfileModal(
        uid: _flutterUser!.uid,
        email: _flutterUser!.email ?? "",
        displayName: _flutterUser!.displayName ?? "",
        profileImagePath: "",
        bio: '',
        phoneNumber: _flutterUser!.phoneNumber ?? "",
        jobTitle: '',
        companyName: '',
        profileImageUrl: _flutterUser!.photoURL ?? "",
      );
      _dataprint(user!);
      update();
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (user != null) {
      user = await _getUserData(_flutterUser!.uid);
    }
    _dataprint(user!);
    update();
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
          uid: _flutterUser!.uid,
          email: email ?? _flutterUser!.email ?? '',
          displayName: displayName ?? _flutterUser!.displayName ?? '',
          profileImageUrl: _flutterUser!.photoURL ?? '',
          profileImage: profileImage,
          profileImagePath: profileImage?.path ?? '',
          bio: bio ?? '',
          phoneNumber: phoneNumber ?? _flutterUser!.phoneNumber ?? '',
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
          .doc(_flutterUser!.uid)
          .set({
            "uid": _flutterUser!.uid,
            "email": email??_flutterUser!.email??'',
            "displayName": displayName??_flutterUser!.displayName??'',
            "bio": bio??'',
            "phoneNumber": phoneNumber??_flutterUser!.phoneNumber??'',
            "jobTitle": jobTitle??'',
            "companyName": companyName??'',
            "profileImageUrl": profilePhotoUrl??_flutterUser!.photoURL??'',
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
          .child(_flutterUser!.uid)
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
    if (_flutterUser == null) {
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
            .child(_flutterUser!.uid)
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
            .doc(_flutterUser!.uid)
            .delete();
      } on FirebaseException catch (e) {
        if (e.code == "object-not-found") {
        } else {
          rethrow;
        }
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        requiresRecentLogin.value = true;
      } else {
        _getErrormassage(e.code);
      }
    } on FirebaseException catch (e) {
      _getErrormassage(e.code);
    } catch (e) {
      _getErrormassage(e.toString());
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
          break;
        }
      case "requires-recent-login":
        {
          SnackbarAndToastWidget.tostMessage("Please re-login to continue");
          break;
        }
      case "user-not-found":
        {
          SnackbarAndToastWidget.tostMessage("User not found");
          break;
        }
      case "internal-error":
        {
          SnackbarAndToastWidget.tostMessage("Internal error");
          break;
        }
      case "too-many-requests":
        {
          SnackbarAndToastWidget.tostMessage("Too many requests");
        }
        break;
      default:
        {
          SnackbarAndToastWidget.tostMessage(errorCode);
          break;
        }
    }
  }
}

void _dataprint(UserProfileModal user) {
  print("User Profile Data:");
  print("UID: ${user.uid}");
  print("Email: ${user.email}");
  print("Display Name: ${user.displayName}");
  print("Bio: ${user.bio}");
  print("Phone Number: ${user.phoneNumber}");
  print("Job Title: ${user.jobTitle}");
  print("Company Name: ${user.companyName}");
  print("Profile Image Path: ${user.profileImagePath}");
  print("Profile Image URL: ${user.profileImageUrl}");

}
