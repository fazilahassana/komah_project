import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:komah_project/models/favorite_address.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan alamat favorit (SharedPreferences, format JSON).
class AddressRepository extends ChangeNotifier {
  static const _storageKey = 'favorite_addresses_v1';

  final List<FavoriteAddress> _items = [];
  bool _loaded = false;

  /// Daftar read-only agar tidak bisa dimutasi dari luar.
  List<FavoriteAddress> get items => List.unmodifiable(_items);
  bool get isLoaded => _loaded;

  /// Memuat data. Seed hanya dipakai jika penyimpanan belum pernah berisi data.
  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      _items.addAll(FavoriteAddress.seed());
      await prefs.setString(_storageKey, _encode(_items));
    } else {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _items.addAll(
          list.map((e) => FavoriteAddress.fromJson(Map<String, dynamic>.from(e as Map))),
        );
      } catch (_) {
        // Data rusak: dibiarkan kosong, seed tidak ditambahkan ulang.
      }
    }
    _loaded = true;
    notifyListeners();
  }

  /// Penyimpanan asynchronous: state baru dipakai hanya jika tulis berhasil.
  Future<void> add(FavoriteAddress address) async {
    final prefs = await SharedPreferences.getInstance();
    final next = [..._items, address];
    final ok = await prefs.setString(_storageKey, _encode(next));
    if (!ok) throw Exception('Gagal menulis penyimpanan.');
    _items
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  String _encode(List<FavoriteAddress> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());
}

enum FormStatus { initial, filled, loading, success, error }

/// Satu sumber state form agar data tidak hilang saat penyimpanan gagal.
class AddressFormController extends ChangeNotifier {
  final TextEditingController addressText = TextEditingController();
  final TextEditingController detailText = TextEditingController();

  String? _label;
  double? _latitude;
  double? _longitude;
  String? _labelError;
  String? _addressError;
  String? _generalError;
  FormStatus _status = FormStatus.initial;

  String? get label => _label;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get labelError => _labelError;
  String? get addressError => _addressError;
  String? get generalError => _generalError;
  FormStatus get status => _status;

  void setLabel(String? value) {
    _label = value;
    _labelError = null;
    _refreshStatus();
    notifyListeners();
  }

  /// Dipanggil hanya saat pengguna mengetik; koordinat lama dikosongkan.
  void onAddressChanged(String _) {
    final hadError = _addressError != null;
    final hadCoord = _latitude != null || _longitude != null;
    final oldStatus = _status;
    _latitude = null;
    _longitude = null;
    _addressError = null;
    _refreshStatus();
    // Hindari notifikasi berulang jika tidak ada yang berubah.
    if (hadError || hadCoord || oldStatus != _status) notifyListeners();
  }

  /// Hasil map picker: alamat dan koordinat diperbarui bersamaan.
  void applyMapResult(Map result) {
    final address = result['address'];
    final lat = result['latitude'];
    final lng = result['longitude'];
    if (address is! String || lat is! num || lng is! num) return;
    addressText.text = address;
    _latitude = lat.toDouble();
    _longitude = lng.toDouble();
    _addressError = null;
    _refreshStatus();
    notifyListeners();
  }

  /// Validasi memakai fungsi dari Validators; true jika semua valid.
  bool validate(
    String? Function(String?) validateLabel,
    String? Function(String?) validateAlamat,
  ) {
    _labelError = validateLabel(_label);
    _addressError = validateAlamat(addressText.text);
    notifyListeners();
    return _labelError == null && _addressError == null;
  }

  FavoriteAddress buildAddress() => FavoriteAddress(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        label: _label ?? '',
        fullAddress: addressText.text.trim(),
        detail: detailText.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
      );

  void setLoading() {
    _status = FormStatus.loading;
    _generalError = null;
    notifyListeners();
  }

  void setSuccess() {
    _status = FormStatus.success;
    notifyListeners();
  }

  void setError(String message) {
    _status = FormStatus.error;
    _generalError = message;
    notifyListeners();
  }

  void reset() {
    addressText.clear();
    detailText.clear();
    _label = null;
    _latitude = null;
    _longitude = null;
    _labelError = null;
    _addressError = null;
    _generalError = null;
    _status = FormStatus.initial;
    notifyListeners();
  }

  void _refreshStatus() {
    if (_status == FormStatus.loading) return;
    _status = (_label != null && addressText.text.trim().isNotEmpty)
        ? FormStatus.filled
        : FormStatus.initial;
  }

  @override
  void dispose() {
    addressText.dispose();
    detailText.dispose();
    super.dispose();
  }
}