import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Status hasil pengambilan lokasi.
enum LocationStatus { ok, serviceDisabled, denied, deniedForever, error }

class LocationResult {
  const LocationResult(this.status, {this.position});
  final LocationStatus status;
  final LatLng? position;
}

/// Hasil reverse geocoding. [isFallback] true jika hanya berupa teks koordinat.
class ReverseResult {
  const ReverseResult({
    required this.address,
    this.isFallback = false,
    this.networkError = false,
  });
  final String address;
  final bool isFallback;
  final bool networkError;
}

/// Hasil pencarian tempat. [position] null jika tidak ditemukan.
class SearchResult {
  const SearchResult({this.position, this.networkError = false});
  final LatLng? position;
  final bool networkError;
}

class LocationHelper {
  static const _nominatimHost = 'nominatim.openstreetmap.org';
  static const _headers = {'User-Agent': 'KOMah/1.0'};
  static const _timeout = Duration(seconds: 10);

  // Antrean Nominatim: maksimal satu request per detik, aman untuk request bersamaan.
  static Future<void> _tail = Future.value();
  static DateTime _lastRequest = DateTime.fromMillisecondsSinceEpoch(0);

  static Future<T> _throttled<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      final wait = _lastRequest.add(const Duration(seconds: 1)).difference(DateTime.now());
      if (wait > Duration.zero) await Future<void>.delayed(wait);
      try {
        completer.complete(await task());
      } catch (e, s) {
        completer.completeError(e, s);
      } finally {
        _lastRequest = DateTime.now();
      }
    });
    return completer.future;
  }

  static bool _isNetworkError(Object e) =>
      e is SocketException || e is TimeoutException || e is http.ClientException;

  /// Penanganan izin lokasi: cek GPS, minta izin, lalu ambil posisi.
  static Future<LocationResult> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult(LocationStatus.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationStatus.deniedForever);
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult(LocationStatus.denied);
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationResult(LocationStatus.ok, position: LatLng(pos.latitude, pos.longitude));
    } catch (_) {
      return const LocationResult(LocationStatus.error);
    }
  }

  static Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
  static Future<bool> openAppSettings() => Geolocator.openAppSettings();

  static String fallbackText(LatLng p) =>
      '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}';

  /// Reverse geocoding: package geocoding -> Nominatim -> teks koordinat.
  static Future<ReverseResult> reverse(LatLng p) async {
    var network = false;
    try {
      final marks = await geo.placemarkFromCoordinates(
      p.latitude,
      p.longitude,
      );
      if (marks.isNotEmpty) {
        final m = marks.first;
        final parts = <String>[];
        for (final s in [m.street, m.subLocality, m.locality, m.subAdministrativeArea, m.administrativeArea]) {
          final v = s?.trim() ?? '';
          if (v.isNotEmpty && !parts.contains(v)) parts.add(v);
        }
        if (parts.isNotEmpty) return ReverseResult(address: parts.join(', '));
      }
    } catch (e) {
      if (_isNetworkError(e)) network = true;
    }
    try {
      final uri = Uri.https(_nominatimHost, '/reverse', {
        'format': 'jsonv2',
        'lat': '${p.latitude}',
        'lon': '${p.longitude}',
        'accept-language': 'id',
      });
      final res = await _throttled(() => http.get(uri, headers: _headers).timeout(_timeout));
      if (res.statusCode == 200) {
        final name = (jsonDecode(res.body) as Map<String, dynamic>)['display_name'];
        if (name is String && name.trim().isNotEmpty) return ReverseResult(address: name.trim());
      }
    } catch (e) {
      if (_isNetworkError(e)) network = true;
    }
    return ReverseResult(address: fallbackText(p), isFallback: true, networkError: network);
  }

  /// Forward geocoding nama tempat: package geocoding -> Nominatim.
  static Future<SearchResult> search(String query) async {
    var network = false;
    try {
      final list = await geo.locationFromAddress(query);
      if (list.isNotEmpty) {
        return SearchResult(position: LatLng(list.first.latitude, list.first.longitude));
      }
    } catch (e) {
      if (_isNetworkError(e)) network = true;
    }
    try {
      final uri = Uri.https(_nominatimHost, '/search', {
        'q': query,
        'format': 'jsonv2',
        'limit': '1',
        'accept-language': 'id',
      });
      final res = await _throttled(() => http.get(uri, headers: _headers).timeout(_timeout));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final first = data.first as Map<String, dynamic>;
          final lat = double.tryParse('${first['lat']}');
          final lon = double.tryParse('${first['lon']}');
          if (lat != null && lon != null) return SearchResult(position: LatLng(lat, lon));
        }
        return const SearchResult();
      }
    } catch (e) {
      if (_isNetworkError(e)) network = true;
    }
    return SearchResult(networkError: network);
  }
}