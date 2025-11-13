import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/google_sing_in_controler.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';
import 'package:zoom_clone/screen/profile_page/edit_profile_page.dart';
import 'package:zoom_clone/widgets/show_dilog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  UserProfiledataSaveController userProfileInstance = Get.find();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
   void _deleteAccount() async {
    await userProfileInstance.deleteUserProfileData();
  }

  void _logout() async {
    await GoogleSingInControler.instence.googleSingOut();
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

              // Profile Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Profile Card
                      _buildProfileCard(context, colorScheme),

                      const SizedBox(height: 32),

                      // Profile Options
                      _buildProfileOptions(context, colorScheme),

                      const SizedBox(height: 24),

                      // Logout Section
                      _buildLogoutAndDeletAccoundSection(
                        context,
                        colorScheme,
                        tital: 'Sign Out',
                        subTital: 'Sign out of your account',
                        warningMassage: 'Are you sure you want to sign out',
                        icon: Icons.logout,
                        function: _logout,
                      ),
                      const SizedBox(height: 16),
                      // Delete Account Section
                      _buildLogoutAndDeletAccoundSection(
                        context,
                        colorScheme,
                        tital: 'Delete Account',
                        subTital: 'Permanently delete your account',
                        warningMassage:
                            'This action cannot be undone. Are you sure you want to delete your account',
                        icon: Icons.delete_outline,
                        function: _deleteAccount,
                      ),

                      const SizedBox(height: 40),
                    ],
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
                  'Profile',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your account',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _editProfile,
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
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Profile Image
          GestureDetector(
            onTap: _changeProfileImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child:
                        userProfileInstance.user == null
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Image.network(
                            userProfileInstance.user!.profileImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF667eea),
                                      Color(0xFF764ba2),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    userProfileInstance.user!.displayName.isNotEmpty
                                        ? userProfileInstance.user!.displayName[0]
                                              .toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
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

          const SizedBox(height: 20),

          // Name
          Text(
            userProfileInstance.user!=null&&
            userProfileInstance.user!.displayName.isNotEmpty ? userProfileInstance.user!.displayName : 'User Name',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // Email
          Text(
            userProfileInstance.user!=null&&
            userProfileInstance.user!.email.isNotEmpty ? userProfileInstance.user!.email : 'user@example.com',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
          ),

          const SizedBox(height: 16),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.business_outlined,
                  color: colorScheme.onPrimaryContainer,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'MeetSpace User',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.person_outlined,
            title: 'Edit Profile',
            subtitle: 'Update your information',
            onTap: _editProfile,
          ),
          _buildDivider(colorScheme),
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password and security settings',
            onTap: _openPrivacySettings,
          ),
          _buildDivider(colorScheme),
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: _openNotificationSettings,
          ),
          _buildDivider(colorScheme),
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.storage_outlined,
            title: 'Storage & Data',
            subtitle: 'Manage storage usage',
            onTap: _openStorageSettings,
          ),
          _buildDivider(colorScheme),
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: _openHelp,
          ),
          _buildDivider(colorScheme),
          _buildProfileOption(
            context,
            colorScheme,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: _showAbout,
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: colorScheme.outline.withOpacity(0.1),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.onSurfaceVariant,
              size: 16,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildLogoutAndDeletAccoundSection(
    BuildContext context,
    ColorScheme colorScheme, {
    required String tital,
    required String subTital,
    required String warningMassage,
    required IconData icon,
    required void Function() function,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ShowDilogWidget(tital, warningMassage, function);
          },
        );
      },
      // ShowDilog.dialog(tital, warningMassage, function),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.onErrorContainer, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tital,
                    style: TextStyle(
                      color: colorScheme.error,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTital,
                    style: TextStyle(
                      color: colorScheme.error.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.error.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
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
              leading: Icon(
                Icons.photo_camera_outlined,
                color: colorScheme.primary,
              ),
              title: Text(
                'Take Photo',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: colorScheme.primary,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    Get.to(() => const EditProfilePage());
  }

  void _openPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Settings functionality')),
    );
  }

  void _openNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Settings functionality')),
    );
  }

  void _openStorageSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage Settings functionality')),
    );
  }

  void _openHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & Support functionality')),
    );
  }

  void _showAbout() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'About MeetSpace Pro',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              'Build: 2024.09.04',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 MeetSpace Pro',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}

class Participant {
  final String id;
  final String name;
  final bool isSelf;
  final Color avatarColor;
  bool isVideoOn;
  bool isMuted;

  Participant({
    required this.id,
    required this.name,
    this.isSelf = false,
    this.avatarColor = Colors.blue,
    this.isVideoOn = true,
    this.isMuted = false,
  });
}
