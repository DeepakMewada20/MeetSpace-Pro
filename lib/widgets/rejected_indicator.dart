import 'package:flutter/material.dart';

Widget buildRejectedIndicator(BuildContext context, ColorScheme colorScheme) {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: colorScheme.error.withOpacity(0.1),
      border: Border.all(
        color: colorScheme.error.withOpacity(0.3),
        width: 2,
      ),
    ),
    child: Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.error.withOpacity(0.2),
        ),
        child: Icon(
          Icons.block,
          color: colorScheme.error,
          size: 40,
        ),
      ),
    ),
  );
}

/// Rejected Message - Shows rejection message from host
Widget buildRejectedMessage(BuildContext context, ColorScheme colorScheme) {
  return Column(
    children: [
      Text(
        'Request Denied',
        style: TextStyle(
          color: colorScheme.error,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        'Your request to join the meeting was\nrejected by the host.',
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              color: colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Contact the host to request access again',
              style: TextStyle(
                color: colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

/// Rejected Action Card - Shows options after rejection
Widget buildRejectedActionCard(
  BuildContext context,
  ColorScheme colorScheme, {
  required VoidCallback onTryAgain,
  required VoidCallback onGoBack,
}) {
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
            Icon(
              Icons.help_outline,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'What can you do?',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildRejectedOption(
          colorScheme,
          icon: Icons.refresh,
          title: 'Try joining again',
          description: 'Request to join the meeting once more',
        ),
        const SizedBox(height: 12),
        _buildRejectedOption(
          colorScheme,
          icon: Icons.message_outlined,
          title: 'Contact the host',
          description: 'Reach out to confirm meeting details',
        ),
        const SizedBox(height: 12),
        _buildRejectedOption(
          colorScheme,
          icon: Icons.schedule,
          title: 'Check meeting time',
          description: 'Verify the correct meeting schedule',
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGoBack,
                icon: Icon(Icons.arrow_back, size: 18),
                label: Text('Go Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onTryAgain,
                icon: Icon(Icons.refresh, size: 18),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildRejectedOption(
  ColorScheme colorScheme, {
  required IconData icon,
  required String title,
  required String description,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
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
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
