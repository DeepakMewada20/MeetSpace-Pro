import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserProfiledataSaveController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;
  Future uploadUserProfilePhoto(File file) async {
    if (user == null) {
      print("User is not logged in.");
      return;
    }
    try {
      // 1 Create a reference to the location you want to upload to in Firebase Storage
      final storageRefrence = FirebaseStorage.instance
          .ref()
          .child("user_profile_photos")
          .child("${user!.uid}.jpg");
      // 2 This starts the upload:
      UploadTask uploadTask = storageRefrence.putFile(file);

      // 3 Waits till the file is uploaded then stores the download url
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");
      // 4 Update the user's profile with the new photo URL
      // await user!.updatePhotoURL(downloadUrl);
      // await user!.reload();
      // user = FirebaseAuth.instance.currentUser;
      // print("Profile photo updated successfully.");
    } catch (e) {
      print("Error uploading profile photo: ${e.toString()}");
    }
  }
}
