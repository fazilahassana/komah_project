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

  // ── KOMah Practical Challenge ──
  static const Color primary = Color(0xFFFF6433);       // oranye solid (ikon, stepper)
  static const Color textPrimary = Color(0xFF1E1B4B);   // judul & nilai (navy)
  static const Color textSecondary = Color(0xFF6B7280); // subjudul & label
  static const Color softPurple = Color(0xFFF1EFFC);    // kotak info & kartu nomor pesanan
  static const Color softOrange = Color(0xFFFFF1E8);    // latar ikon/ilustrasi
  static const Color cardBorder = Color(0xFFE8E6F3);    // border kartu & field
  static const Color error = Color(0xFFD93025);         // pesan validasi
  
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
