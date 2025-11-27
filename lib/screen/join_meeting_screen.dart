import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/join_metting_method.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';
import 'package:zoom_clone/modal/join_metting_modal.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:zoom_clone/widgets/media_controller.dart';

class JoinMeetingScreen extends ConsumerStatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  ConsumerState<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends ConsumerState<JoinMeetingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _meetingIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserProfiledataSaveController userProfileInstance = Get.put(
    UserProfiledataSaveController(),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _hasPassword = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    // final MettingState = ref.read(MettingNotifier().mettingProvider);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _meetingIdController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final state = ref.watch(joinMettingProvide);

    final notifier = ref.read(joinMettingProvide.notifier);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              _buildHeader(context, colorScheme),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(context, colorScheme),

                      const SizedBox(height: 32),

                      // Meeting Details Form
                      _buildMeetingForm(context, colorScheme, state, notifier),

                      const SizedBox(height: 24),

                      // Camera & Microphone Controls
                      buildMediaControls(
                        context,
                        colorScheme,
                        state,
                        notifier,
                      ),

                      const SizedBox(height: 32),

                      // Join Button
                      _buildJoinButton(context, colorScheme, state, notifier),

                      const SizedBox(height: 24),

                      // Info Section
                      _buildInfoSection(context, colorScheme),
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
            onTap: () => Navigator.pop(context),
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
                color: colorScheme.onSurfaceVariant,
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
                  'Join Meeting',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Enter meeting details',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipOval(
              child: userProfileInstance.modalUser == null
                  ? Icon(
                      Icons.person,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    )
                  : Image.network(
                      userProfileInstance.modalUser!.profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.meeting_room,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to Join?',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter the meeting details to connect',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingForm(
    BuildContext context,
    ColorScheme colorScheme,
    JoinMeetingState state,
    JoinMettingNotifire notifier,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meeting Details',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Meeting ID Field
          _buildTextField(
            controller: _meetingIdController,
            label: 'Meeting ID',
            hint: 'Enter meeting ID',
            errorMessage: state.errorMessage ?? "",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the meeting ID';
              }
              return null;
            },
            icon: Icons.tag,
            keyboardType: TextInputType.number,
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Name Field
          _buildTextField(
            controller: _nameController,
            label: 'Display Name',
            hint: 'Enter your name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            icon: Icons.person_outline,
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Password Toggle
          Row(
            children: [
              Switch(
                value: _hasPassword,
                onChanged: (value) {
                  setState(() {
                    _hasPassword = value;
                    if (!value) {
                      _passwordController.clear();
                    }
                  });
                },
              ),
              const SizedBox(width: 12),
              Text(
                'Meeting has password',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Password Field (conditionally shown)
          if (_hasPassword) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              label: 'Meeting Password',
              hint: 'Enter password',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              icon: Icons.lock_outline,
              colorScheme: colorScheme,
              isPassword: true,
              isPasswordVisible: _isPasswordVisible,
              onTogglePasswordVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ColorScheme colorScheme,
    String? Function(String?)? validator,
    String? errorMessage,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePasswordVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorMessage,
          prefixIcon: Icon(icon, color: colorScheme.primary),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onTogglePasswordVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  // Widget _buildMediaControls(
  //   BuildContext context,
  //   ColorScheme colorScheme,
  //   JoinMeetingState state,
  //   JoinMettingNotifire notifier,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Media Settings',
  //         style: TextStyle(
  //           color: colorScheme.onSurface,
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),

  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildMediaControlCard(
  //               context,
  //               colorScheme,
  //               icon: state.isCameraOn ? Icons.videocam : Icons.videocam_off,
  //               title: 'Camera',
  //               isEnabled: state.isCameraOn,
  //               onToggle: () {
  //                 notifier.toogleCamera(!state.isCameraOn);
  //               },
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: _buildMediaControlCard(
  //               context,
  //               colorScheme,
  //               icon: state.isMicOn ? Icons.mic : Icons.mic_off,
  //               title: 'Microphone',
  //               isEnabled: state.isMicOn,
  //               onToggle: () {
  //                 notifier.toggleMic(!state.isMicOn);
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMediaControlCard(
  //   BuildContext context,
  //   ColorScheme colorScheme, {
  //   required IconData icon,
  //   required String title,
  //   required bool isEnabled,
  //   required VoidCallback onToggle,
  // }) {
  //   return GestureDetector(
  //     onTap: onToggle,
  //     child: Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: isEnabled
  //             ? colorScheme.primary.withOpacity(0.1)
  //             : colorScheme.surfaceContainer,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: isEnabled
  //               ? colorScheme.primary.withOpacity(0.3)
  //               : colorScheme.outline.withOpacity(0.2),
  //           width: 1,
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Icon(
  //             icon,
  //             color: isEnabled
  //                 ? colorScheme.primary
  //                 : colorScheme.onSurfaceVariant,
  //             size: 32,
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               color: isEnabled
  //                   ? colorScheme.primary
  //                   : colorScheme.onSurfaceVariant,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             isEnabled ? 'ON' : 'OFF',
  //             style: TextStyle(
  //               color: isEnabled
  //                   ? colorScheme.primary
  //                   : colorScheme.onSurfaceVariant,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildJoinButton(
    BuildContext context,
    ColorScheme colorScheme,
    JoinMeetingState state,
    JoinMettingNotifire notifire,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            joinMettingMethod(
              ref,
              context,
              _nameController,
              _meetingIdController,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_call, size: 24),
            const SizedBox(width: 12),
            Text(
              'Join Meeting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tips for joining',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            colorScheme,
            'Get the meeting ID from the host',
            Icons.tag,
          ),
          _buildTipItem(
            colorScheme,
            'Check your camera and microphone settings',
            Icons.settings,
          ),
          _buildTipItem(
            colorScheme,
            'Ensure stable internet connection',
            Icons.wifi,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(ColorScheme colorScheme, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _joinMeeting(JoinMeetingState state, JoinMettingNotifire notifier) {
    Navigator.pushNamed(
      context,
      '/call',
      arguments: {
        'meetingId': _meetingIdController.text,
        'userName': _nameController.text,
        'password': _hasPassword ? _passwordController.text : null,
        'isCameraEnabled': state.isCameraOn,
        'isMicEnabled': state.isMicOn,
        'isHost': false,
      },
    );
  }

  // void _showErrorSnackbar(String message) {
  //   final colorScheme = Theme.of(context).colorScheme;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           Icon(Icons.error_outline, color: colorScheme.onError),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Text(
  //               message,
  //               style: TextStyle(color: colorScheme.onError),
  //             ),
  //           ),
  //         ],
  //       ),
  //       backgroundColor: colorScheme.error,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       margin: const EdgeInsets.all(16),
  //       behavior: SnackBarBehavior.floating,
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // }
}
