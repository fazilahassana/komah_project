import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data/address_repository.dart';
import 'routes/app_routes.dart';
import 'theme/app_colors.dart';
import 'screens/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Repository dimuat sebelum UI membaca data.
  final addressRepo = AddressRepository();
  await addressRepo.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AddressRepository>.value(value: addressRepo),
        ChangeNotifierProvider<AddressFormController>(
          create: (_) => AddressFormController(),
        ),
      ],
      child: const KomahApp(),
    ),
  );
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
      // SEMENTARA: langsung buka Alamat Favorit untuk uji. Hapus baris ini setelah selesai.
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}