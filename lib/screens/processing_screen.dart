import 'package:flutter/material.dart';

import '../models/order.dart';
import '../repositories/order_repository.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../widgets/info_banner.dart';
import '../widgets/step_indicator.dart';

// [STATE] StatefulWidget karena tampilan berubah:
// loading -> (berhasil pindah layar) atau error.
class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key, required this.order});

  // [NAVIGATION] Order diterima dari layar Konfirmasi lewat arguments.
  final Order order;

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final _repository = OrderRepository();

  // [STATE] Status proses. Dimulai dari loading.
  OrderStatus _status = OrderStatus.loading;

  @override
  void initState() {
    super.initState();
    // Proses dimulai otomatis begitu layar tampil.
    _processOrder();
  }

  // [ASYNC/AWAIT] Memanggil repository dan menunggu nomor pesanan.
  Future<void> _processOrder() async {
    // [STATE] Pastikan tampilan kembali ke loading (dipakai juga saat "Coba Lagi").
    setState(() => _status = OrderStatus.loading);

    try {
      // Menunggu 2 detik (simulasi server), hasilnya nomor pesanan.
      final orderNumber = await _repository.createOrder(widget.order);

      // Layar bisa saja sudah ditutup selama menunggu, jadi cek dulu.
      if (!mounted) return;

      // [STATE] Proses berhasil.
      setState(() => _status = OrderStatus.success);

      // [NAVIGATION] Ganti Processing dengan Pesanan Berhasil
      // (bukan ditumpuk) agar user tidak bisa kembali ke layar loading.
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.orderSuccess,
        arguments: widget.order.copyWith(orderNumber: orderNumber),
      );
    } catch (e) {
      if (!mounted) return;

      // [STATE] Proses gagal -> tampilkan error + tombol coba lagi.
      setState(() => _status = OrderStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isError = _status == OrderStatus.error;

    // [FEEDBACK] Selama loading, tombol back ditahan agar proses tidak terputus.
    // Saat error, user boleh kembali.
    return PopScope(
      canPop: isError,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontalPadding,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              children: [
                // ── Stepper (langkah 3) ──
                const StepIndicator(currentStep: 3),
                const Spacer(),

                // ── Ilustrasi ──
                Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.softOrange,
                  ),
                  child: Icon(
                    isError ? Icons.error_outline : Icons.two_wheeler,
                    size: 90,
                    color: isError ? AppColors.error : AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // [FEEDBACK] Pesan sesuai state: loading atau error.
                Text(
                  isError ? 'Pesanan gagal dibuat' : 'Memproses pesanan...',
                  style: AppTextStyles.screenTitle.copyWith(fontSize: 22),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isError
                      ? 'Terjadi kendala saat membuat pesanan.\nSilakan coba lagi.'
                      : 'Mohon tunggu sebentar,\npesananmu sedang dibuat.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.screenSubtitle,
                ),
                const SizedBox(height: AppSpacing.xl),

                // [FEEDBACK] Indikator loading hanya tampil saat loading.
                if (_status == OrderStatus.loading)
                  const CircularProgressIndicator(color: AppColors.primary),

                // [INPUT/EVENT] Tombol coba lagi hanya tampil saat error.
                if (isError)
                  GradientButton(
                    text: 'Coba Lagi',
                    textStyle: AppTextStyles.buttonText,
                    onPressed: _processOrder,
                  ),

                const Spacer(),

                const InfoBanner(
                  text: 'Jangan keluar dari halaman ini sampai proses selesai.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}