import 'package:flutter/material.dart';

import '../models/complaint_submission_result.dart';
import '../theme/app_colors.dart';

class ComplaintStatusPage extends StatelessWidget {
  final ComplaintSubmissionResult complaint;

  const ComplaintStatusPage({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Status Komplain'),
        backgroundColor: AppColors.brandPurple,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Nomor Komplain',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(complaint.complaintNumber),
          const SizedBox(height: 20),
          Text(
            'Pesanan',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(complaint.order.orderId),
          const SizedBox(height: 20),
          Text(
            'Kategori',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(complaint.category),
          const SizedBox(height: 20),
          Text(
            'Status',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
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
      ),
    );
  }
}
