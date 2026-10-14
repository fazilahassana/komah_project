import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../widgets/info_banner.dart';

// [STATE] Daftar layanan yang bisa dipilih.
enum ServiceType { antarOrang, antarMakanan, antarBarang }

// [STATE] Layar ini StatefulWidget karena pilihan layanan berubah
// saat kartu ditekan.
class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  // [STATE] Pilihan awal: Antar Orang (layanan untuk demo).
  ServiceType _selected = ServiceType.antarOrang;

  // [INPUT/EVENT] Memilih kartu layanan -> setState memperbarui tampilan radio.
  void _select(ServiceType type) {
    setState(() => _selected = type);
  }

  // [INPUT/EVENT] Tombol "Lanjutkan".
  void _continue() {
    // [VALIDATION] Fitur ini hanya melayani Antar Orang.
    // Layanan lain ditolak dengan pesan, user tetap di halaman ini.
    if (_selected != ServiceType.antarOrang) {
      // [FEEDBACK] Pesan bahwa layanan belum tersedia.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Layanan ini belum tersedia. Pilih Antar Orang.'),
        ),
      );
      return;
    }

    // [NAVIGATION] Lanjut ke Form Pesanan (form baru, tanpa data awal).
    Navigator.pushNamed(context, AppRoutes.orderForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
            body: SafeArea(
        child: Column(
          children: [
            // Area isi: bisa di-scroll jika layar pendek.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontalPadding,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // [NAVIGATION] Tombol kembali ke Beranda.
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Mau pesan apa?', style: AppTextStyles.screenTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Pilih jenis layanan sesuai kebutuhan kamu.',
                        style: AppTextStyles.screenSubtitle),
                    const SizedBox(height: AppSpacing.xl),

                    // [INPUT/EVENT] Tiga kartu layanan dengan radio.
                    _ServiceOptionCard(
                      icon: Icons.two_wheeler,
                      title: 'Antar Orang',
                      desc: 'Ke kelas, ke kos,\nke tempat lain di kampus.',
                      selected: _selected == ServiceType.antarOrang,
                      onTap: () => _select(ServiceType.antarOrang),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ServiceOptionCard(
                      icon: Icons.ramen_dining,
                      title: 'Antar Makanan',
                      desc: 'Dari kantin, kafe,\natau tempat favorit kamu.',
                      selected: _selected == ServiceType.antarMakanan,
                      onTap: () => _select(ServiceType.antarMakanan),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _ServiceOptionCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Antar Barang',
                      desc: 'Dokumen, paket,\natau barang lainnya.',
                      selected: _selected == ServiceType.antarBarang,
                      onTap: () => _select(ServiceType.antarBarang),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    const InfoBanner(
                      text: 'Semua layanan menggunakan kendaraan motor '
                          'untuk mobilitas di kampus.',
                    ),
                  ],
                ),
              ),
            ),

            // Tombol tetap di bawah, tidak ikut ter-scroll.
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
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Kartu satu layanan: ikon, judul, deskripsi, dan indikator radio.
class _ServiceOptionCard extends StatelessWidget {
  const _ServiceOptionCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          // [STATE] Border oranye menandai kartu yang sedang dipilih.
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.softOrange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: AppSpacing.xs),
                  Text(desc,
                      style: AppTextStyles.detailLabel
                          .copyWith(fontSize: 12, height: 1.5)),
                ],
              ),
            ),
            // Indikator radio: lingkaran oranye + centang saat dipilih.
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.cardBorder,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}