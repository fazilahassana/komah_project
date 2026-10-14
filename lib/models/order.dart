// [MODEL] Status alur pembuatan pesanan.
enum OrderStatus { initial, filled, loading, success, error }

// [MODEL] Data pesanan layanan "Antar Orang".
// Immutable: semua field final, dikirim antar layar lewat arguments.
class Order {
  final String service;
  final String pickup;
  final String destination;
  final int passengers;
  final String note;
  final String? orderNumber;  // diisi repository setelah createOrder berhasil
  final DateTime? createdAt;  // waktu pesanan dibuat, diisi repository

  const Order({
    this.service = 'Antar Orang',
    required this.pickup,
    required this.destination,
    this.passengers = 1,
    this.note = '',
    this.orderNumber,
    this.createdAt,
  });

  Order copyWith({String? orderNumber, DateTime? createdAt}) {
    return Order(
      service: service,
      pickup: pickup,
      destination: destination,
      passengers: passengers,
      note: note,
      orderNumber: orderNumber ?? this.orderNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Format tampilan, contoh: "5 Okt 2026, 14.20"
  String get createdAtLabel {
    final d = createdAt;
    if (d == null) return '-';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year}, $hh.$mm';
  }
}