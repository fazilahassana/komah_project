import '../models/order.dart';

// [REPOSITORY] Repository dummy: meniru server tanpa backend/Firebase.
class OrderRepository {
  // [REPOSITORY] Singleton: semua layar memakai satu instance yang sama,
  // sehingga daftar pesanan tidak hilang saat pindah layar.
  static final OrderRepository _instance = OrderRepository._();
  factory OrderRepository() => _instance;
  OrderRepository._();

  // Nomor pesanan otomatis: bertambah setiap pesanan dibuat.
  int _counter = 123;

  // [STATE] Penyimpanan di memori. Hilang saat aplikasi ditutup/refresh.
  final List<Order> _orders = [];

  // Pesanan terbaru, atau null jika belum ada pesanan.
  Order? get latestOrder => _orders.isEmpty ? null : _orders.last;

  // [ASYNC/AWAIT] Mengembalikan Future berisi nomor pesanan.
  Future<String> createOrder(Order order) async {
    await Future.delayed(const Duration(seconds: 2));

    // Nomor otomatis, format #KMH + 5 digit, contoh #KMH00123.
    final number = '#KMH${_counter.toString().padLeft(5, '0')}';
    _counter++;

    // [STATE] Simpan pesanan lengkap dengan nomor dan waktu pembuatan.
    _orders.add(order.copyWith(
      orderNumber: number,
      createdAt: DateTime.now(),
    ));

    return number;
  }
}