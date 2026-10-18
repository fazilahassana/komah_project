import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/komah_logo.dart';

/// Splash Screen KOMah: tampil 3 detik lalu pindah ke Onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // [NAVIGATION] Ganti splash dengan onboarding (splash tidak bisa di-back)
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar ilustrasi (fallback gradient jika asset belum ada)
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB58BD1), Color(0xFFFFA36B)],
                ),
              ),
            ),
          ),

          // Logo + tagline dengan efek fade-in
          SafeArea(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) =>
                  Opacity(opacity: value, child: child),
              child: const Padding(
                padding: EdgeInsets.only(top: 90),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      KomahLogo(),
                      SizedBox(height: 6),
                      Text(
                        'KAMPUS LEBIH DEKAT, SETIAP SAAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}