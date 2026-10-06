import 'dart:io';

import 'package:flutter/material.dart';

import '../models/complaint_submission_result.dart';
import '../theme/app_colors.dart';
import 'complaint_status_page.dart';
import 'landing_page.dart';

class ComplaintSuccessPage extends StatelessWidget {
  final ComplaintSubmissionResult complaint;

  const ComplaintSuccessPage({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildOrderSummary(context),
                      const SizedBox(height: 18),
                      _buildComplaintDetails(context),
                      const SizedBox(height: 14),
                      _buildStatus(context),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: FilledButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => ComplaintStatusPage(
                                    complaint: complaint,
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Lihat Status Komplain'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const LandingPage(),
                            ),
                            (_) => false,
                          );
                        },
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            color: AppColors.brandPurple,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 10,
        20,
        38,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF382044), AppColors.brandPurple, Color(0xFF30203F)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildProgressIndicator()),
              const SizedBox(width: 10),
              const Text(
                '4 dari 4',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Komplain Berhasil Dikirim',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Terima kasih telah menyampaikan kendala pada pesanan ini. '
            'Tim kami akan segera memproses komplain kamu.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.86),
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(
        4,
        (index) => Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
            decoration: BoxDecoration(
              color: AppColors.primaryGradientStart,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE8E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, 'Nomor Komplain'),
          const SizedBox(height: 4),
          Text(
            complaint.complaintNumber,
            style: const TextStyle(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _buildLabel(context, 'Pesanan ${complaint.order.orderId}'),
          if (complaint.order.dateTimeLabel case final dateTimeLabel?) ...[
            const SizedBox(height: 3),
            Text(
              dateTimeLabel,
              style: const TextStyle(
                color: Color(0xFF85818A),
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 12),
          _buildLocationRow(
            color: AppColors.primaryGradientStart,
            location: complaint.order.pickup,
          ),
          const SizedBox(height: 8),
          _buildLocationRow(
            color: const Color(0xFF9255E8),
            location: complaint.order.destination,
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE8E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, 'Kategori'),
          const SizedBox(height: 4),
          Text(complaint.category),
          const SizedBox(height: 14),
          _buildLabel(context, 'Deskripsi'),
          const SizedBox(height: 4),
          Text(complaint.description),
          const SizedBox(height: 14),
          _buildLabel(context, 'Bukti Foto'),
          const SizedBox(height: 6),
          if (complaint.photoPath == null)
            const Text(
              'Tidak ada foto bukti',
              style: TextStyle(color: Color(0xFF85818A)),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(complaint.photoPath!),
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 96,
                  height: 96,
                  child: Center(child: Icon(Icons.broken_image_outlined)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Row(
      children: [
        _buildLabel(context, 'Status'),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              complaint.status,
              style: const TextStyle(
                color: AppColors.brandPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.brandPurple,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildLocationRow({
    required Color color,
    required String location,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(
              color: Color(0xFF686372),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
