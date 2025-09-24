// theme_manager.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static bool isDarkMode = true;

  static void toggleTheme() {
    isDarkMode = !isDarkMode;
  }

  // Colors
  static Color get primaryColor => isDarkMode ? Colors.purple[800]! : Colors.purple;
  static Color get backgroundColor => isDarkMode ? Colors.black : Colors.grey[50]!;
  static Color get surfaceColor => isDarkMode ? Colors.grey[850]! : Colors.white;
  static Color get textColor => isDarkMode ? Colors.white : Colors.grey[900]!;
  static Color get secondaryTextColor => isDarkMode ? Colors.purple[200]! : Colors.purple[700]!;
  static Color get accentColor => isDarkMode ? Colors.purple[300]! : Colors.purple;
  static Color get cardColor => isDarkMode ? Colors.grey[900]! : Colors.grey[100]!;
  static Color get buttonColor => isDarkMode ? Colors.purple[800]! : Colors.purple;
  static Color get secondaryButtonColor => isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  static Color get borderColor => isDarkMode ? Colors.purple[700]! : Colors.purple[300]!;

  // Gradients
  static Gradient get primaryGradient => isDarkMode 
      ? LinearGradient(colors: [Colors.purple[800]!, Colors.black])
      : LinearGradient(colors: [Colors.purple, Colors.purple[100]!]);

  static Gradient get totalGradient => isDarkMode
      ? LinearGradient(colors: [Colors.purple[900]!, Colors.black])
      : LinearGradient(colors: [Colors.purple[100]!, Colors.white]);

  // Text Styles
  static TextStyle titleTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 22 : 28,
    fontWeight: FontWeight.w700,
    color: textColor,
    height: 1.2,
  );

  static TextStyle subtitleTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 12 : 14,
    color: secondaryTextColor,
  );

  static TextStyle headerTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 10 : 12,
    fontWeight: FontWeight.w600,
    color: accentColor,
  );

  static TextStyle bodyTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 10 : 12,
    color: textColor,
  );

  static TextStyle amountTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 10 : 12,
    fontWeight: FontWeight.w600,
    color: accentColor,
  );

  static TextStyle totalLabelTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 14 : 16,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static TextStyle totalAmountTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 16 : 20,
    fontWeight: FontWeight.w700,
    color: accentColor,
  );

  static TextStyle buttonTextStyle(bool isMobile) => GoogleFonts.poppins(
    fontSize: isMobile ? 12 : 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle footerTextStyle() => GoogleFonts.poppins(
    fontSize: 10,
    color: isDarkMode ? Colors.grey[600] : Colors.grey[500],
    fontStyle: FontStyle.italic,
  );
}