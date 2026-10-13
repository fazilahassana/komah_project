import 'dart:async';

import 'package:flutter/material.dart';
import 'package:komah_project/data/address_repository.dart';
import 'package:komah_project/models/favorite_address.dart';
import 'package:komah_project/routes/app_routes.dart';
import 'package:komah_project/theme/app_colors.dart';
import 'package:komah_project/theme/app_spacing.dart';
import 'package:komah_project/theme/app_text_styles.dart';
import 'package:komah_project/widgets/gradient_button.dart';
import 'package:komah_project/widgets/komah_widgets.dart';
import 'package:provider/provider.dart';

/// Rute: /alamat/menyimpan
class SavingScreen extends StatefulWidget {
  const SavingScreen({super.key});

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  bool _started = false; // mencegah penyimpanan dipanggil dua kali

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  /// Penyimpanan asynchronous: jeda 2 detik, simpan sungguhan, lalu pindah layar.
  Future<void> _run() async {
    if (_started || !mounted) return;
    _started = true;
    final form = context.read<AddressFormController>();
    final repo = context.read<AddressRepository>();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    form.setLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      final address = form.buildAddress();
      await repo.add(address);
      if (!mounted) return;
      form.setSuccess();
      nav.pushReplacementNamed(AppRoutes.alamatBerhasil, arguments: address);
    } catch (_) {
      if (!mounted) return;
      // Data form tetap utuh; kembali ke form dan beri tahu pengguna.
      form.setError('Gagal menyimpan alamat. Silakan coba lagi.');
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Gagal menyimpan alamat. Silakan coba lagi.',
              style: AppTextStyles.km(size: 13, color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
        ));
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // tidak boleh keluar selama proses penyimpanan
      child: Scaffold(
        backgroundColor: AppColors.kmCream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const StepProgressBar(step: 3),
                const Spacer(),
                const PinIllustration(size: 180),
                const SizedBox(height: 24),
                Text('Menyimpan alamat...', style: AppTextStyles.kmTitle.copyWith(fontSize: 22)),
                const SizedBox(height: 8),
                Text('Mohon tunggu sebentar, alamat favorit kamu sedang disimpan.',
                    textAlign: TextAlign.center, style: AppTextStyles.kmBody),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: AppColors.kmCoral),
                const Spacer(),
                const InfoBox(text: 'Jangan keluar dari halaman ini sampai proses selesai.'),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kembali ke daftar alamat tanpa meninggalkan layar loading di stack.
void _popToList(NavigatorState nav) {
  var found = false;
  nav.popUntil((r) {
    if (r.settings.name == AppRoutes.alamat) {
      found = true;
      return true;
    }
    return r.isFirst;
  });
  if (!found) nav.pushNamed(AppRoutes.alamat);
}

/// Rute: /alamat/berhasil
class SaveSuccessScreen extends StatelessWidget {
  const SaveSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final repo = context.read<AddressRepository>();
    // Argumen aman: jika tidak valid, pakai alamat terakhir dari repository.
    final FavoriteAddress? address =
        args is FavoriteAddress ? args : (repo.items.isNotEmpty ? repo.items.last : null);
    final nav = Navigator.of(context);

    return PopScope(
      canPop: false,
      // Tombol back sistem menuju daftar alamat, bukan layar menyimpan.
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _popToList(nav);
      },
      child: Scaffold(
        backgroundColor: AppColors.kmCream,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppBackButton(onPressed: () => _popToList(nav)),
                          const Expanded(child: Center(child: StepProgressBar(step: 4, full: true))),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Center(child: PinIllustration(size: 150, showBadge: true)),
                      const SizedBox(height: 12),
                      Center(
                        child: Text('Alamat Berhasil Disimpan!',
                            style: AppTextStyles.kmTitle.copyWith(fontSize: 22)),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Alamat favorit kamu sudah tersimpan dan siap digunakan saat membuat pesanan.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.kmBody,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Detail Alamat', style: AppTextStyles.km(weight: FontWeight.w800)),
                          ),
                          // Chip hanya tampilan dan nonaktif.
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.kmLavender, borderRadius: BorderRadius.circular(12)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.edit_rounded, size: 14, color: AppColors.kmLavenderText),
                              const SizedBox(width: 4),
                              Text('Ubah',
                                  style: AppTextStyles.km(size: 12, color: AppColors.kmLavenderText)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.kmNavy.withValues(alpha: 0.06)),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.kmNavy.withValues(alpha: 0.06),
                                blurRadius: 14,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: [
                            _DetailRow(
                                icon: iconForLabel(address?.label),
                                title: 'Label Alamat',
                                value: address?.label ?? '-'),
                            const SizedBox(height: 12),
                            _DetailRow(
                                icon: Icons.location_on_rounded,
                                title: 'Alamat Lengkap',
                                value: address?.fullAddress ?? '-'),
                            const SizedBox(height: 12),
                            _DetailRow(
                              icon: Icons.description_rounded,
                              title: 'Detail Lokasi',
                              value: (address == null || address.detail.isEmpty) ? '-' : address.detail,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        text: 'Kembali ke Alamat Favorit',
                        icon: Icons.arrow_forward_rounded,
                        height: AppSpacing.kmButtonHeight,
                        radius: AppSpacing.kmButtonRadius,
                        onPressed: () => _popToList(nav),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.kmButtonHeight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.kmLavender,
                            foregroundColor: AppColors.kmLavenderText,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.kmButtonRadius)),
                          ),
                          onPressed: () {
                            context.read<AddressFormController>().reset();
                            _popToList(nav);
                            nav.pushNamed(AppRoutes.alamatTambah);
                          },
                          child: Text('Tambah Alamat Lain',
                              style: AppTextStyles.km(
                                  weight: FontWeight.w700, color: AppColors.kmLavenderText)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const BottomNavBar(currentIndex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: AppColors.kmLavender, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppColors.kmLavenderText),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.km(size: 11.5, color: AppColors.kmGrey)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.km(weight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}