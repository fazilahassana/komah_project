import 'package:flutter/material.dart';
import 'package:komah_project/models/favorite_address.dart';
import 'package:komah_project/theme/app_colors.dart';
import 'package:komah_project/theme/app_text_styles.dart';

/// Ikon sesuai label alamat.
IconData iconForLabel(String? label) {
  switch (label) {
    case 'Kos':
    case 'Rumah':
      return Icons.home_rounded;
    case 'Kampus':
      return Icons.school_rounded;
    case 'Kantin':
      return Icons.restaurant_rounded;
    default:
      return Icons.location_on_rounded;
  }
}

/// Feedback singkat berupa SnackBar.
void showAppSnack(
  BuildContext context,
  String message, {
  bool isError = false,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.km(size: 13, color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade600 : AppColors.kmNavy,
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, textColor: Colors.white, onPressed: onAction ?? () {}),
      ),
    );
}

/// Kartu alamat. Menu titik tiga hanya dekoratif.
class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address});
  final FavoriteAddress address;

  @override
  Widget build(BuildContext context) {
    final tinted = address.label == 'Kampus';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kmNavy.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(color: AppColors.kmNavy.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tinted ? AppColors.kmLavender : AppColors.kmCoral.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconForLabel(address.label),
                color: tinted ? AppColors.kmLavenderText : AppColors.kmCoral, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.label, style: AppTextStyles.km(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(address.fullAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.km(size: 12.5, color: AppColors.kmGrey)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: AppColors.kmGrey),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.kmLavender, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: AppColors.kmLavenderText, shape: BoxShape.circle),
            child: const Icon(Icons.info_rounded, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.km(size: 12.5, height: 1.4))),
        ],
      ),
    );
  }
}

/// Navigasi bawah empat tab. Tab selain Alamat membuka PlaceholderScreen.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, this.currentIndex = 2});
  final int currentIndex;

  static const _tabs = [
    (Icons.home_rounded, 'Beranda'),
    (Icons.receipt_long_rounded, 'Pesanan'),
    (Icons.location_on_rounded, 'Alamat'),
    (Icons.person_rounded, 'Akun'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: AppColors.kmNavy.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (i == currentIndex) return;
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => PlaceholderScreen(title: _tabs[i].$2),
                      ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_tabs[i].$1,
                            size: 24, color: i == currentIndex ? AppColors.kmCoral : AppColors.kmGrey),
                        const SizedBox(height: 2),
                        Text(
                          _tabs[i].$2,
                          style: AppTextStyles.km(
                            size: 11,
                            weight: i == currentIndex ? FontWeight.w700 : FontWeight.w500,
                            color: i == currentIndex ? AppColors.kmCoral : AppColors.kmGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == currentIndex ? AppColors.kmCoral : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Indikator langkah: [step] segmen terisi (1..total); [full] mengisi semua.
class StepProgressBar extends StatelessWidget {
  const StepProgressBar({super.key, required this.step, this.total = 4, this.full = false});
  final int step;
  final int total;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final filled = full ? total : step;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= total; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: (i == filled || full) ? 26 : 8,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: i <= filled
                  ? const LinearGradient(colors: [AppColors.kmCoral, AppColors.kmOrange])
                  : null,
              color: i <= filled ? null : AppColors.kmNavy.withValues(alpha: 0.12),
            ),
          ),
      ],
    );
  }
}

/// Ilustrasi pin dari ikon Flutter (tanpa gambar eksternal).
class PinIllustration extends StatelessWidget {
  const PinIllustration({super.key, this.size = 120, this.showBadge = false});
  final double size;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.86,
            height: size * 0.86,
            decoration: BoxDecoration(color: AppColors.kmCoral.withValues(alpha: 0.10), shape: BoxShape.circle),
          ),
          Positioned(left: size * 0.04, bottom: size * 0.16,
              child: Icon(Icons.home_work_rounded, size: size * 0.26, color: AppColors.kmOrange)),
          Positioned(right: size * 0.04, bottom: size * 0.16,
              child: Icon(Icons.apartment_rounded, size: size * 0.28, color: AppColors.kmLavenderText.withValues(alpha: 0.6))),
          Icon(Icons.location_on_rounded, size: size * 0.6, color: AppColors.kmCoral),
          if (showBadge)
            Positioned(
              top: size * 0.2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, size: size * 0.2, color: AppColors.kmCoral),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tombol kembali yang aman jika tidak ada halaman sebelumnya.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.kmNavy),
      onPressed: onPressed ??
          () {
            final nav = Navigator.of(context);
            if (nav.canPop()) nav.pop();
          },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kmCream,
      appBar: AppBar(
        backgroundColor: AppColors.kmCream,
        elevation: 0,
        leading: const AppBackButton(),
        title: Text(title, style: AppTextStyles.km(size: 18, weight: FontWeight.w700)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Halaman $title belum tersedia.',
              textAlign: TextAlign.center, style: AppTextStyles.km(color: AppColors.kmGrey)),
        ),
      ),
    );
  }
}