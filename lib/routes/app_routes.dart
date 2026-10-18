import 'package:flutter/material.dart';
import '../screens/splash_page.dart';
import '../screens/onboarding_page.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/home_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashPage(),
        onboarding: (_) => const OnboardingPage(),
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        home: (_) => const HomePage(),
      };
}