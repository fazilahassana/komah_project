import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Tombol gradient reusable — digunakan pada Landing Page dan Login Page.
/// Gradient dan shadow sesuai CSS Figma.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.textStyle,
    required this.onPressed,
  });

  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.buttonShadow,
            offset: Offset(0, 6),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          child: Center(
            child: Text(text, style: textStyle),
          ),
        ),
      ),
    );
  }
}
