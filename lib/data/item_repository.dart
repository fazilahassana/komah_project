import '../models/item.dart';

/// Sumber data sementara (dummy).
/// Nanti bisa diganti dengan API/database.
class ItemRepository {
  // Data dummy untuk aplikasi KOMAH
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Antar ke Gedung F',
      subtitle: 'Dari Pintu Gerbang Utama',
      description:
          'Layanan antar mahasiswa dari Pintu Gerbang Utama Universitas Andalas menuju Gedung F. Cocok untuk mahasiswa yang membutuhkan transportasi cepat di area kampus.',
    ),
    Item(
      id: '2',
      title: 'Antar ke Fakultas Teknik',
      subtitle: 'Dari Rusunawa UNAND',
      description:
          'Layanan antar mahasiswa dari area Rusunawa UNAND menuju Fakultas Teknik. Perjalanan dilakukan menggunakan driver KOMAH yang tersedia.',
    ),
    Item(
      id: '3',
      title: 'Antar ke Perpustakaan',
      subtitle: 'Dari Fakultas Teknologi Informasi',
      description:
          'Layanan antar mahasiswa dari Fakultas Teknologi Informasi menuju Perpustakaan Universitas Andalas.',
    ),
    Item(
      id: '4',
      title: 'Antar ke Rektorat',
      subtitle: 'Dari Fakultas Ekonomi dan Bisnis',
      description:
          'Layanan antar mahasiswa dari Fakultas Ekonomi dan Bisnis menuju Gedung Rektorat Universitas Andalas.',
    ),
    Item(
      id: '5',
      title: 'Antar ke Masjid',
      subtitle: 'Dari Fakultas Teknik',
      description:
          'Layanan antar mahasiswa dari Fakultas Teknik menuju masjid di area kampus Universitas Andalas.',
    ),
  ];

  /// Mengambil daftar item.
  /// simulateError: true -> sengaja dibuat gagal untuk menguji error state.
  Future<List<Item>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (simulateError) {
      throw Exception(
        'Gagal memuat data. Periksa koneksi internet.',
      );
    }

    return _items;
  }
}