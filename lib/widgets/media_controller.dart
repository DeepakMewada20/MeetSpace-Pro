 import 'package:flutter/material.dart';
import 'package:zoom_clone/modal/join_metting_modal.dart';
import 'package:zoom_clone/provider/join_metting_provide.dart';

Widget buildMediaControls(
    BuildContext context,
    ColorScheme colorScheme,
    JoinMeetingState state,
    JoinMettingNotifire notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media Settings',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildMediaControlCard(
                context,
                colorScheme,
                icon: state.isCameraOn ? Icons.videocam : Icons.videocam_off,
                title: 'Camera',
                isEnabled: state.isCameraOn,
                onToggle: () {
                  notifier.toogleCamera(!state.isCameraOn);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMediaControlCard(
                context,
                colorScheme,
                icon: state.isMicOn ? Icons.mic : Icons.mic_off,
                title: 'Microphone',
                isEnabled: state.isMicOn,
                onToggle: () {
                  notifier.toggleMic(!state.isMicOn);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
    Widget _buildMediaControlCard(
    BuildContext context,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required bool isEnabled,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isEnabled
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isEnabled
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isEnabled ? 'ON' : 'OFF',
              style: TextStyle(
                color: isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }