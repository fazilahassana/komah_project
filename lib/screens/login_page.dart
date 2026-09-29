import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import '../routes/app_routes.dart';

/// Login Page KOMAH — Frame 2 Figma.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Isian benar -> pindah ke Home, Login dibuang dari stack
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur lupa kata sandi belum tersedia'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur registrasi belum tersedia'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back Button ──
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 12),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 34,
                    color: AppColors.black,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Judul ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Text(
                    'Masuk ke akun kamu',
                    style: AppTextStyles.pageTitle,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Deskripsi ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Text(
                    'Pakai nomor HP atau email yang kamu daftarkan',
                    style: AppTextStyles.pageSubtitle,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Label Email/HP ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Nomor HP atau Email',
                    style: AppTextStyles.inputLabel,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Input Email/HP ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: CustomTextField(
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    backgroundColor: AppColors.inputBackground,
                    borderColor: AppColors.inputBorder,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final required = Validators.requiredField(
                        value,
                        fieldName: 'Nomor HP atau email',
                      );
                      if (required != null) return required;

                      final text = value!.trim();
                      final isPhone = RegExp(r'^\+?\d{9,15}$').hasMatch(text);
                      if (isPhone) return null;
                      return Validators.email(text);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ── Label Password ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Text(
                    'Kata sandi',
                    style: AppTextStyles.inputLabel,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Input Password ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: CustomTextField(
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    backgroundColor: AppColors.passwordBackground,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.black.withValues(alpha: 0.5),
                        size: 22,
                      ),
                    ),
                    validator: Validators.password,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Lupa Kata Sandi ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _handleForgotPassword,
                      child: Text(
                        'Lupa kata sandi?',
                        style: AppTextStyles.forgotPassword,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Tombol Masuk ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontalPadding,
                  ),
                  child: GradientButton(
                    text: 'Masuk',
                    textStyle: AppTextStyles.buttonTextLogin,
                    onPressed: _handleLogin,
                  ),
                ),

                // ── Spacer ke bawah ──
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),

                // ── Link Registrasi ──
                Center(
                  child: GestureDetector(
                    onTap: _handleRegister,
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.linkText,
                        children: [
                          const TextSpan(text: 'Belum punya akun? '),
                          TextSpan(
                            text: 'Daftar sekarang',
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
      ),
    );
  }
}