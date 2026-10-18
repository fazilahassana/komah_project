/// Model data pengguna KOMah.
/// CATATAN: password disimpan polos HANYA karena ini repository dummy (tugas).
class UserModel {
  const UserModel({
    required this.name,
    required this.identifier,
    required this.password,
  });

  final String name;

  /// Email (huruf kecil) atau nomor HP yang sudah dinormalisasi (08xxxx).
  final String identifier;
  final String password;

  bool get isEmail => identifier.contains('@');
}