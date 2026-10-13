import 'package:flutter/material.dart';

/// Design token warna KOMAH — sesuai CSS Figma.
class AppColors {
  AppColors._();

  // ── KOMah: Alamat Favorit ──
  static const Color kmCoral = Color(0xFFFF6B35);
  static const Color kmOrange = Color(0xFFFF9F5A);
  static const Color kmNavy = Color(0xFF2A2A6B);
  static const Color kmGrey = Color(0xFF8A8FA3);
  static const Color kmLavender = Color(0xFFE9E6F8);
  static const Color kmLavenderText = Color(0xFF5B4FC4);
  static const Color kmCream = Color(0xFFFFF5EE);
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
