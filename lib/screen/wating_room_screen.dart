import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/user_profileData_save_controller.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';
import 'package:zoom_clone/provider/waiting_room_provider.dart';
import 'package:zoom_clone/screen/metting_room_screen.dart';
import 'package:zoom_clone/widgets/error_status_components.dart';
import 'package:zoom_clone/widgets/media_controller.dart';
import 'package:zoom_clone/widgets/rejected_indicator.dart';

class WaitingRoomScreen extends ConsumerStatefulWidget {
  final String meetingId;
  final String userName;
  final String userId;

  const WaitingRoomScreen({
    super.key,
    required this.meetingId,
    required this.userName,
    required this.userId,
  });

  @override
  ConsumerState<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends ConsumerState<WaitingRoomScreen>
    with TickerProviderStateMixin {
  late UserProfiledataSaveController userProfileInstance =
      Get.find<UserProfiledataSaveController>();

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the waiting indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Fade animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final state = ref.watch(joinMettingProvide);
    final notifier = ref.read(joinMettingProvide.notifier);

    final statusAsync = ref.watch(
      approwalStatusProvider((widget.meetingId, widget.userId)),
    );

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
                    children: [
                      const SizedBox(height: 20),

                      // Animated Waiting Indicator
                      // _buildWaitingIndicator(context, colorScheme),
                      // const SizedBox(height: 40),
                      statusAsync.when(
                        data: (data) {
                          final status = data?['status'];
                          if (status == 'approved') {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Get.off(
                                () => MettingRoomScreen(
                                  userName: data?['name'],
                                  roomId: widget.meetingId,
                                  isHost: false,
                                ),
                              );
                            });
                            return const SizedBox.shrink();
                          } else if (status == 'rejected') {
                            return Column(
                              children: [
                                buildRejectedIndicator(context, colorScheme),
                                const SizedBox(height: 40),
                                buildRejectedMessage(context, colorScheme),
                                const SizedBox(height: 40),
                                buildRejectedActionCard(
                                  context,
                                  colorScheme,
                                  onTryAgain: () {
                                    /* retry logic */
                                  },
                                  onGoBack: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                // Animated Waiting Indicator
                                _buildWaitingIndicator(context, colorScheme),
                                const SizedBox(height: 40),
                                _buildStatusMessage(context, colorScheme),
                              ],
                            );
                          }
                        },
                        loading: () => Column(
                          children: [
                            // Animated Waiting Indicator
                            // const SizedBox(height: 20),
                            _buildWaitingIndicator(context, colorScheme),
                            const SizedBox(height: 40),
                            _buildStatusMessage(context, colorScheme),
                          ],
                        ),
                        error: (err, stack) => Column(
                          children: [
                            buildErrorIndicator(context, colorScheme),
                            const SizedBox(height: 40),
                            buildErrorMessage(
                              context,
                              colorScheme,
                              errorMessage: err.toString(),
                            ),
                            const SizedBox(height: 40),
                            buildErrorActionCard(
                              context,
                              colorScheme,
                              onRetry: () {
                                /* retry */
                              },
                              onGoBack: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      // Status Message
                      // _buildStatusMessage(context, colorScheme),
                      const SizedBox(height: 40),

                      // Meeting Info Card
                      _buildMeetingInfoCard(context, colorScheme),

                      const SizedBox(height: 32),

                      // Media Preview & Controls
                      buildMediaControls(context, colorScheme, state, notifier),
                      // _buildMediaPreview(context, colorScheme),
                      const SizedBox(height: 32),

                      // Tips Section
                      _buildTipsSection(context, colorScheme),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              _buildBottomActions(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.hourglass_empty,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waiting Room',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Meeting ID: ${widget.meetingId}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
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
              child: userProfileInstance.modalUser != null
                  ? Image.network(
                      userProfileInstance.modalUser!.profileImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        );
                      },
                    )
                  : Icon(
                      Icons.person,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingIndicator(BuildContext context, ColorScheme colorScheme) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.1).animate(_pulseAnimation),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withOpacity(0.1),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.2),
            ),
            child: Icon(
              Icons.access_time,
              color: colorScheme.primary,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusMessage(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          'Waiting for Host Approval',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'The host will admit you shortly.\nPlease wait patiently.',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = index * 0.2;
                final value = (_pulseController.value + delay) % 1.0;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withOpacity(value),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingInfoCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                'Meeting Information',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            colorScheme,
            icon: Icons.person_outline,
            label: 'Your Name',
            value: widget.userName,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            colorScheme,
            icon: Icons.tag,
            label: 'Meeting ID',
            value: widget.meetingId,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            colorScheme,
            icon: Icons.schedule,
            label: 'Status',
            value: 'Waiting for approval',
            valueColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildMediaPreview(BuildContext context, ColorScheme colorScheme) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Your Media Settings',
  //         style: TextStyle(
  //           color: colorScheme.onSurface,
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Container(
  //         height: 200,
  //         decoration: BoxDecoration(
  //           color: colorScheme.surfaceContainer,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(
  //             color: colorScheme.outline.withOpacity(0.2),
  //             width: 1,
  //           ),
  //         ),
  //         child: Stack(
  //           children: [
  //             // Video preview placeholder
  //             Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     _localCameraOn ? Icons.videocam : Icons.videocam_off,
  //                     color: colorScheme.onSurfaceVariant,
  //                     size: 48,
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Text(
  //                     _localCameraOn
  //                         ? 'Camera is ${_localCameraOn ? "on" : "off"}'
  //                         : 'Camera is off',
  //                     style: TextStyle(
  //                       color: colorScheme.onSurfaceVariant,
  //                       fontSize: 16,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Controls overlay
  //             Positioned(
  //               bottom: 16,
  //               left: 16,
  //               right: 16,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   _buildMediaButton(
  //                     colorScheme,
  //                     icon: _localCameraOn
  //                         ? Icons.videocam
  //                         : Icons.videocam_off,
  //                     isEnabled: _localCameraOn,
  //                     onTap: () {
  //                       setState(() {
  //                         _localCameraOn = !_localCameraOn;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 16),
  //                   _buildMediaButton(
  //                     colorScheme,
  //                     icon: _localMicOn ? Icons.mic : Icons.mic_off,
  //                     isEnabled: _localMicOn,
  //                     onTap: () {
  //                       setState(() {
  //                         _localMicOn = !_localMicOn;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMediaButton(
  //   ColorScheme colorScheme, {
  //   required IconData icon,
  //   required bool isEnabled,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: 56,
  //       height: 56,
  //       decoration: BoxDecoration(
  //         color: isEnabled
  //             ? colorScheme.primary
  //             : colorScheme.error.withOpacity(0.9),
  //         shape: BoxShape.circle,
  //         boxShadow: [
  //           BoxShadow(
  //             color: (isEnabled ? colorScheme.primary : colorScheme.error)
  //                 .withOpacity(0.3),
  //             blurRadius: 8,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Icon(icon, color: Colors.white, size: 24),
  //     ),
  //   );
  // }

  Widget _buildTipsSection(BuildContext context, ColorScheme colorScheme) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'While You Wait',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            colorScheme,
            'Check your camera and microphone',
            Icons.check_circle_outline,
          ),
          _buildTipItem(
            colorScheme,
            'Ensure you have a stable connection',
            Icons.check_circle_outline,
          ),
          _buildTipItem(
            colorScheme,
            'Find a quiet space for the meeting',
            Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(ColorScheme colorScheme, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 16),
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

  Widget _buildBottomActions(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () => _showLeaveDialog(context, colorScheme),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.exit_to_app, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Leave Waiting Room',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Your privacy is protected',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLeaveDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.exit_to_app, color: colorScheme.error),
            const SizedBox(width: 12),
            Text(
              'Leave Waiting Room?',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to leave? You will need to rejoin to enter the meeting.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Leave'),
          ),
        ],
      ),
    );
  }
}
