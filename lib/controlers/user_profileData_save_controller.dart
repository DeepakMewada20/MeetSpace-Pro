import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserProfiledataSaveController extends GetxController {
  RxBool accoundDelitting = false.obs;
  RxBool requiresRecentLogin = false.obs;
  User? user;
  String? photoUrl;
  String? displayName;
  String? email;
  String? phoneNumber;
  String? jobTital;
  String? companyName;
  String? bio;
  @override
  onInit() {
    super.onInit();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      photoUrl = user!.photoURL;
      displayName = user!.displayName;
      email = user!.email;
    }
  }

  Future uploadUserProfileData({
    required File? profileImage,
    required String? email,
    required String? displayName,
    required String? bio,
    required String? phoneNumber,
    required String? jobTital,
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
    if (profileImage != null && profileImage.path.isNotEmpty) {
      profilePhotoUrl = await uploadeUserProfilePhoto(
        profileImage: profileImage,
      );
    }
    try {
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "uid": user!.uid,
        "email": email,
        "username": displayName,
        "bio": bio,
        "phoneNumber": phoneNumber,
        "jobTital": jobTital,
        "companyName": companyName,
        "PhotoUrl": profilePhotoUrl,
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error uploading profile data: ${e.toString()}");
    }
  }

  Future<String?> uploadeUserProfilePhoto({required File profileImage}) async {
    String? profilePhotoUrl;
    try {
      // 1 Create a reference to the location you want to upload to in Firebase Storage
      final storageRefrence = FirebaseStorage.instance
          .ref()
          .child("user_profile_details")
          .child(user!.uid)
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

  Future<void> deleteUserProfileData() async {
    if (user == null) {
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
            .child(user!.uid)
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
            .doc(user!.uid)
            .delete();
      } on FirebaseException catch(e)  {
        if (e.code == "object-not-found") {
          print("profile photo not aplloded ##############################");
        } else {
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
}

void _getErrormassage(String errorCode) {
  switch (errorCode) {
    case "network-request-failed":
      {}
    case "requires-recent-login":
      {}
    case "user-not-found":
      {}
    case "internal-error":
      {}
    case "network-request-failed":
      {}
    case "network-request-failed":
      {}
    case "network-request-failed":
      {}
    case "network-request-failed":
      {}
    case "network-request-failed":
      {}

      break;
    default:
  }
}
