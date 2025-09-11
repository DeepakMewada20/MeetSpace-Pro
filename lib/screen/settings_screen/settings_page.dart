import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Settings state variables
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _cameraAutoOn = false;
  bool _micAutoOn = false;
  bool _darkModeEnabled = false;
  bool _wifiOnlyMode = false;
  String _videoQuality = 'HD';
  String _audioQuality = 'High';

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

              // Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // General Settings
                      _buildSettingsSection(
                        context,
                        colorScheme,
                        title: 'General',
                        icon: Icons.settings,
                        children: [
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Notifications',
                            subtitle: 'Enable push notifications',
                            icon: Icons.notifications_outlined,
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Sound',
                            subtitle: 'Play notification sounds',
                            icon: Icons.volume_up_outlined,
                            value: _soundEnabled,
                            onChanged: (value) {
                              setState(() {
                                _soundEnabled = value;
                              });
                            },
                          ),
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Vibration',
                            subtitle: 'Vibrate on notifications',
                            icon: Icons.vibration,
                            value: _vibrationEnabled,
                            onChanged: (value) {
                              setState(() {
                                _vibrationEnabled = value;
                              });
                            },
                          ),
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Dark Mode',
                            subtitle: 'Use dark theme',
                            icon: Icons.dark_mode_outlined,
                            value: _darkModeEnabled,
                            onChanged: (value) {
                              setState(() {
                                _darkModeEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Meeting Settings
                      _buildSettingsSection(
                        context,
                        colorScheme,
                        title: 'Meeting Preferences',
                        icon: Icons.video_call_outlined,
                        children: [
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Auto-start Camera',
                            subtitle: 'Turn on camera when joining meetings',
                            icon: Icons.videocam_outlined,
                            value: _cameraAutoOn,
                            onChanged: (value) {
                              setState(() {
                                _cameraAutoOn = value;
                              });
                            },
                          ),
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Auto-start Microphone',
                            subtitle: 'Turn on mic when joining meetings',
                            icon: Icons.mic_outlined,
                            value: _micAutoOn,
                            onChanged: (value) {
                              setState(() {
                                _micAutoOn = value;
                              });
                            },
                          ),
                          _buildDropdownTile(
                            context,
                            colorScheme,
                            title: 'Video Quality',
                            subtitle: 'Default video quality for meetings',
                            icon: Icons.high_quality_outlined,
                            value: _videoQuality,
                            items: ['SD', 'HD', 'Full HD'],
                            onChanged: (value) {
                              setState(() {
                                _videoQuality = value!;
                              });
                            },
                          ),
                          _buildDropdownTile(
                            context,
                            colorScheme,
                            title: 'Audio Quality',
                            subtitle: 'Audio quality for meetings',
                            icon: Icons.audiotrack_outlined,
                            value: _audioQuality,
                            items: ['Low', 'Medium', 'High'],
                            onChanged: (value) {
                              setState(() {
                                _audioQuality = value!;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Network & Data
                      _buildSettingsSection(
                        context,
                        colorScheme,
                        title: 'Network & Data',
                        icon: Icons.wifi_outlined,
                        children: [
                          _buildSwitchTile(
                            context,
                            colorScheme,
                            title: 'Wi-Fi Only Mode',
                            subtitle: 'Only use Wi-Fi for meetings',
                            icon: Icons.wifi_outlined,
                            value: _wifiOnlyMode,
                            onChanged: (value) {
                              setState(() {
                                _wifiOnlyMode = value;
                              });
                            },
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Data Usage',
                            subtitle: 'View data consumption statistics',
                            icon: Icons.data_usage_outlined,
                            onTap: _showDataUsage,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Network Test',
                            subtitle: 'Test network speed and quality',
                            icon: Icons.speed_outlined,
                            onTap: _runNetworkTest,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Privacy & Security
                      _buildSettingsSection(
                        context,
                        colorScheme,
                        title: 'Privacy & Security',
                        icon: Icons.security_outlined,
                        children: [
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Change Password',
                            subtitle: 'Update your account password',
                            icon: Icons.lock_outline,
                            onTap: _changePassword,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Two-Factor Authentication',
                            subtitle: 'Enable 2FA for extra security',
                            icon: Icons.security_outlined,
                            onTap: _setup2FA,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Privacy Policy',
                            subtitle: 'Read our privacy policy',
                            icon: Icons.privacy_tip_outlined,
                            onTap: _showPrivacyPolicy,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Terms of Service',
                            subtitle: 'View terms and conditions',
                            icon: Icons.description_outlined,
                            onTap: _showTerms,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Support & About
                      _buildSettingsSection(
                        context,
                        colorScheme,
                        title: 'Support & About',
                        icon: Icons.help_outline,
                        children: [
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Help Center',
                            subtitle: 'Get help and find answers',
                            icon: Icons.help_center_outlined,
                            onTap: _openHelpCenter,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Contact Support',
                            subtitle: 'Get in touch with our team',
                            icon: Icons.contact_support_outlined,
                            onTap: _contactSupport,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Report a Bug',
                            subtitle: 'Help us improve the app',
                            icon: Icons.bug_report_outlined,
                            onTap: _reportBug,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'Rate App',
                            subtitle: 'Rate MeetSpace Pro on app store',
                            icon: Icons.star_outline,
                            onTap: _rateApp,
                          ),
                          _buildActionTile(
                            context,
                            colorScheme,
                            title: 'App Version',
                            subtitle: 'Version 1.0.0 (Build 2024.09.04)',
                            icon: Icons.info_outline,
                            onTap: _showAppInfo,
                          ),
                        ],
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
                  'Settings',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Customize your experience',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _resetToDefaults,
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
                Icons.refresh,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: colorScheme.onPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
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

  Widget _buildDropdownTile(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 12),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              underline: const SizedBox(),
              dropdownColor: colorScheme.surfaceContainer,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 18),
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
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: colorScheme.surface,
      ),
    );
  }

  // Action methods
  void _resetToDefaults() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Settings',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to reset all settings to default values?',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = true;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _cameraAutoOn = false;
                _micAutoOn = false;
                _darkModeEnabled = false;
                _wifiOnlyMode = false;
                _videoQuality = 'HD';
                _audioQuality = 'High';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to defaults'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
            child: Text('Reset', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _showDataUsage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data Usage feature coming soon')),
    );
  }

  void _runNetworkTest() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Running network test...')));
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Password functionality')),
    );
  }

  void _setup2FA() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-Factor Authentication setup')),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Privacy Policy')));
  }

  void _showTerms() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Terms of Service')));
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Help Center')));
  }

  void _contactSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Contact Support')));
  }

  void _reportBug() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bug Report')));
  }

  void _rateApp() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Rate App')));
  }

  void _showAppInfo() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'MeetSpace Pro',
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
