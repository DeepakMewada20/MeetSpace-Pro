import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/widgets/snackbar_and_toast_widget.dart';

class UserProfiledataSaveController extends GetxController {
  RxBool accoundDelitting = false.obs;
  RxBool requiresRecentLogin = false.obs;
  RxBool profileDataSaving = false.obs;
  // UserProfileModal? modalUser;
  User? user = FirebaseAuth.instance.currentUser;

  Future uploadUserProfileData({
    required String displayName,
    required String phoneNumber,
    required String email,
    required File? profileImage,
    required String? bio,
    required String? jobTitle,
    required String? companyName,
  }) async {
    String? profilePhotoUrl;
    try {
      if (profileImage != null && profileImage.path.isNotEmpty) {
        profilePhotoUrl = await _uploadeUserProfilePhoto(
          profileImage: profileImage,
        );
      }
      await user!.updateProfile(
        displayName: displayName,
        photoURL: profilePhotoUrl,
      );
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "bio": bio ?? '',
        "jobTitle": jobTitle ?? '',
        "companyName": companyName ?? '',
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      _getErrormassage(e.toString());
    }
  }

  Future<String?> _uploadeUserProfilePhoto({required File profileImage}) async {
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
    } catch (e) {}
    return profilePhotoUrl;
  }

  Future<Map<String, dynamic>?>  _getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) {
      return null; // no profile for this uid
    }// your model's factory
    return doc.data();
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
        } else {
          rethrow;
        }
      }
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
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
