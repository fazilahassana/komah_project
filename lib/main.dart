import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/complaint_order_summary.dart';
import 'screens/complaint_form_page.dart';
import 'theme/app_colors.dart';
import 'screens/landing_page.dart';

const _showComplaintPreview = bool.fromEnvironment('SHOW_COMPLAINT_PREVIEW');

void main() {
  runApp(const KomahApp());
}

class KomahApp extends StatelessWidget {
  const KomahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOMAH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brandPurple,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: _showComplaintPreview
          ? const ComplaintFormPage(
              order: ComplaintOrderSummary(
                orderId: '#KM240625001',
                dateTimeLabel: '10 Juni 2026 · 14.30',
                pickup: 'Fakultas Teknik',
                destination: 'Perpustakaan Pusat',
              ),
            )
          : const LandingPage(),
    );
  }
}
