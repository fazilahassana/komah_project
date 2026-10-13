import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles KOMAH — sesuai CSS Figma, font Poppins.
class AppTextStyles {
  AppTextStyles._();

  // ── Landing Page ──

  /// Logo brand text: Poppins 700, 24px, line-height 36px, #57345B
  static TextStyle logoBrand = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 36 / 24,
    color: AppColors.brandPurple,
  );

  /// Headline: Poppins 800, 29px, line-height 44px, #000000
  static TextStyle headline = GoogleFonts.poppins(
    fontWeight: FontWeight.w800,
    fontSize: 29,
    height: 44 / 29,
    color: AppColors.black,
  );

  /// Body description (landing): Poppins 500, 16px, line-height 24px, #000000
  static TextStyle bodyDescription = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.black,
  );

  /// Button text (Lanjutkan): Poppins 600, 20px, line-height 30px, #FFFFFF
  static TextStyle buttonTextLanding = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 30 / 20,
    color: AppColors.white,
  );

  /// Button text (Masuk - login): Poppins 600, 22px, line-height 33px, #FFFFFF
  static TextStyle buttonTextLogin = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 33 / 22,
    color: AppColors.white,
  );

  /// Link text: Poppins 500, 16px, line-height 24px, #000000
  static TextStyle linkText = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.black,
  );

  // ── Login Page ──

  /// Page title: Poppins 700, 24px, line-height 36px, #000000
  static TextStyle pageTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 36 / 24,
    color: AppColors.black,
  );

  /// Page subtitle: Poppins 400, 16px, line-height 24px, #000000
  static TextStyle pageSubtitle = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.black,
  );

  /// Input label: Poppins 500, 16px, line-height 24px, #000000
  static TextStyle inputLabel = GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.black,
  );

  /// Forgot password link: Poppins 600, 14px, line-height 21px, #F3766B
  static TextStyle forgotPassword = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 21 / 14,
    color: AppColors.accent,
  );

    // ── KOMah: Alamat Favorit (Plus Jakarta Sans) ──
  static TextStyle kmTitle = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w800,
    fontSize: 26,
    color: AppColors.kmNavy,
  );

  static TextStyle kmBody = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
    color: AppColors.kmGrey,
  );

  static TextStyle kmButton = GoogleFonts.plusJakartaSans(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.white,
  );

  /// Helper gaya teks serbaya untuk layar Alamat Favorit.
  static TextStyle km({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.kmNavy,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );
}
