import 'package:flutter/material.dart';

import '../models/order.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../widgets/info_banner.dart';
import '../widgets/order_detail_row.dart';
import '../widgets/step_indicator.dart';

// [STATE] Data sudah terisi dan siap dikonfirmasi (status "filled").
// Layar ini hanya menampilkan data, jadi cukup StatelessWidget.
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.order});

  // [NAVIGATION] Order diterima dari layar Form lewat arguments.
  final Order order;

  // [INPUT/EVENT] Tombol "Ubah": kembali ke Form dengan data tetap terisi.
  // pushReplacementNamed dipakai agar tumpukan halaman tidak menumpuk
  // (Konfirmasi diganti Form, bukan ditambah di atasnya).
  void _edit(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.orderForm,
      arguments: order,
    );
  }

  // [INPUT/EVENT] Tombol "Buat Pesanan": lanjut ke layar Processing.
  void _createOrder(BuildContext context) {
    // [NAVIGATION] Kirim Order ke Processing. Pemanggilan repository
    // dilakukan di layar Processing, bukan di sini.
    Navigator.pushNamed(
      context,
      AppRoutes.processing,
      arguments: order,
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Baris atas: tombol back + stepper (langkah 2) ──
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.textPrimary),
                          onPressed: () => _edit(context),
                        ),
                        const Spacer(),
                        const StepIndicator(currentStep: 2),
                        const Spacer(),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    Text('Konfirmasi Pesanan',
                        style: AppTextStyles.screenTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Pastikan detail pesanan sudah benar.',
                        style: AppTextStyles.screenSubtitle),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Kartu ringkasan pesanan ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          // Layanan
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(order.service,
                                        style: AppTextStyles.cardTitle),
                                    Text(
                                      'Ke kelas, ke kos,\nke tempat lain di kampus.',
                                      style: AppTextStyles.detailLabel,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.xl),

                          // [FEEDBACK] Data ditampilkan ulang agar user
                          // bisa memeriksa sebelum membuat pesanan.
                          OrderDetailRow(
                            icon: Icons.location_on,
                            label: 'Lokasi Jemput',
                            value: order.pickup,
                            onEdit: () => _edit(context),
                          ),
                          const Divider(height: 1),
                          OrderDetailRow(
                            icon: Icons.location_on,
                            label: 'Tujuan',
                            value: order.destination,
                            onEdit: () => _edit(context),
                          ),
                          const Divider(height: 1),
                          // Penumpang tetap 1 orang, jadi tanpa tombol Ubah.
                          OrderDetailRow(
                            icon: Icons.person_outline,
                            iconColor: AppColors.textSecondary,
                            label: 'Jumlah Penumpang',
                            value: '${order.passengers} orang',
                          ),
                          const Divider(height: 1),
                          OrderDetailRow(
                            icon: Icons.description_outlined,
                            iconColor: AppColors.textSecondary,
                            label: 'Catatan',
                            // Catatan opsional: tampilkan "-" jika kosong.
                            value:
                                order.note.isEmpty ? '-' : order.note,
                            onEdit: () => _edit(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    const InfoBanner(
                      text: 'Setelah pesanan dibuat, kamu belum dapat '
                          'mengubah detail pesanan.',
                    ),
                  ],
                ),
              ),
            ),

            // ── Tombol Buat Pesanan (tetap di bawah) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontalPadding,
                AppSpacing.sm,
                AppSpacing.screenHorizontalPadding,
                AppSpacing.lg,
              ),
              child: GradientButton(
                text: 'Buat Pesanan',
                textStyle: AppTextStyles.buttonText,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => _createOrder(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}