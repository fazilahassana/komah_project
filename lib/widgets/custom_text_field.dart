import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Custom text field reusable — digunakan pada Login Page dan Alamat Favorit.
/// Mendukung konfigurasi background, border, icon, obscureText, multiline,
/// batas karakter, dan error eksternal ([errorText]).
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.prefixIconColor = AppColors.black,
    this.obscureText = false,
    this.suffixIcon,
    this.backgroundColor = AppColors.inputBackground,
    this.borderColor,
    this.keyboardType,
    this.validator,
    this.errorText,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Color prefixIconColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final Color backgroundColor;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? errorText; // error dari luar (tanpa Form)
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      forceErrorText: errorText,
      minLines: minLines,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black.withValues(alpha: 0.4),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: prefixIconColor, size: 24)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!, width: AppSpacing.inputBorderWidth)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!, width: AppSpacing.inputBorderWidth)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!, width: AppSpacing.inputBorderWidth)
              : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}