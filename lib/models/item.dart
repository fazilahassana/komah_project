/// Model data utama aplikasi KOMAH.
/// Setiap Item mewakili satu tipe layanan (antar orang, makanan, barang).
class Item {
  final String id;
  final String title;
  final String subtitle;
  final String description;

  const Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}
