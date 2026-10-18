import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/komah_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository.instance;

  bool _obscurePassword = true;

  // [STATE] initial -> loading -> success / error
  AuthStatus _status = AuthStatus.initial;
  bool get _isLoading => _status == AuthStatus.loading;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // [FEEDBACK] SnackBar sukses/error
  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // [INPUT/EVENT] Tombol "Masuk" ditekan
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    // [VALIDATION] Jika tidak valid, error tampil di bawah field
    if (!_formKey.currentState!.validate()) return;

    setState(() => _status = AuthStatus.loading); // [STATE] loading

    try {
      final user = await _authRepository.login(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;

      setState(() => _status = AuthStatus.success); // [STATE] berhasil
      _showMessage('Selamat datang, ${user.name}!', isError: false);

      // [NAVIGATION] Ke Beranda, hapus riwayat agar back tidak ke login
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _status = AuthStatus.error); // [STATE] gagal
      _showMessage(e.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = AuthStatus.error);
      _showMessage('Terjadi kesalahan. Coba lagi nanti.', isError: true);
    }
  }

  void _handleForgotPassword() {
    // Di luar scope tugas: hanya tampilan
    _showMessage('Fitur lupa kata sandi belum tersedia', isError: false);
  }

  // [NAVIGATION] Ke registrasi, menerima hasil (email/HP) jika berhasil daftar
  Future<void> _handleRegister() async {
    final registered = await Navigator.pushNamed<String>(
      context,
      AppRoutes.register,
    );
    if (!mounted) return;

    if (registered != null) {
      setState(() {
        _identifierController.text = registered; // isi otomatis
        _passwordController.clear();
        _status = AuthStatus.initial;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back Button ──
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 12),
                  child: IconButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                          },
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

                const SizedBox(height: 12),

                // ── Logo ──
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: KomahLogo(),
                ),

                const SizedBox(height: 12),

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

                // ── Label & Input Email/HP ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Nomor HP atau Email',
                    style: AppTextStyles.inputLabel,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: CustomTextField(
                    controller: _identifierController,
                    enabled: !_isLoading,
                    prefixIcon: Icons.email_outlined,
                    backgroundColor: AppColors.inputBackground,
                    borderColor: AppColors.inputBorder,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.identifier,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Label & Input Password ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Text('Kata sandi', style: AppTextStyles.inputLabel),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: CustomTextField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    backgroundColor: AppColors.passwordBackground,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
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
                      onTap: _isLoading ? null : _handleForgotPassword,
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
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                // ── Link Registrasi ──
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _handleRegister,
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