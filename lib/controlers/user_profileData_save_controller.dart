import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserProfiledataSaveController extends GetxController {
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
    required File profileImage,
    required String email,
    required String displayName,
    required String bio,
    required String phoneNumber,
    required String jobTital,
    required String companyName,
  }) async {
    String? photoStoragePath;
    if (user == null) {
      print("User is not logged in.");
      return;
    }
    if (profileImage.path.isNotEmpty) {
      photoStoragePath = await uploadeUserProfilePhoto(
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
        "Photopath": photoStoragePath,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error uploading profile data: ${e.toString()}");
    }
  }

  Future<String?> uploadeUserProfilePhoto({required File profileImage}) async {
    String? photoStoragePath;
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
      photoStoragePath = snapshot.ref.fullPath;
    } catch (e) {
      print("###########################################################Error uploading profile photo: ${e.toString()}");
    }
    return photoStoragePath;
  }
}
