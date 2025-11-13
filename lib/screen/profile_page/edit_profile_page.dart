import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _bioController = TextEditingController();

  UserProfiledataSaveController userProfileInstance = Get.find();
  String? _pickedImage;
  bool _showProfile = true;
  bool _showOnlineStatus = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Pre-fill with existing data
    _nameController.text = userProfileInstance.user?.displayName ?? 'User Name';
    _emailController.text =
        userProfileInstance.user?.email ?? 'user@example.com';
    _phoneController.text =
        userProfileInstance.user?.phoneNumber ?? '+1 (555) 123-4567';
    _jobTitleController.text =
        userProfileInstance.user?.jobTitle ?? 'MeetSpace User';
    _companyController.text =
        userProfileInstance.user?.companyName ?? 'MeetSpace Pro';
    _bioController.text =
        userProfileInstance.user?.bio ??
        'Passionate professional using MeetSpace Pro for seamless video meetings and collaboration.';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header matching home screen style
              _buildHeader(context, colorScheme),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Profile Image Section
                        _buildProfileImageSection(context, colorScheme),

                        const SizedBox(height: 32),

                        // Basic Information
                        _buildBasicInfoSection(context, colorScheme),

                        const SizedBox(height: 24),

                        // Professional Information
                        _buildProfessionalInfoSection(context, colorScheme),

                        const SizedBox(height: 24),

                        // Privacy Settings
                        _buildPrivacySection(context, colorScheme),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Update your information',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _saveProfile,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: GestureDetector(
        onTap: _changeProfileImage,
        child: Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: _pickedImage != null
                    ? Image.file(File(_pickedImage!), fit: BoxFit.cover)
                    : userProfileInstance.user?.profileImageUrl != null
                    ? Image.network(
                        userProfileInstance.user!.profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar(colorScheme);
                        },
                      )
                    : _buildDefaultAvatar(colorScheme),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 3),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: colorScheme.onPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(ColorScheme colorScheme) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: Center(
        child: Text(
          userProfileInstance.user!.displayName.isNotEmpty
              ? userProfileInstance.user!.displayName[0].toUpperCase()
              : 'U',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.person_outlined,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Basic Information',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            context,
            colorScheme,
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            colorScheme,
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            colorScheme,
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.work_outlined,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Professional Information',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            context,
            colorScheme,
            controller: _jobTitleController,
            label: 'Job Title',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            colorScheme,
            controller: _companyController,
            label: 'Company',
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            colorScheme,
            controller: _bioController,
            label: 'Bio',
            icon: Icons.info_outlined,
            maxLines: 3,
            maxLength: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Privacy Settings',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSwitchTile(
            context,
            colorScheme,
            title: 'Show profile to others',
            subtitle: 'Allow others to see your profile',
            value: _showProfile,
            onChanged: (value) {
              setState(() {
                _showProfile = value;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            context,
            colorScheme,
            title: 'Show online status',
            subtitle: 'Let others see when you\'re online',
            value: _showOnlineStatus,
            onChanged: (value) {
              setState(() {
                _showOnlineStatus = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    ColorScheme colorScheme, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          counterStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          errorStyle: TextStyle(color: colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  void _changeProfileImage() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: colorScheme.primary,
                ),
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  color: colorScheme.primary,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: colorScheme.onErrorContainer,
                ),
              ),
              title: Text(
                'Remove Photo',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                setState(() {
                  _pickedImage = null;
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      if (pickedFile == null && mounted) {
        Navigator.pop(context);
        return;
      }

      // final croppedFile = await ImageCropper().cropImage(
      //   sourcePath: pickedFile!.path,
      //   uiSettings: [
      //     if (mounted)
      //       AndroidUiSettings(
      //         toolbarTitle: 'Crop Image',
      //         // toolbarColor: Theme.of(context).colorScheme.primary,
      //         // toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
      //         initAspectRatio: CropAspectRatioPreset.square,
      //         lockAspectRatio: true,
      //         cropStyle: CropStyle.circle,
      //         statusBarColor: Theme.of(context).colorScheme.surface,
      //       ),
      //       IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      //   ],
      // );

      Navigator.pop(context);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = pickedFile.path;
        });
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      try {
        UserProfiledataSaveController instance = Get.find();
        instance.uploadUserProfileData(
          profileImage: _pickedImage != null ? File(_pickedImage!) : null,
          displayName: _nameController.text,
          bio: _bioController.text,
          phoneNumber: _phoneController.text,
          jobTitle: _jobTitleController.text,
          companyName: _companyController.text,
          email: _emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Get.back();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}
