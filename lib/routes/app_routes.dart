import 'package:flutter/material.dart';

import '../screens/landing_page.dart';
import '../screens/login_page.dart';
import '../models/order.dart';
import '../screens/home_screen.dart';
import '../screens/order_confirmation_screen.dart';
import '../screens/order_form_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/processing_screen.dart';
import '../screens/select_service_screen.dart';

// [NAVIGATION] Semua nama route dikumpulkan di satu tempat
// agar tidak ada string yang tercecer di layar.
class AppRoutes {
  AppRoutes._();

  static const String landing = '/landing';
  static const String login = '/login';
  static const String home = '/';
  static const String selectService = '/select-service';
  static const String orderForm = '/order-form';
  static const String orderConfirmation = '/order-confirmation';
  static const String processing = '/processing';
  static const String orderSuccess = '/order-success';

  // [NAVIGATION] Generator route: data dikirim lewat settings.arguments,
  // lalu diteruskan ke layar tujuan.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      
      case landing:
        return _page(const LandingPage(), settings);

      case login:
        return _page(const LoginPage(), settings);
        
      case home:
        return _page(const HomeScreen(), settings);

      case selectService:
        return _page(const SelectServiceScreen(), settings);

      case orderForm:
        // arguments boleh null (form baru) atau Order (form terisi lagi).
        final order = settings.arguments as Order?;
        return _page(OrderFormScreen(initialOrder: order), settings);

      case orderConfirmation:
        final order = settings.arguments as Order;
        return _page(OrderConfirmationScreen(order: order), settings);

      case processing:
        final order = settings.arguments as Order;
        return _page(ProcessingScreen(order: order), settings);

      case orderSuccess:
        // arguments: Order biasa (dari Processing) atau
        // Map {'order': Order, 'fromHome': true} (dari Beranda).
        final args = settings.arguments;
        if (args is Map) {
          return _page(
            OrderSuccessScreen(
              order: args['order'] as Order,
              fromHome: true,
            ),
            settings,
          );
        }
        return _page(OrderSuccessScreen(order: args as Order), settings);;

      default:
        return _page(const HomeScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child, RouteSettings s) {
    return MaterialPageRoute(builder: (_) => child, settings: s);
  }
}