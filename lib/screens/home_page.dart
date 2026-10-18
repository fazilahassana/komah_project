import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthRepository.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, size: 72, color: AppColors.accent),
              const SizedBox(height: 16),
              Text('Login Berhasil!', style: AppTextStyles.pageTitle),
              const SizedBox(height: 8),
              Text(
                'Halo, ${user?.name ?? 'Mahasiswa'}',
                style: AppTextStyles.pageSubtitle,
              ),
              Text(
                user?.identifier ?? '-',
                style: AppTextStyles.pageSubtitle.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 40),
              GradientButton(
                text: 'Keluar',
                textStyle: AppTextStyles.buttonTextLanding,
                onPressed: () {
                  AuthRepository.instance.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}