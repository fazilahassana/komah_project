import 'package:flutter/material.dart';

import '../models/order.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/step_indicator.dart';

class OrderFormScreen extends StatefulWidget {
  // initialOrder terisi saat user menekan "Ubah" dari layar Konfirmasi.
  const OrderFormScreen({super.key, this.initialOrder});

  final Order? initialOrder;

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  // [VALIDATION] Kunci untuk mengakses dan memvalidasi Form.
  final _formKey = GlobalKey<FormState>();

  // [INPUT/EVENT] Controller membaca isi tiap field.
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();
  final _noteController = TextEditingController();

  // [STATE] Status form: initial (kosong) atau filled (sudah ada isi).
  OrderStatus _status = OrderStatus.initial;

  @override
  void initState() {
    super.initState();

    // Isi awal jika form dibuka kembali dari layar Konfirmasi.
    final o = widget.initialOrder;
    if (o != null) {
      _pickupController.text = o.pickup;
      _destinationController.text = o.destination;
      _noteController.text = o.note;
    }

    // [STATE] Pantau perubahan input untuk memperbarui status form.
    _pickupController.addListener(_updateStatus);
    _destinationController.addListener(_updateStatus);
    _updateStatus();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // [STATE] initial = semua kosong, filled = minimal satu field terisi.
  void _updateStatus() {
    final filled = _pickupController.text.trim().isNotEmpty ||
        _destinationController.text.trim().isNotEmpty;
    final next = filled ? OrderStatus.filled : OrderStatus.initial;
    if (next != _status) {
      setState(() => _status = next);
    }
  }

  // [VALIDATION] Lokasi jemput wajib diisi.
  String? _validatePickup(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lokasi jemput wajib diisi.';
    }
    return null;
  }

  // [VALIDATION] Tujuan wajib diisi dan tidak boleh sama dengan jemput.
  String? _validateDestination(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tujuan wajib diisi.';
    }
    if (value.trim().toLowerCase() ==
        _pickupController.text.trim().toLowerCase()) {
      return 'Tujuan tidak boleh sama dengan lokasi jemput.';
    }
    return null;
  }

  // [INPUT/EVENT] Tombol "Lanjutkan".
  void _submit() {
    // [VALIDATION] Jika ada field tidak valid, pesan error tampil di bawah
    // field dan user tetap di halaman form (tidak ada navigasi).
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Data valid: bentuk objek Order dari isi form.
    final order = Order(
      pickup: _pickupController.text.trim(),
      destination: _destinationController.text.trim(),
      note: _noteController.text.trim(),
    );

    // [NAVIGATION] Kirim Order ke layar Konfirmasi lewat arguments.
    Navigator.pushNamed(context, AppRoutes.orderConfirmation,
        arguments: order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontalPadding,
                  vertical: AppSpacing.lg,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Baris atas: tombol back + stepper (langkah 1) ──
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const StepIndicator(currentStep: 1),
                          const Spacer(),
                          const SizedBox(width: 24),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Header layanan ──
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.softOrange,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.two_wheeler,
                                color: AppColors.primary, size: 30),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Antar Orang',
                                  style: AppTextStyles.screenTitle
                                      .copyWith(fontSize: 20)),
                              Text('Isi detail pesanan kamu.',
                                  style: AppTextStyles.screenSubtitle),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Lokasi Jemput (wajib) ──
                      Text('Lokasi Jemput', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: AppSpacing.sm),
                      CustomTextField(
                        controller: _pickupController,
                        hintText: 'Contoh: Lobi FTI',
                        prefixIcon: Icons.location_on,
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.cardBorder,
                        borderWidth: 1,
                        validator: _validatePickup,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Tujuan (wajib) ──
                      Text('Tujuan', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: AppSpacing.sm),
                      CustomTextField(
                        controller: _destinationController,
                        hintText: 'Contoh: Gedung E UNAND',
                        prefixIcon: Icons.location_on,
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.cardBorder,
                        borderWidth: 1,
                        validator: _validateDestination,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Jumlah Penumpang (tetap, read-only) ──
                      Text('Jumlah Penumpang',
                          style: AppTextStyles.fieldLabel),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.softPurple,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.inputRadius),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline,
                                color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.md),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('1 orang',
                                    style: AppTextStyles.detailValue
                                        .copyWith(fontSize: 14)),
                                Text('Layanan ini khusus 1 penumpang.',
                                    style: AppTextStyles.detailLabel),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // ── Catatan (opsional, tanpa validator) ──
                      Text('Catatan (opsional)',
                          style: AppTextStyles.fieldLabel),
                      const SizedBox(height: AppSpacing.sm),
                      CustomTextField(
                        controller: _noteController,
                        hintText: 'Contoh: Jemput di depan gerbang',
                        backgroundColor: AppColors.white,
                        borderColor: AppColors.cardBorder,
                        borderWidth: 1,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Tombol Lanjutkan (tetap di bawah) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontalPadding,
                AppSpacing.sm,
                AppSpacing.screenHorizontalPadding,
                AppSpacing.lg,
              ),
              child: GradientButton(
                text: 'Lanjutkan',
                textStyle: AppTextStyles.buttonText,
                icon: Icons.arrow_forward_rounded,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}