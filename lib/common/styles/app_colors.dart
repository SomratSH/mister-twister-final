import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryPink = Color(0xFFEA3E8E);
  static const Color primaryPinkDark = Color(0xFFB3147B);
  static const Color primaryBlue = Color(0xFF4A5FD9);
  static const Color primaryBlueDark = Color(0xFF3D4BB8);

  // Background Colors
  static const Color bgPink = Color(0xFFFDEFF2);
  static const Color bgBlue = Color(0xFFF5F6FF);
  static const Color bgWhite = Colors.white;

  // Text Colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGray = Color(0xFF6B7280);
  static const Color textGrayLight = Color(0xFFA0AEC0);

  // Gradients
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [primaryPink, primaryPinkDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors - Pink
  static Color shadowPink = primaryPink.withAlpha(25);
  static Color shadowPinkLight = primaryPink.withAlpha(20);
  static Color shadowPinkDark = primaryPink.withAlpha(75);

  // Shadow Colors - Blue
  static Color shadowBlue = primaryBlue.withAlpha(25);
  static Color shadowBlueLight = primaryBlue.withAlpha(20);
  static Color shadowBlueDark = primaryBlue.withAlpha(75);

  // Shadow Colors - General
  static Color shadowBlack = Colors.black.withAlpha(15);
  static Color shadowGray = Colors.grey.withAlpha(38);
  static Color shadowBorder = primaryPink.withAlpha(38);
}
