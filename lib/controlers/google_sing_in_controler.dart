import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoom_clone/wrapper.dart';

class GoogleSingInControler extends GetxController {
  static GoogleSingInControler instence = Get.find<GoogleSingInControler>();
  RxBool isLoading = false.obs;
  RxBool isGoogleLoading = false.obs;
  RxBool isSingOut = false.obs;
  //Rx<User?> _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  GoogleSignIn googleSingIn = GoogleSignIn.instance;

  // Method to handle Google Sign-In
  Future<bool> googleSignIn() async {
    isGoogleLoading.value = true;
    GoogleSignInAccount? user;
    // Initialize Google Sign-In with your client ID (must be called before sign-in)
    unawaited(
      googleSingIn.initialize(
        serverClientId:
            "467631095706-t865dsh3fvutck6jj4507j1ks2nrubrn.apps.googleusercontent.com",
      ),
    );

    try {
      // 3. Try lightweight auth (may show UI on some platforms)
      user = await googleSingIn.attemptLightweightAuthentication();
      // 4. If lightweight auth did not succeed, do full sign-in
      user == null ? user = await googleSingIn.authenticate() : null;
      return await _googleSingInHepplerFunction(user);
      // SnackbarAndToastWidget.tostMessage("google SingIn scsesfull");
    } on FirebaseAuthException catch (e) {
      _errorSnackbar(
        'Error',
        'Google Sign-In failed: ${_getErrormassage(e.code)}',
      );
    } on GoogleSignInException catch (e) {
      final desc = e.description ?? '';
      if (e.code == GoogleSignInExceptionCode.canceled &&
          desc.toLowerCase().contains('reauth failed')) {
        try {
          await googleSingIn.signOut();
          final fresUser = await googleSingIn.authenticate();
          await _googleSingInHepplerFunction(fresUser);
        } catch (e) {
          _errorSnackbar(
            'Error',
            "An unknown error occurred. Please try again later.${e.toString()}",
          );
        }
      }
      // More explicit feedback for common setup problems:
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError) {
        _errorSnackbar(
          'Google Sign-In (config)',
          desc.isNotEmpty ? desc : 'Client configuration error.',
        );
      } else {
        _errorSnackbar(
          'Google Sign-In',
          desc.isNotEmpty ? desc : 'Unknown error',
        );
      }
    } catch (e) {
      _errorSnackbar(
        'Error',
        "An unknown error occurred. Please try again later.${e.toString()}",
      );
    } finally {
      isGoogleLoading.value = false;
    }
    return false;
  }

  Future<bool> googleSingOut() async {
    isSingOut.value = true;
    try {
      // Sign out from Google
      await googleSingIn.disconnect();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      _errorSnackbar(
        'Sign-Out Error',
        'Failed to sign out from : ${e.toString()}',
      );
      return false;
    } finally {
      isSingOut.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => Wrapper()); // Navigate to Wrapper
    } on FirebaseAuthException catch (e) {
      _errorSnackbar('Login failed', _getErrormassage(e.code));
    } catch (e) {
      _errorSnackbar(
        'Login Failed',
        'An unknown error occurred. Please try again later.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _googleSingInHepplerFunction(GoogleSignInAccount user) async {
    final GoogleSignInAuthentication googleAuth = user.authentication;

    // Create a new credential using the Google authentication token
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credentials
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    if (userCredential.user != null) {
      return true;
    }
    return false;
  }

  dynamic _errorSnackbar(String title, String message) {
    // Close all existing snackbars before showing a new one
    // This prevents multiple snackbars from stacking up
    // and ensures that the user sees the most recent error message.
    Get.closeCurrentSnackbar();

    return Get.snackbar(
      title,
      message,
      // snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: Colors.red,
      // colorText: Colors.white,
    );
  }

  String _getErrormassage(String errorCode) {
    switch (errorCode) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials. Please sign in using a different method.';
      case 'invalid-credential':
        return 'The provided credential is invalid.';
      case 'operation-not-allowed':
        return 'Google Sign-In is not enabled for this project.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      case 'user-not-found':
        return 'user-not-found';
      default:
        return 'An unknown error occurred. Please try again later.';
    }
  }
}
