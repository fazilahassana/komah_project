import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class KomahLogo extends StatelessWidget {
  const KomahLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_komah.png',
          width: 38,
          height: 38,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.brandPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'K',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            style: AppTextStyles.logoBrand,
            children: [
              const TextSpan(text: 'KOM'),
              TextSpan(
                text: 'ah',
                style: AppTextStyles.logoBrand.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}