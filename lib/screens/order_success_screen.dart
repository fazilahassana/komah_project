import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/order.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../widgets/order_detail_row.dart';
import '../widgets/step_indicator.dart';

// [STATE] Status akhir: success. Layar hanya menampilkan hasil,
// jadi cukup StatelessWidget.
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.order,
    this.fromHome = false, // true jika dibuka dari kartu di Beranda
  });

  final Order order;
  final bool fromHome;


  // [INPUT/EVENT] Tombol salin: menyalin nomor pesanan ke clipboard.
  Future<void> _copyOrderNumber(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: order.orderNumber ?? ''));
    if (!context.mounted) return;

    // [FEEDBACK] Konfirmasi bahwa nomor sudah tersalin.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nomor pesanan disalin.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // [INPUT/EVENT] Tombol "Kembali ke Beranda".
  void _backToHome(BuildContext context) {
    // [NAVIGATION] Bersihkan seluruh tumpukan halaman alur pesanan,
    // lalu tampilkan Beranda sebagai halaman dasar.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // [RESULT] Nomor pesanan hasil repository, contoh #KMH00123.
    final orderNumber = order.orderNumber ?? '-';

    // Tombol back sistem diarahkan ke Beranda, bukan ke layar loading.
    return PopScope(
      canPop: fromHome, // dari Beranda: back normal; setelah pesan dibuat: ke Beranda
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToHome(context);
        
      },
      
      child: Scaffold(
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
                      if (!fromHome)
                        const Center(child: StepIndicator(currentStep: 4)),
                      if (!fromHome) const SizedBox(height: AppSpacing.xl),

                      // ── Ilustrasi sukses ──
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.softOrange,
                              ),
                              child: const Icon(Icons.two_wheeler,
                                  size: 80, color: AppColors.primary),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.brandPurple,
                                ),
                                child: const Icon(Icons.check,
                                    color: AppColors.white, size: 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // [FEEDBACK] Pesan berhasil.
                      Center(
                        child: Text(
                          fromHome ? 'Detail Pesanan' : 'Pesanan Berhasil Dibuat!',
                          style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Center(
                        child: Text(
                          'Pesananmu sudah dibuat dan sedang\nmenunggu driver yang tersedia.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.screenSubtitle,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Kartu nomor pesanan + tombol salin ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.softPurple,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Pesanan',
                                      style: AppTextStyles.detailLabel),
                                  const SizedBox(height: 2),
                                  Text(
                                    orderNumber,
                                    style: AppTextStyles.screenTitle
                                        .copyWith(fontSize: 22),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded,
                                  color: AppColors.brandPurple),
                              onPressed: () => _copyOrderNumber(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ── Detail pesanan (tanpa tombol Ubah) ──
                      Text('Detail Pesanan', style: AppTextStyles.cardTitle),
                      OrderDetailRow(
                        icon: Icons.two_wheeler,
                        label: 'Layanan',
                        value: order.service,
                      ),
                      OrderDetailRow(
                        icon: Icons.location_on,
                        label: 'Lokasi Jemput',
                        value: order.pickup,
                      ),
                      OrderDetailRow(
                        icon: Icons.location_on,
                        label: 'Tujuan',
                        value: order.destination,
                      ),
                      OrderDetailRow(
                        icon: Icons.person_outline,
                        iconColor: AppColors.textSecondary,
                        label: 'Jumlah Penumpang',
                        value: '${order.passengers} orang',
                      ),
                      OrderDetailRow(
                        icon: Icons.description_outlined,
                        iconColor: AppColors.textSecondary,
                        label: 'Catatan',
                        value: order.note.isEmpty ? '-' : order.note,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Tombol Kembali ke Beranda ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontalPadding,
                  AppSpacing.sm,
                  AppSpacing.screenHorizontalPadding,
                  AppSpacing.lg,
                ),
               child: GradientButton(
                  text: fromHome ? 'Kembali' : 'Kembali ke Beranda',
                  textStyle: AppTextStyles.buttonText,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () =>
                      fromHome ? Navigator.pop(context) : _backToHome(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}