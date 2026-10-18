import '../models/user_model.dart';

/// [STATE] Status proses autentikasi.
enum AuthStatus { initial, loading, success, error }

/// Exception khusus agar pesan error bisa langsung ditampilkan ke pengguna.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Repository dummy (tanpa backend). Data disimpan di memori.
class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  // Akun contoh: yaya@komah.com atau 081234567890, sandi: komah123
  final List<UserModel> _users = [
    const UserModel(
      name: 'Yaya',
      identifier: 'yaya@komah.com',
      password: 'komah123',
    ),
    const UserModel(
      name: 'Yaya',
      identifier: '081234567890',
      password: 'komah123',
    ),
  ];

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  /// Samakan format input: email -> huruf kecil, HP -> 08xxxx.
  static String normalizeIdentifier(String raw) {
    var value = raw.trim().toLowerCase();
    if (value.contains('@')) return value;
    value = value.replaceAll(RegExp(r'[\s\-+]'), '');
    if (value.startsWith('62')) value = '0${value.substring(2)}';
    return value;
  }

  /// Simulasi login (delay 2 detik seperti request jaringan).
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final id = normalizeIdentifier(identifier);
    final matches = _users.where(
      (u) => u.identifier == id && u.password == password,
    );

    if (matches.isEmpty) {
      throw const AuthException('Email/nomor HP atau kata sandi salah.');
    }

    _currentUser = matches.first;
    return _currentUser!;
  }

  /// Simulasi registrasi.
  Future<UserModel> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final id = normalizeIdentifier(identifier);
    if (_users.any((u) => u.identifier == id)) {
      throw AuthException(
        id.contains('@')
            ? 'Email sudah terdaftar.'
            : 'Nomor HP sudah terdaftar.',
      );
    }

    final user = UserModel(
      name: name.trim(),
      identifier: id,
      password: password,
    );
    _users.add(user);
    return user;
  }

  void logout() => _currentUser = null;
}