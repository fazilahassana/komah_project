
class Validators {
  Validators._();

  static String? requiredField(
    String? value, {
    String fieldName = 'Field ini',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  // Validasi label alamat
  static String? validateLabel(String? value) {
    final error = requiredField(value, fieldName: 'Label alamat');
    if (error != null) return '$error.';
    return null;
  }

  // Validasi alamat
  static String? validateAlamat(String? value) {
    final error = requiredField(value, fieldName: 'Alamat');
    if (error != null) return '$error.';
    return null;
  }

  // Validasi email
  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'Email');
    if (requiredError != null) return requiredError;

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Validasi password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  // Validasi panjang karakter minimum
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'Field ini',
  }) {
    final requiredError = requiredField(value, fieldName: fieldName);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < min) {
      return '$fieldName minimal $min karakter';
    }

    return null;
  }

  // Validasi rating 1 sampai 5
  static String? rating(String? value) {
    final requiredError = requiredField(value, fieldName: 'Rating');
    if (requiredError != null) return requiredError;

    final number = int.tryParse(value!.trim());

    if (number == null) {
      return 'Rating harus berupa angka';
    }

    if (number < 1 || number > 5) {
      return 'Rating harus di antara 1 sampai 5';
    }

    return null;
  }
}