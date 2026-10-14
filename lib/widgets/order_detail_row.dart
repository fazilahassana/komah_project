import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Satu baris detail pesanan: ikon di kiri, label kecil, nilai tebal.
/// [onEdit] opsional: jika diisi, tombol "Ubah" tampil di kanan.
class OrderDetailRow extends StatelessWidget {
  const OrderDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppColors.primary,
    this.onEdit,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.detailLabel),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.detailValue),
              ],
            ),
          ),
          if (onEdit != null)
            OutlinedButton(
              // [INPUT/EVENT] Tombol "Ubah" memicu callback dari layar.
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Ubah',
                style: AppTextStyles.fieldLabel
                    .copyWith(color: AppColors.primary, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}