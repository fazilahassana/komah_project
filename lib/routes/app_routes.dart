import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/catatan_form_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_page.dart';
import '../screens/not_found_screen.dart';
import '../screens/address_list_screen.dart';
import '../screens/address_form_screen.dart';
import '../screens/map_picker_screen.dart';
import '../screens/save_flow_screens.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String catatanForm = '/catatan-form';
  static const String alamat = '/alamat';
  static const String alamatTambah = '/alamat/tambah';
  static const String alamatPeta = '/alamat/peta';
  static const String alamatMenyimpan = '/alamat/menyimpan';
  static const String alamatBerhasil = '/alamat/berhasil';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case detail:
        final args = settings.arguments;
        if (args is Item) {
          return MaterialPageRoute<void>(
            builder: (_) => DetailScreen(item: args),
            settings: settings,
          );
        }
        return null; // data salah/kosong -> halaman 404
      case catatanForm:
        return MaterialPageRoute<String>(
          builder: (_) => const CatatanFormScreen(),
          settings: settings,
        );
        case alamat:
        return MaterialPageRoute<void>(
          builder: (_) => const AddressListScreen(),
          settings: settings,
        );
      case alamatTambah:
        return MaterialPageRoute<void>(
          builder: (_) => const AddressFormScreen(),
          settings: settings,
        );
      case alamatPeta:
        // Mengembalikan Map {address, latitude, longitude} lewat Navigator.pop.
        return MaterialPageRoute<Object?>(
          builder: (_) => const MapPickerScreen(),
          settings: settings,
        );
      case alamatMenyimpan:
        return MaterialPageRoute<void>(
          builder: (_) => const SavingScreen(),
          settings: settings,
        );
      case alamatBerhasil:
        return MaterialPageRoute<void>(
          builder: (_) => const SaveSuccessScreen(),
          settings: settings,
        );
      default:
        return null; // route tidak terdaftar -> halaman 404
      
      
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => NotFoundScreen(routeName: settings.name),
      settings: settings,
    );
  }
}