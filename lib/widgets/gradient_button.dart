import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Tombol gradient reusable — digunakan pada Landing Page, Login Page, dan Alamat Favorit.
/// Gradient dan shadow sesuai CSS Figma.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    this.textStyle,
    required this.onPressed,
    this.icon,
    this.height = AppSpacing.buttonHeight,
    this.radius = AppSpacing.buttonRadius,
    this.enabled = true,
  });

  final String text;
  final TextStyle? textStyle; // opsional; default AppTextStyles.kmButton
  final VoidCallback onPressed;
  final IconData? icon; // tampil setelah teks
  final double height;
  final double radius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? AppTextStyles.kmButton;
    final label = Text(text, style: style);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(radius),
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
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(radius),
            child: Center(
              child: icon == null
                  ? label
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        label,
                        const SizedBox(width: 8),
                        Icon(icon, color: style.color ?? AppColors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}