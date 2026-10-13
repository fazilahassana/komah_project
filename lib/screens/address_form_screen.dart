import 'package:flutter/material.dart';
import 'package:komah_project/data/address_repository.dart';
import 'package:komah_project/routes/app_routes.dart';
import 'package:komah_project/theme/app_colors.dart';
import 'package:komah_project/theme/app_spacing.dart';
import 'package:komah_project/theme/app_text_styles.dart';
import 'package:komah_project/utils/validators.dart';
import 'package:komah_project/widgets/custom_text_field.dart';
import 'package:komah_project/widgets/gradient_button.dart';
import 'package:komah_project/widgets/komah_widgets.dart';
import 'package:provider/provider.dart';

/// Rute: /alamat/tambah
class AddressFormScreen extends StatelessWidget {
  const AddressFormScreen({super.key});

  static const _labels = ['Kos', 'Kampus', 'Kantin', 'Rumah', 'Lainnya'];

  Future<void> _openMap(BuildContext context) async {
    final form = context.read<AddressFormController>();
    FocusScope.of(context).unfocus();
    final result = await Navigator.of(context).pushNamed(AppRoutes.alamatPeta);
    // Hasil map picker diperiksa dengan `is Map`, bukan pushNamed bertipe.
    if (result is Map) form.applyMapResult(result);
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final form = context.read<AddressFormController>();
    // Validasi: label dan alamat wajib diisi.
    if (form.validate(
  (value) => Validators.requiredField(
    value,
    fieldName: 'Label alamat',
  ),
  (value) => Validators.requiredField(
    value,
    fieldName: 'Alamat',
  ),
 )) {
  Navigator.of(context).pushNamed(AppRoutes.alamatMenyimpan);
  }
}

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AddressFormController>();
    final labelHasError = form.labelError != null;
    return Scaffold(
      backgroundColor: AppColors.kmCream,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  AppBackButton(),
                  Expanded(child: Center(child: StepProgressBar(step: 2))),
                  SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 12),
              Text('Tambah Alamat Favorit', style: AppTextStyles.kmTitle.copyWith(fontSize: 24)),
              const SizedBox(height: 6),
              Text('Isi detail alamat yang ingin kamu simpan.', style: AppTextStyles.kmBody),
              const SizedBox(height: 20),
              const _FieldTitle('Label Alamat'),
              _SoftShadow(
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(iconForLabel(form.label), color: AppColors.kmCoral),
                    errorText: form.labelError,
                    errorStyle: AppTextStyles.km(size: 12, color: Colors.red.shade700),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: form.label,
                      style: AppTextStyles.km(size: 14, weight: FontWeight.w600),
                      hint: Text('Pilih label alamat',
                          style: AppTextStyles.km(color: labelHasError ? Colors.red : AppColors.kmGrey)),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      borderRadius: BorderRadius.circular(14),
                      items: [
                        for (final l in _labels)
                          DropdownMenuItem(
                            value: l,
                            child: Row(children: [
                              Icon(iconForLabel(l), size: 18, color: AppColors.kmCoral),
                              const SizedBox(width: 8),
                              Text(l),
                            ]),
                          ),
                      ],
                      onChanged: form.setLabel,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const _FieldTitle('Alamat Lengkap'),
              _SoftShadow(
                child: CustomTextField(
                  controller: form.addressText,
                  hintText: 'Ketik alamat atau pilih dari peta',
                  backgroundColor: Colors.white,
                  errorText: form.addressError,
                  prefixIcon: Icons.location_on_rounded,
                  prefixIconColor: AppColors.kmCoral,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location_rounded, color: AppColors.kmNavy),
                    tooltip: 'Pilih dari peta',
                    onPressed: () => _openMap(context),
                  ),
                  minLines: 1,
                  maxLines: 3,
                  onChanged: form.onAddressChanged,
                ),
              ),
              const SizedBox(height: 16),
              const _FieldTitle('Detail Lokasi (opsional)'),
              _SoftShadow(
                child: CustomTextField(
                  controller: form.detailText,
                  hintText: 'Contoh: dekat gerbang, lantai 2, dll',
                  backgroundColor: Colors.white,
                  minLines: 3,
                  maxLines: 4,
                  maxLength: 100,
                ),
              ),
              const SizedBox(height: 8),
              const InfoBox(
                text: 'Alamat favorit akan tersimpan di akun kamu dan bisa digunakan saat membuat pesanan.',
              ),
              const SizedBox(height: 24),
              GradientButton(
                text: 'Simpan Alamat',
                icon: Icons.arrow_forward_rounded,
                height: AppSpacing.kmButtonHeight,
                radius: AppSpacing.kmButtonRadius,
                onPressed: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldTitle extends StatelessWidget {
  const _FieldTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppTextStyles.km(size: 13, weight: FontWeight.w700)),
      );
}

/// Bayangan lembut di sekeliling input.
class _SoftShadow extends StatelessWidget {
  const _SoftShadow({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: AppColors.kmNavy.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: child,
      );
}