import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/komah_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authRepository = AuthRepository.instance;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // [STATE] initial -> loading -> success / error
  AuthStatus _status = AuthStatus.initial;
  bool get _isLoading => _status == AuthStatus.loading;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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

  // [INPUT/EVENT] Tombol "Daftar" ditekan
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    // [VALIDATION] Semua field + checkbox diperiksa
    if (!_formKey.currentState!.validate()) return;

    setState(() => _status = AuthStatus.loading); // [STATE] loading

    try {
      final user = await _authRepository.register(
        name: _nameController.text,
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;

      setState(() => _status = AuthStatus.success); // [STATE] berhasil
      _showMessage('Registrasi berhasil! Silakan masuk.', isError: false);

      // [NAVIGATION/RESULT] Kembali ke Login membawa email/HP
      Navigator.pop<String>(context, user.identifier);
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

  // ── Helper tampilan ──
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontalPadding,
          16,
          AppSpacing.screenHorizontalPadding,
          8,
        ),
        child: Text(text, style: AppTextStyles.inputLabel),
      );

  Widget _field(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontalPadding,
        ),
        child: child,
      );

  Widget _visibilityToggle(bool obscure, VoidCallback onTap) => IconButton(
        onPressed: onTap,
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.black.withValues(alpha: 0.5),
          size: 22,
        ),
      );

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
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                _field(const KomahLogo()),
                const SizedBox(height: 12),

                _field(Text('Registrasi Akun', style: AppTextStyles.pageTitle)),
                const SizedBox(height: 4),
                _field(Text(
                  'Masukkan data untuk melakukan registrasi',
                  style: AppTextStyles.pageSubtitle,
                )),

                // ── Nama Lengkap ──
                _label('Nama Lengkap'),
                _field(CustomTextField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  prefixIcon: Icons.person_outline,
                  borderColor: AppColors.inputBorder,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validators.name,
                )),

                // ── Nomor HP atau Email ──
                _label('Nomor HP atau Email'),
                _field(CustomTextField(
                  controller: _identifierController,
                  enabled: !_isLoading,
                  prefixIcon: Icons.email_outlined,
                  borderColor: AppColors.inputBorder,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.identifier,
                )),

                // ── Kata Sandi ──
                _label('Kata Sandi'),
                _field(CustomTextField(
                  controller: _passwordController,
                  enabled: !_isLoading,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  borderColor: AppColors.inputBorder,
                  textInputAction: TextInputAction.next,
                  suffixIcon: _visibilityToggle(
                    _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: Validators.password,
                )),

                // ── Verifikasi Kata Sandi ──
                _label('Verifikasi Kata Sandi'),
                _field(CustomTextField(
                  controller: _confirmController,
                  enabled: !_isLoading,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  borderColor: AppColors.inputBorder,
                  textInputAction: TextInputAction.done,
                  suffixIcon: _visibilityToggle(
                    _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) => Validators.confirmPassword(
                    v,
                    _passwordController.text,
                  ),
                )),

                const SizedBox(height: 12),

                // ── Checkbox persetujuan ──
                _field(
                  FormField<bool>(
                    initialValue: false,
                    validator: (v) => v == true
                        ? null
                        : 'Kamu harus menyetujui Ketentuan Layanan & Privasi.',
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: state.value ?? false,
                              activeColor: AppColors.accent,
                              onChanged: _isLoading
                                  ? null
                                  : (v) => state.didChange(v),
                            ),
                            Expanded(
                              child: Text(
                                'Saya menyetujui Ketentuan Layanan & Privasi',
                                style: AppTextStyles.linkText.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Tombol Daftar ──
                _field(GradientButton(
                  text: 'Daftar',
                  textStyle: AppTextStyles.buttonTextLogin,
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                )),

                const SizedBox(height: 24),

                // ── Link Masuk ──
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.linkText,
                        children: [
                          const TextSpan(text: 'Sudah punya akun? '),
                          TextSpan(
                            text: 'Masuk sekarang',
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