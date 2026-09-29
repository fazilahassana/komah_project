import '../models/item.dart';

/// Repository data sementara (dummy).
/// Nantinya bisa diganti dengan API atau database.
class ItemRepository {
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Antar Jemput Mahasiswa',
      subtitle: 'Layanan antar jemput di area kampus',
      description:
          'Layanan ojek kampus untuk mengantar dan menjemput mahasiswa di area Universitas Andalas.',
    ),
    Item(
      id: '2',
      title: 'Antar Barang',
      subtitle: 'Kirim barang di sekitar kampus',
      description:
          'Layanan pengantaran barang untuk kebutuhan mahasiswa di sekitar area kampus.',
    ),
    Item(
      id: '3',
      title: 'Pesan Makanan',
      subtitle: 'Titip beli makanan sekitar kampus',
      description:
          'Layanan titip beli makanan dari kantin atau tempat makan yang berada di sekitar kampus.',
    ),
    Item(
      id: '4',
      title: 'Jemput dari Gerbang',
      subtitle: 'Jemput mahasiswa dari gerbang kampus',
      description:
          'Pesan pengemudi untuk menjemput dari gerbang utama atau lokasi tertentu di area kampus.',
    ),
    Item(
      id: '5',
      title: 'Antar ke Kos',
      subtitle: 'Antar mahasiswa ke kos',
      description:
          'Layanan antar mahasiswa dari kampus menuju kos atau tempat tinggal di sekitar kampus.',
    ),
  ];

  Future<List<Item>> fetchItems({
    bool simulateError = false,
  }) async {
    // Simulasi proses mengambil data dari server.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    // Simulasi error jika diperlukan.
    if (simulateError) {
      throw Exception('Gagal mengambil data.');
    }

    return _items;
  }
}