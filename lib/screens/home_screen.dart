import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

// [STATE] Beranda hanya menampilkan data tetap, tanpa input,
// jadi cukup StatelessWidget.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // [NAVIGATION] Tombol "Pesan Sekarang" membuka layar Pilih Layanan
  // lewat named route.
  void _goToSelectService(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontalPadding,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: AppSpacing.xl),
              const _Greeting(),
              const SizedBox(height: AppSpacing.lg),
              const _SearchBar(),
              const SizedBox(height: AppSpacing.lg),
              const _PromoBanner(),
              const SizedBox(height: AppSpacing.md),
              const _BannerDots(),
              const SizedBox(height: AppSpacing.xl),

              // [INPUT/EVENT] Tombol utama: menekan "Pesan Sekarang"
              // memulai alur pemesanan.
              GradientButton(
                text: 'Pesan Sekarang',
                textStyle: AppTextStyles.buttonText,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => _goToSelectService(context),
              ),
              const SizedBox(height: AppSpacing.xl),

              const _ServiceShortcuts(),
              const SizedBox(height: AppSpacing.xl),
              const _LastOrderSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header: logo + lonceng notifikasi ──
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo_komah_new.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'K',
                      style: AppTextStyles.cardTitle.copyWith(color: AppColors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'KOMAH',
              style: AppTextStyles.screenTitle.copyWith(fontSize: 20),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded,
                size: 28, color: AppColors.textPrimary),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '1',
                  style: AppTextStyles.detailLabel.copyWith(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Sapaan pengguna ──
class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.softOrange,
          child: Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, King!',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            Text('Mau ke mana hari ini?', style: AppTextStyles.screenSubtitle),
          ],
        ),
      ],
    );
  }
}

// ── Kotak pencarian (hiasan, di luar scope fitur) ──
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text('Mau pesan apa?', style: AppTextStyles.screenSubtitle),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward_rounded,
                color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

// ── Banner promosi ──
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E1F66), Color(0xFF4A2A6B), Color(0xFFB5654F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Antar-jemput kuliah,\nharganya ramah di kantong\nanak kos.',
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _BannerChip(icon: Icons.shield_outlined, label: 'Aman'),
              _BannerChip(icon: Icons.bolt, label: 'Cepat'),
              _BannerChip(
                  icon: Icons.location_on_outlined,
                  label: 'Khusus area kampus'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  const _BannerChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFFFD27A)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.detailLabel.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ── Titik indikator banner (statis) ──
class _BannerDots extends StatelessWidget {
  const _BannerDots();

  @override
  Widget build(BuildContext context) {
    Widget dot({required bool active}) => Container(
          width: active ? 22 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.cardBorder,
            borderRadius: BorderRadius.circular(4),
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [dot(active: true), dot(active: false), dot(active: false), dot(active: false)],
    );
  }
}

// ── Pintasan 3 jenis layanan (informasi saja) ──
class _ServiceShortcuts extends StatelessWidget {
  const _ServiceShortcuts();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _ServiceCard(
            icon: Icons.two_wheeler,
            color: AppColors.softPurple,
            title: 'Antar-Orang',
            desc: 'Ke kelas, ke kos, ke tempat lain',
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ServiceCard(
            icon: Icons.ramen_dining,
            color: AppColors.softOrange,
            title: 'Antar Makanan',
            desc: 'Dari kantin, kafe, atau tempat favorit',
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ServiceCard(
            icon: Icons.inventory_2_outlined,
            color: AppColors.softOrange,
            title: 'Antar Barang',
            desc: 'Dokumen, paket, atau barang lainnya',
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.fieldLabel.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: AppTextStyles.detailLabel.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ── Pesanan terakhir (data contoh, bukan riwayat sungguhan) ──
// ── Pesanan terakhir: dibaca dari OrderRepository (data nyata) ──
class _LastOrderSection extends StatelessWidget {
  const _LastOrderSection();

  @override
  Widget build(BuildContext context) {
    // [RESULT] Ambil pesanan terbaru yang tersimpan di repository.
    final Order? order = OrderRepository().latestOrder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pesanan Terakhir',
            style: AppTextStyles.fieldLabel.copyWith(fontSize: 15)),
        const SizedBox(height: AppSpacing.md),

        // [FEEDBACK] Jika belum ada pesanan, tampilkan pesan kosong.
        if (order == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Text(
              'Belum ada pesanan.',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenSubtitle,
            ),
          )
        else
              GestureDetector(
            // [INPUT/EVENT] Tekan kartu -> lihat detail pesanan.
            // [NAVIGATION] Mengirim: Order + penanda fromHome.
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.orderSuccess,
              arguments: {'order': order, 'fromHome': true},
            ),
            child: Container(
            
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.softOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.two_wheeler, color: AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.orderNumber ?? '-',
                              style: AppTextStyles.detailValue
                                  .copyWith(fontSize: 14)),
                          Text(order.service, style: AppTextStyles.screenSubtitle),
                          Text(order.createdAtLabel,
                              style: AppTextStyles.detailLabel),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.softOrange,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Menunggu',
                        style: AppTextStyles.fieldLabel
                            .copyWith(color: AppColors.primary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),  
      ],
    );
  }
}
// ── Navigasi bawah (statis, hanya tab Beranda yang aktif) ──
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Beranda', active: true),
              _NavItem(icon: Icons.assignment_outlined, label: 'Pesanan'),
              _NavItem(icon: Icons.support_agent, label: 'Bantuan'),
              _NavItem(icon: Icons.person_outline, label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textSecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(label,
            style: AppTextStyles.detailLabel
                .copyWith(color: color, fontSize: 11)),
      ],
    );
  }
}