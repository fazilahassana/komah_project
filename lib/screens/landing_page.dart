import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../widgets/gradient_button.dart';
import '../routes/app_routes.dart';

/// Landing Page KOMAH — Frame 1 Figma.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header / Logo ──
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 13),
                child: Row(
                  children: [
                    // Logo icon
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/logo_komah.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Brand text
                    Text('KOMah', style: AppTextStyles.logoBrand),
                  ],
                ),
              ),

              // ── Hero Image ──
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/hero_landing.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback jika gambar belum tersedia
                    return Container(
                      width: double.infinity,
                      height: 372,
                      color: const Color(0xFF2D1B33),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.two_wheeler,
                              size: 80,
                              color: AppColors.primaryGradientStart,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Hero Illustration\n(tambahkan asset dari Figma)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ── Headline ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontalPadding,
                ),
                child: Text(
                  'Anter - Jemput kuliah, harganya ramah di kantong anak kos.',
                  style: AppTextStyles.headline,
                ),
              ),

              const SizedBox(height: 8),

              // ── Deskripsi ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontalPadding,
                ),
                child: Text(
                  'Driver KOMah mahasiswa juga ngerti jadwal kelas, ngerti isi dompet kamu',
                  style: AppTextStyles.bodyDescription,
                ),
              ),

              const SizedBox(height: 28),

              // ── Tombol Lanjutkan ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontalPadding,
                ),
                child: GradientButton(
                  text: 'Lanjutkan',
                  textStyle: AppTextStyles.buttonTextLanding,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // ── Link Login ──
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.linkText,
                      children: [
                        const TextSpan(text: 'Sudah punya akun? '),
                        TextSpan(
                          text: 'Masuk',
                          style: AppTextStyles.linkText.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}