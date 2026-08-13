import 'package:flutter/material.dart';

class AppColor {
  // Private constructor to prevent instantiation
  AppColor._();

  // Primary Colors
  static const Color primary = Color(0xFF00B8D0);
  static const Color primaryDark = Color(0xFF00B8DB);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00D492);
  static const Color secondaryLight = Color(0xFF00D5BE);
  
  // Accent Colors
  static const Color accentBlue = Color(0xFF155DFC);
  static const Color accentOrange = Color(0xFFF54900);
  static const Color accentGreen = Color(0xFF00A63E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color textTertiary = Color(0xFF6A7282);
  static const Color textLabel = Color(0xFF364153);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundCard = Color(0xFFF3F4F6);
  static const Color backgroundLightBlue = Color(0xFFE5F7FB);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DC);
  static const Color borderGray = Color(0xFF9CA3AF);
  
  // Status Colors
  static const Color error = Color(0xFFE7000B);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color success = Color(0xFF00D492);
  static const Color info = Color(0xFF00B8DB);
  
  // Opacity Variants
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color primaryDarkWithOpacity(double opacity) => primaryDark.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) => secondary.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) => Colors.white.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => Colors.black.withOpacity(opacity);
  static Color textPrimaryWithOpacity(double opacity) => textPrimary.withOpacity(opacity);
  static Color textSecondaryWithOpacity(double opacity) => textSecondary.withOpacity(opacity);
  
  // Gradient Colors
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00D492),
      Color(0xFF00D5BE),
      Color(0xFF00B8DB),
    ],
  );
  
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF4A5565),
      Color(0xFF00B8DB),
    ],
  );
}
