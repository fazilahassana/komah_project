class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w.\-+]+@[\w\-]+(\.[\w\-]+)+$');
  // 08xxxxxxxx atau 62xxxxxxxx, total 10-13 digit
  static final RegExp _phoneRegex = RegExp(r'^(08|62)\d{8,11}$');
  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s.'\-]+$");

  static String _cleanPhone(String v) => v.replaceAll(RegExp(r'[\s\-+]'), '');

  static bool isEmail(String v) => _emailRegex.hasMatch(v.trim());
  static bool isPhone(String v) => _phoneRegex.hasMatch(_cleanPhone(v));

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nama lengkap wajib diisi.';
    if (v.length < 3) return 'Nama minimal 3 karakter.';
    if (!_nameRegex.hasMatch(v)) return 'Nama hanya boleh berisi huruf.';
    return null;
  }

  static String? identifier(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nomor HP atau email wajib diisi.';
    if (isEmail(v) || isPhone(v)) return null;
    if (v.contains('@')) return 'Format email tidak valid.';
    if (RegExp(r'^[\d\s\-+]+$').hasMatch(v)) {
      return 'Nomor HP tidak valid (contoh: 081234567890).';
    }
    return 'Masukkan email atau nomor HP yang valid.';
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Kata sandi wajib diisi.';
    if (v.length < 8) return 'Kata sandi minimal 8 karakter.';
    if (!RegExp(r'[A-Za-z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
      return 'Kata sandi harus mengandung huruf dan angka.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final v = value ?? '';
    if (v.isEmpty) return 'Verifikasi kata sandi wajib diisi.';
    if (v != original) return 'Kata sandi tidak cocok.';
    return null;
  }
}