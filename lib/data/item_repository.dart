import '../models/item.dart';

class ItemRepository {
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Antar Orang',
      subtitle: 'Antar-jemput mahasiswa di area kampus',
      description: 'Layanan antar-jemput untuk mahasiswa dari titik jemput ke tujuan di sekitar kampus. Isi jumlah penumpang atau catatan tambahan saat memesan.',
    ),
    Item(
      id: '2',
      title: 'Antar Makanan',
      subtitle: 'Titip beli dan antar makanan',
      description: 'Driver membelikan dan mengantar makanan dari tempat pilihanmu. Tulis nama tempat dan isi pesanan pada catatan.',
    ),
    Item(
      id: '3',
      title: 'Antar Barang',
      subtitle: 'Kirim barang antar titik di kampus',
      description: 'Layanan pengiriman barang antar titik di kampus. Jelaskan barang yang dikirim pada catatan.',
    ),
  ];

  Future<List<Item>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}
