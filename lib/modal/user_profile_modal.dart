import 'dart:io';

class UserProfileModal {
  final File?
  profileImage; // local file (only for app use, not stored directly in Firestore)
  final String profileImageUrl;
  final String profileImagePath;
  final String uid;
  final String email;
  final String displayName;
  final String bio;
  final String phoneNumber;
  final String jobTitle;
  final String companyName;
  final bool isProfileUpdated=false;

  UserProfileModal({
    this.profileImage,
    required this.profileImageUrl,
    required this.uid,
    required this.email,
    required this.displayName,
    required this.profileImagePath,
    required this.bio,
    required this.phoneNumber,
    required this.jobTitle,
    required this.companyName,
  });

  /// Convert to Map (for Firestore/SharedPreferences)
  Map<String, dynamic> toJson({String? profileImageUrl}) {
    return {
      'profileImageUrl':
          profileImageUrl ?? '', // URL after uploading to Firebase Storage
      'profileImagePath': profileImagePath ?? '',
      'uID': uid,
      'email': email,
      'displayName': displayName,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'jobTitle': jobTitle,
      'companyName': companyName,
    };
  }

  /// Create from Map (from Firestore)
  factory UserProfileModal.fromJson(Map<String, dynamic> json) {
    return UserProfileModal(
      profileImage: null, // local file cannot be stored in Firestore
      profileImagePath: json['profileImagePath'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      uid: json['uID'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      bio: json['bio'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
    );
  }
}
