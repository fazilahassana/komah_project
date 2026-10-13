import 'package:flutter/material.dart';
import 'package:komah_project/data/address_repository.dart';
import 'package:komah_project/routes/app_routes.dart';
import 'package:komah_project/theme/app_colors.dart';
import 'package:komah_project/theme/app_spacing.dart';
import 'package:komah_project/theme/app_text_styles.dart';
import 'package:komah_project/widgets/gradient_button.dart';
import 'package:komah_project/widgets/komah_widgets.dart';
import 'package:komah_project/widgets/state_views.dart';
import 'package:provider/provider.dart';

/// Rute: /alamat
class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar berasal dari repository (bukan data statis).
    final repo = context.watch<AddressRepository>();
    final items = repo.items;
    return Scaffold(
      backgroundColor: AppColors.kmCream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: !repo.isLoaded
                  ? const LoadingView(message: 'Memuat alamat...')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Alamat Favorit', style: AppTextStyles.kmTitle),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Simpan alamat yang sering kamu gunakan agar lebih cepat saat memesan.',
                                    style: AppTextStyles.kmBody,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const PinIllustration(size: 100),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (items.isEmpty)
                          const EmptyView(
                            message: 'Belum ada alamat favorit. Tekan "+ Tambah Alamat" untuk menyimpan alamat pertamamu.',
                            icon: Icons.location_off_rounded,
                          )
                        else
                          for (final a in items) AddressCard(address: a),
                        const SizedBox(height: 8),
                        GradientButton(
                          text: '+ Tambah Alamat',
                          height: AppSpacing.kmButtonHeight,
                          radius: AppSpacing.kmButtonRadius,
                          onPressed: () {
                            // Form dikosongkan sebelum membuka halaman tambah.
                            context.read<AddressFormController>().reset();
                            Navigator.of(context).pushNamed(AppRoutes.alamatTambah);
                          },
                        ),
                        const SizedBox(height: 16),
                        const InfoBox(
                          text: 'Alamat favorit akan tersimpan di akun kamu dan bisa digunakan saat membuat pesanan.',
                        ),
                      ],
                    ),
            ),
            const BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}