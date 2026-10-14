import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routes/app_routes.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const KomahApp());
}

class KomahApp extends StatelessWidget {
  const KomahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOMah',
      debugShowCheckedModeBanner: false,
      // Material 3 dengan warna utama oranye KOMah.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.background,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
      ),
      // [NAVIGATION] Semua perpindahan layar memakai named route.
      initialRoute: AppRoutes.landing,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}