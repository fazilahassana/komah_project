/// Model alamat favorit. Koordinat boleh null jika alamat diketik manual.
class FavoriteAddress {
  const FavoriteAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.detail = '',
    this.latitude,
    this.longitude,
  });

  final String id;
  final String label;
  final String fullAddress;
  final String detail;
  final double? latitude;
  final double? longitude;

  factory FavoriteAddress.fromJson(Map<String, dynamic> json) {
    return FavoriteAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      detail: (json['detail'] as String?) ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'fullAddress': fullAddress,
        'detail': detail,
        'latitude': latitude,
        'longitude': longitude,
      };

  /// Data awal. Koordinat sengaja null karena belum diverifikasi.
  static List<FavoriteAddress> seed() => const [
        FavoriteAddress(id: 'seed-kos', label: 'Kos', fullAddress: 'Kos FTI UNAND'),
        FavoriteAddress(id: 'seed-kampus', label: 'Kampus', fullAddress: 'Gedung E UNAND'),
        FavoriteAddress(id: 'seed-kantin', label: 'Kantin', fullAddress: 'Kantin Pusat UNAND'),
      ];
}