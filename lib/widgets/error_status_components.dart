import 'package:flutter/material.dart';

/// Error Indicator - Shows when there's a connection or system error
Widget buildErrorIndicator(BuildContext context, ColorScheme colorScheme) {
  return Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: colorScheme.error.withValues(alpha: 0.1),
      border: Border.all(
        color: colorScheme.error.withValues(alpha: 0.3),
        width: 2,
      ),
    ),
    child: Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.error.withValues(alpha: 0.2),
        ),
        child: Icon(
          Icons.error_outline,
          color: colorScheme.error,
          size: 40,
        ),
      ),
    ),
  );
}

/// Error Message - Shows error details
Widget buildErrorMessage(
  BuildContext context,
  ColorScheme colorScheme, {
  String? errorMessage,
}) {
  return Column(
    children: [
      Text(
        'Connection Error',
        style: TextStyle(
          color: colorScheme.error,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        errorMessage ?? 'Unable to connect to the meeting.\nPlease try again.',
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
          color: colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Check your internet connection',
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

/// Error Action Card - Shows troubleshooting options
Widget buildErrorActionCard(
  BuildContext context,
  ColorScheme colorScheme, {
  required VoidCallback onRetry,
  required VoidCallback onGoBack,
  String? errorDetails,
}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.troubleshoot,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Troubleshooting Steps',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildErrorOption(
          colorScheme,
          icon: Icons.wifi_outlined,
          title: 'Check your connection',
          description: 'Ensure you have stable internet',
        ),
        const SizedBox(height: 12),
        _buildErrorOption(
          colorScheme,
          icon: Icons.refresh,
          title: 'Restart the app',
          description: 'Close and reopen the application',
        ),
        const SizedBox(height: 12),
        _buildErrorOption(
          colorScheme,
          icon: Icons.verified_outlined,
          title: 'Verify meeting ID',
          description: 'Confirm the meeting details are correct',
        ),
        if (errorDetails != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.code,
                  color: colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorDetails,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 18),
                label: Text('Retry'),
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

Widget _buildErrorOption(
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
          color: colorScheme.primary.withValues(alpha: 0.1),
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