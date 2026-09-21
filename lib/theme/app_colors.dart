import 'package:flutter/material.dart';

/// Design token warna KOMAH — sesuai CSS Figma.
class AppColors {
  AppColors._();

  // Base
  static const Color background = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Brand
  static const Color brandPurple = Color(0xFF57345B);

  // Primary gradient (tombol Lanjutkan & Masuk)
  static const Color primaryGradientStart = Color(0xFFFF7659);
  static const Color primaryGradientMiddle = Color(0xFFFF8E54);
  static const Color primaryGradientEnd = Color(0xFFFEB04E);

  // Button shadow
  static const Color buttonShadow = Color(0xFFFF7F57);

  // Accent (link "Lupa kata sandi?")
  static const Color accent = Color(0xFFF3766B);

  // Input fields
  static const Color inputBorder = Color(0xFFDB7767);
  static const Color inputBackground = Color(0xFFFFFCF5);
  static const Color passwordBackground = Color(0xFFF4EADD);

  // Gradient preset
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientMiddle, primaryGradientEnd],
    stops: [0.0, 0.4713, 0.9426],
  );
}
