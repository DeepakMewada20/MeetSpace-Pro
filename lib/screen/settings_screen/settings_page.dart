import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Settings state variables
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _cameraAutoOn = false;
  bool _micAutoOn = false;
  bool _darkModeEnabled = true;
  bool _wifiOnlyMode = false;
  String _videoQuality = 'HD';
  String _audioQuality = 'High';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(239, 15, 32, 39),
              Color.fromARGB(237, 32, 58, 67),
              Color.fromARGB(240, 44, 83, 100),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: _resetToDefaults,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // General Settings
                        _buildSettingsSection(
                          title: 'General',
                          icon: Icons.settings,
                          children: [
                            _buildSwitchTile(
                              title: 'Notifications',
                              subtitle: 'Enable push notifications',
                              icon: Icons.notifications,
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              title: 'Sound',
                              subtitle: 'Play notification sounds',
                              icon: Icons.volume_up,
                              value: _soundEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _soundEnabled = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
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
                              title: 'Dark Mode',
                              subtitle: 'Use dark theme',
                              icon: Icons.dark_mode,
                              value: _darkModeEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _darkModeEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Meeting Settings
                        _buildSettingsSection(
                          title: 'Meeting Preferences',
                          icon: Icons.video_call,
                          children: [
                            _buildSwitchTile(
                              title: 'Auto-start Camera',
                              subtitle: 'Turn on camera when joining meetings',
                              icon: Icons.videocam,
                              value: _cameraAutoOn,
                              onChanged: (value) {
                                setState(() {
                                  _cameraAutoOn = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              title: 'Auto-start Microphone',
                              subtitle: 'Turn on mic when joining meetings',
                              icon: Icons.mic,
                              value: _micAutoOn,
                              onChanged: (value) {
                                setState(() {
                                  _micAutoOn = value;
                                });
                              },
                            ),
                            _buildDropdownTile(
                              title: 'Video Quality',
                              subtitle: 'Default video quality for meetings',
                              icon: Icons.high_quality,
                              value: _videoQuality,
                              items: ['SD', 'HD', 'Full HD'],
                              onChanged: (value) {
                                setState(() {
                                  _videoQuality = value!;
                                });
                              },
                            ),
                            _buildDropdownTile(
                              title: 'Audio Quality',
                              subtitle: 'Audio quality for meetings',
                              icon: Icons.audiotrack,
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

                        SizedBox(height: 20),

                        // Network & Data
                        _buildSettingsSection(
                          title: 'Network & Data',
                          icon: Icons.wifi,
                          children: [
                            _buildSwitchTile(
                              title: 'Wi-Fi Only Mode',
                              subtitle: 'Only use Wi-Fi for meetings',
                              icon: Icons.wifi,
                              value: _wifiOnlyMode,
                              onChanged: (value) {
                                setState(() {
                                  _wifiOnlyMode = value;
                                });
                              },
                            ),
                            _buildActionTile(
                              title: 'Data Usage',
                              subtitle: 'View data consumption statistics',
                              icon: Icons.data_usage,
                              onTap: _showDataUsage,
                            ),
                            _buildActionTile(
                              title: 'Network Test',
                              subtitle: 'Test network speed and quality',
                              icon: Icons.speed,
                              onTap: _runNetworkTest,
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Privacy & Security
                        _buildSettingsSection(
                          title: 'Privacy & Security',
                          icon: Icons.security,
                          children: [
                            _buildActionTile(
                              title: 'Change Password',
                              subtitle: 'Update your account password',
                              icon: Icons.lock,
                              onTap: _changePassword,
                            ),
                            _buildActionTile(
                              title: 'Two-Factor Authentication',
                              subtitle: 'Enable 2FA for extra security',
                              icon: Icons.security,
                              onTap: _setup2FA,
                            ),
                            _buildActionTile(
                              title: 'Privacy Policy',
                              subtitle: 'Read our privacy policy',
                              icon: Icons.privacy_tip,
                              onTap: _showPrivacyPolicy,
                            ),
                            _buildActionTile(
                              title: 'Terms of Service',
                              subtitle: 'View terms and conditions',
                              icon: Icons.description,
                              onTap: _showTerms,
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Support & About
                        _buildSettingsSection(
                          title: 'Support & About',
                          icon: Icons.help,
                          children: [
                            _buildActionTile(
                              title: 'Help Center',
                              subtitle: 'Get help and find answers',
                              icon: Icons.help_center,
                              onTap: _openHelpCenter,
                            ),
                            _buildActionTile(
                              title: 'Contact Support',
                              subtitle: 'Get in touch with our team',
                              icon: Icons.contact_support,
                              onTap: _contactSupport,
                            ),
                            _buildActionTile(
                              title: 'Report a Bug',
                              subtitle: 'Help us improve the app',
                              icon: Icons.bug_report,
                              onTap: _reportBug,
                            ),
                            _buildActionTile(
                              title: 'Rate App',
                              subtitle: 'Rate MeetSpace Pro on app store',
                              icon: Icons.star,
                              onTap: _rateApp,
                            ),
                            _buildActionTile(
                              title: 'App Version',
                              subtitle: 'Version 1.0.0 (Build 2024.09.04)',
                              icon: Icons.info,
                              onTap: _showAppInfo,
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF667eea),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Color(0xFF667eea),
            activeTrackColor: Color(0xFF667eea).withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white60,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:  0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:  0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              underline: SizedBox(),
              dropdownColor: Color.fromARGB(240, 44, 83, 100),
              style: TextStyle(color: Colors.white, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:  0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white60,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }

  // Action methods
  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color.fromARGB(240, 44, 83, 100),
        title: Text('Reset Settings', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to reset all settings to default values?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
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
                _darkModeEnabled = true;
                _wifiOnlyMode = false;
                _videoQuality = 'HD';
                _audioQuality = 'High';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDataUsage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Usage feature coming soon')),
    );
  }

  void _runNetworkTest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Running network test...')),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change Password functionality')),
    );
  }

  void _setup2FA() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Two-Factor Authentication setup')),
    );
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Privacy Policy')),
    );
  }

  void _showTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terms of Service')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help Center')),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contact Support')),
    );
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bug Report')),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rate App')),
    );
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Color.fromARGB(240, 44, 83, 100),
        title: Text('MeetSpace Pro', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('Build: 2024.09.04', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('© 2024 MeetSpace Pro', style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Color(0xFF667eea))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}