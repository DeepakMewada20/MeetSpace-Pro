import 'package:flutter/material.dart';

// ============================================================================
// LIGHT THEME - Clean & Professional
// ============================================================================
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SF Pro Display',
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    
    // Primary Colors
    primary: Color(0xFF667eea),                    // Main brand blue
    onPrimary: Color(0xFFFFFFFF),                  // White text on primary
    primaryContainer: Color(0xFFe3f2fd),           // Light blue container
    onPrimaryContainer: Color(0xFF1565c0),         // Dark blue text on container
    
    // Secondary Colors  
    secondary: Color(0xFF764ba2),                  // Purple accent
    onSecondary: Color(0xFFFFFFFF),               // White text on secondary
    secondaryContainer: Color(0xFFf3e5f5),         // Light purple container
    onSecondaryContainer: Color(0xFF4a148c),       // Dark purple text
    
    // Tertiary Colors
    tertiary: Color(0xFF2a5298),                   // Medium blue
    onTertiary: Color(0xFFFFFFFF),                // White text on tertiary  
    tertiaryContainer: Color(0xFFe1f5fe),          // Light cyan container
    onTertiaryContainer: Color(0xFF01579b),        // Dark blue text
    
    // Error Colors
    error: Color(0xFFd32f2f),                     // Red-700
    onError: Color(0xFFFFFFFF),                   // White text on error
    errorContainer: Color(0xFFffebee),            // Light red container
    onErrorContainer: Color(0xFFb71c1c),          // Dark red text
    
    // Surface Colors
    surface: Color(0xFFfafafa),                   // Very light gray
    onSurface: Color(0xFF1a1a1a),                 // Dark text on surface
    surfaceContainer: Color(0xFFf5f5f5),          // Light gray container
    surfaceContainerHighest: Color(0xFFe0e0e0),   // Medium gray
    onSurfaceVariant: Color(0xFF424242),          // Dark gray for secondary text
    
    // Outline Colors
    outline: Color(0xFFbdbdbd),                   // Gray-400 for borders
    outlineVariant: Color(0xFFe0e0e0),            // Gray-300 for subtle borders
    
    // Surface Tint
    surfaceTint: Color(0xFF667eea),               // Primary blue tint
    
    // Inverse Colors
    inverseSurface: Color(0xFF1a1a1a),            // Dark for inverse
    onInverseSurface: Color(0xFFfafafa),          // Light text on inverse
    inversePrimary: Color(0xFF90caf9),            // Light blue for inverse
    
    // Shadow and Scrim
    shadow: Color(0xFF000000),                    // Black shadows
    scrim: Color(0xFF000000),                     // Black scrim
  ),
  
  // Scaffold Background
  scaffoldBackgroundColor: const Color(0xFFfafafa),
  
  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    foregroundColor: Color(0xFF1a1a1a),
    titleTextStyle: TextStyle(
      color: Color(0xFF1a1a1a),
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    color: const Color(0xFFFFFFFF),               // Pure white cards
    elevation: 2,
    shadowColor: const Color(0x10000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: Color(0xFFe0e0e0),                 // Light gray border
        width: 1,
      ),
    ),
  ),
  
  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: const Color(0xFFFFFFFF),
      elevation: 2,
      shadowColor: const Color(0x20667eea),
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
      foregroundColor: const Color(0xFF667eea),
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
      foregroundColor: const Color(0xFF667eea),
      side: const BorderSide(
        color: Color(0xFFbdbdbd),                 // Light gray border
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
    fillColor: const Color(0xFFf5f5f5),           // Light gray background
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFbdbdbd),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFbdbdbd),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF667eea),
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFd32f2f),                 // Error red
        width: 1,
      ),
    ),
    labelStyle: const TextStyle(
      color: Color(0xFF424242),                   // Dark gray for labels
      fontFamily: 'SF Pro Display',
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF757575),                   // Medium gray for hints
      fontFamily: 'SF Pro Display',
    ),
    prefixIconColor: Color(0xFF424242),
    suffixIconColor: Color(0xFF424242),
  ),
  
  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF667eea);           // Primary blue when on
      }
      return const Color(0xFF757575);             // Gray when off
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0x40667eea);           // 25% primary blue track
      }
      return const Color(0xFFe0e0e0);             // Light gray track when off
    }),
  ),
  
  // Dialog Theme
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFFFFFFFF),           // White background
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFF1a1a1a),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'SF Pro Display',
    ),
    contentTextStyle: TextStyle(
      color: Color(0xFF424242),                   // Medium gray for content
      fontSize: 16,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Bottom Sheet Theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFFFFFFF),           // White background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
  ),
  
  // SnackBar Theme
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF424242),           // Dark gray background
    contentTextStyle: TextStyle(
      color: Color(0xFFFFFFFF),
      fontFamily: 'SF Pro Display',
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  
  // List Tile Theme
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFF1a1a1a),
    iconColor: Color(0xFF424242),
    titleTextStyle: TextStyle(
      color: Color(0xFF1a1a1a),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'SF Pro Display',
    ),
    subtitleTextStyle: TextStyle(
      color: Color(0xFF757575),                   // Medium gray for subtitles
      fontSize: 14,
      fontFamily: 'SF Pro Display',
    ),
  ),
  
  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: Color(0xFFe0e0e0),                     // Light gray for dividers
    thickness: 1,
  ),
  
  // Icon Theme
  iconTheme: const IconThemeData(
    color: Color(0xFF424242),
    size: 24,
  ),
  
  // Primary Icon Theme
  primaryIconTheme: const IconThemeData(
    color: Color(0xFFFFFFFF),
    size: 24,
  ),
);

// ============================================================================
// LIGHT THEME GRADIENTS
// ============================================================================
class LightGradients {
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFfafafa),                          // Very light gray
      Color(0xFFf5f5f5),                          // Light gray  
      Color(0xFFeeeeee),                          // Slightly darker gray
    ],
  );
  
  static const LinearGradient profileAvatarGradient = LinearGradient(
    colors: [
      Color(0xFF667EEA),                          // Primary blue
      Color(0xFF764BA2),                          // Secondary purple
    ],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF667EEA),                          // Primary blue
      Color(0xFF764BA2),                          // Secondary purple
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),                          // Pure white
      Color(0xFFfafafa),                          // Very light gray
    ],
  );
}

// ============================================================================
// USAGE HELPER CLASS
// ============================================================================
class LightThemeHelper {
  static Color getTextColor(BuildContext context) {
    return const Color(0xFF1a1a1a);
  }
  
  static Color getSecondaryTextColor(BuildContext context) {
    return const Color(0xFF424242);
  }
  
  static Color getSurfaceColor(BuildContext context) {
    return const Color(0xFFf5f5f5);
  }
  
  static Color getCardColor(BuildContext context) {
    return const Color(0xFFFFFFFF);
  }
  
  static Color getBorderColor(BuildContext context) {
    return const Color(0xFFe0e0e0);
  }
  
  static Color getPrimaryColor(BuildContext context) {
    return const Color(0xFF667eea);
  }
  
  static LinearGradient getBackgroundGradient() {
    return LightGradients.backgroundGradient;
  }
}