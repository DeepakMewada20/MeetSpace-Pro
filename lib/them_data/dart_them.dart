import 'package:flutter/material.dart';

// ============================================================================
// DARK THEME - Modern & Professional
// ============================================================================
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SF Pro Display',
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    
    // Primary Colors
    primary: Color(0xFF90CAF9),                    // Light blue for dark theme
    onPrimary: Color(0xFF1A1A1A),                  // Dark text on primary
    primaryContainer: Color(0xFF1565C0),           // Dark blue container
    onPrimaryContainer: Color(0xFFE3F2FD),         // Light blue text on container
    
    // Secondary Colors  
    secondary: Color(0xFFCE93D8),                  // Light purple accent
    onSecondary: Color(0xFF1A1A1A),               // Dark text on secondary
    secondaryContainer: Color(0xFF4A148C),         // Dark purple container
    onSecondaryContainer: Color(0xFFF3E5F5),       // Light purple text
    
    // Tertiary Colors
    tertiary: Color(0xFF81C784),                   // Light green
    onTertiary: Color(0xFF1A1A1A),                // Dark text on tertiary  
    tertiaryContainer: Color(0xFF2E7D32),          // Dark green container
    onTertiaryContainer: Color(0xFFC8E6C9),        // Light green text
    
    // Error Colors
    error: Color(0xFFEF5350),                     // Light red for dark theme
    onError: Color(0xFF1A1A1A),                   // Dark text on error
    errorContainer: Color(0xFFB71C1C),            // Dark red container
    onErrorContainer: Color(0xFFFFEBEE),          // Light red text
    
    // Surface Colors
    surface: Color(0xFF121212),                   // Very dark gray
    onSurface: Color(0xFFE0E0E0),                 // Light text on surface
    surfaceContainer: Color(0xFF1E1E1E),          // Dark gray container
    surfaceContainerHighest: Color(0xFF2C2C2C),   // Medium dark gray
    onSurfaceVariant: Color(0xFFBDBDBD),          // Light gray for secondary text
    
    // Outline Colors
    outline: Color(0xFF424242),                   // Dark gray for borders
    outlineVariant: Color(0xFF303030),            // Darker gray for subtle borders
    
    // Surface Tint
    surfaceTint: Color(0xFF90CAF9),               // Light blue tint
    
    // Inverse Colors
    inverseSurface: Color(0xFFFAFAFA),            // Light for inverse
    onInverseSurface: Color(0xFF1A1A1A),          // Dark text on inverse
    inversePrimary: Color(0xFF667EEA),            // Primary blue for inverse
    
    // Shadow and Scrim
    shadow: Color(0xFF000000),                    // Black shadows
    scrim: Color(0xFF000000),                     // Black scrim
  ),
  
  // Scaffold Background
  scaffoldBackgroundColor: const Color(0xFF0F0F0F),
  
  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Color(0xFFE0E0E0),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),               // Dark card background
    elevation: 4,
    shadowColor: const Color(0x40000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: Color(0xFF303030),                 // Dark border
        width: 1,
      ),
    ),
  ),
  
  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF90CAF9),
      foregroundColor: const Color(0xFF1A1A1A),
      elevation: 3,
      shadowColor: const Color(0x4090CAF9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'SF Pro Display',
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF90CAF9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'SF Pro Display',
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF90CAF9),
      side: const BorderSide(
        color: Color(0xFF424242),                 // Dark border
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  
  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),           // Dark gray background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF424242),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF424242),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF90CAF9),
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFEF5350),                 // Light red for dark theme
        width: 1,
      ),
    ),
    labelStyle: const TextStyle(
      color: Color(0xFFBDBDBD),                   // Light gray for labels
      fontFamily: 'SF Pro Display',
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF757575),                   // Medium gray for hints
      fontFamily: 'SF Pro Display',
    ),
    prefixIconColor: Color(0xFFBDBDBD),
    suffixIconColor: Color(0xFFBDBDBD),
  ),
  
  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF90CAF9);           // Light blue when on
      }
      return const Color(0xFF757575);             // Gray when off
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0x4090CAF9);           // 25% light blue track
      }
      return const Color(0xFF424242);             // Dark gray track when off
    }),
  ),
  
  // Dialog Theme
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1E1E1E),           // Dark background
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'SF Pro Display',
    ),
    contentTextStyle: TextStyle(
      color: Color(0xFFBDBDBD),                   // Light gray for content
      fontSize: 16,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Bottom Sheet Theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1E1E1E),           // Dark background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
  ),
  
  // SnackBar Theme
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF2C2C2C),           // Dark gray background
    contentTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontFamily: 'SF Pro Display',
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  
  // List Tile Theme
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFFE0E0E0),
    iconColor: Color(0xFFBDBDBD),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'SF Pro Display',
    ),
    subtitleTextStyle: TextStyle(
      color: Color(0xFF9E9E9E),                   // Medium gray for subtitles
      fontSize: 14,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: Color(0xFF303030),                     // Dark gray for dividers
    thickness: 1,
  ),
  
  // Icon Theme
  iconTheme: const IconThemeData(
    color: Color(0xFFBDBDBD),
    size: 24,
  ),
  
  // Primary Icon Theme
  primaryIconTheme: const IconThemeData(
    color: Color(0xFF1A1A1A),
    size: 24,
  ),
);

// ============================================================================
// DARK THEME GRADIENTS
// ============================================================================
class DarkGradients {
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F0F0F),                          // Very dark gray
      Color(0xFF121212),                          // Dark gray  
      Color(0xFF1A1A1A),                          // Slightly lighter dark gray
    ],
  );
  
  static const LinearGradient profileAvatarGradient = LinearGradient(
    colors: [
      Color(0xFF90CAF9),                          // Light blue
      Color(0xFFCE93D8),                          // Light purple
    ],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF90CAF9),                          // Light blue
      Color(0xFFCE93D8),                          // Light purple
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1E1E),                          // Dark card background
      Color(0xFF252525),                          // Slightly lighter
    ],
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFF1A1A1A),                          // Dark
      Color(0xFF2C2C2C),                          // Lighter dark
      Color(0xFF1A1A1A),                          // Dark
    ],
  );
}

// ============================================================================
// USAGE HELPER CLASS
// ============================================================================
class DarkThemeHelper {
  static Color getTextColor(BuildContext context) {
    return const Color(0xFFE0E0E0);
  }
  
  static Color getSecondaryTextColor(BuildContext context) {
    return const Color(0xFFBDBDBD);
  }
  
  static Color getSurfaceColor(BuildContext context) {
    return const Color(0xFF2C2C2C);
  }
  
  static Color getCardColor(BuildContext context) {
    return const Color(0xFF1E1E1E);
  }
  
  static Color getBorderColor(BuildContext context) {
    return const Color(0xFF303030);
  }
  
  static Color getPrimaryColor(BuildContext context) {
    return const Color(0xFF90CAF9);
  }
  
  static LinearGradient getBackgroundGradient() {
    return DarkGradients.backgroundGradient;
  }
  
  static LinearGradient getShimmerGradient() {
    return DarkGradients.shimmerGradient;
  }
}

// ============================================================================
// THEME SWITCHER HELPER
// ============================================================================
class ThemeHelper {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  
  static Color adaptiveColor(BuildContext context, Color lightColor, Color darkColor) {
    return isDarkMode(context) ? darkColor : lightColor;
  }
  
  static LinearGradient adaptiveGradient(BuildContext context, 
      LinearGradient lightGradient, LinearGradient darkGradient) {
    return isDarkMode(context) ? darkGradient : lightGradient;
  }
  
  // Common adaptive colors
  static Color getAdaptiveTextColor(BuildContext context) {
    return isDarkMode(context) 
        ? const Color(0xFFE0E0E0) 
        : const Color(0xFF1A1A1A);
  }
  
  static Color getAdaptiveSecondaryTextColor(BuildContext context) {
    return isDarkMode(context) 
        ? const Color(0xFFBDBDBD) 
        : const Color(0xFF424242);
  }
  
  static Color getAdaptiveCardColor(BuildContext context) {
    return isDarkMode(context) 
        ? const Color(0xFF1E1E1E) 
        : const Color(0xFFFFFFFF);
  }
  
  static Color getAdaptiveSurfaceColor(BuildContext context) {
    return isDarkMode(context) 
        ? const Color(0xFF2C2C2C) 
        : const Color(0xFFF5F5F5);
  }
  
  static Color getAdaptiveBorderColor(BuildContext context) {
    return isDarkMode(context) 
        ? const Color(0xFF303030) 
        : const Color(0xFFE0E0E0);
  }
}