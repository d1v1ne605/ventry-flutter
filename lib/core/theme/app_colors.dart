import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  
  // Inputs
  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color inputBorder = Color(0xFFE2E8F0);
  
  // Texts
  static const Color textHeading = Color(0xFF171D1C);
  static const Color textBody = Color(0xFF64748B);
  static const Color textHint = Color(0xB364748B); // rgba(100, 116, 139, 0.7)
  
  // Primary
  static const Color primary = Color(0xFF00685F);
  static const Color primaryDark = Color(0xFF115E59);
  
  // Gradient for button
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF00685F),
      Color(0xFF115E59),
    ],
  );
  
  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0D0F1722), // rgba(15, 23, 42, 0.05)
    offset: Offset(0, 4),
    blurRadius: 12,
  );
  
  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x4000685F), // rgba(0, 104, 95, 0.25)
    offset: Offset(0, 2),
    blurRadius: 5,
  );
}
