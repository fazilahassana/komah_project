import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_colors.dart';
import 'screens/landing_page.dart';

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
      home: const LandingPage(),
    );
  }
}
