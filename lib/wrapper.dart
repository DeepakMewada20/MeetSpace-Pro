import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone/login_functinality/pages/email_verification_page.dart';
import 'package:zoom_clone/login_functinality/pages/login_page.dart';
import 'package:zoom_clone/screen/profile_page/profile_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (snapshot.hasData && user != null) {
              if (user.providerData.any(
                (provider) => provider.providerId == 'phone',
              )) {
                return ProfilePage(); // Navigate to Home Page if phone authentication is used
              } else {
                if (user.emailVerified) {
                  return ProfilePage(); // Navigate to Home Page if email is verified
                } else {
                  // Navigate to Email Verification Page if email is not verified
                  return EmailVerificationPage();
                }
              }
            } else {
              // If user is null, navigate to Login Page
              return LoginPage();
            }
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          }
        },
      ),
    );
  }
}
