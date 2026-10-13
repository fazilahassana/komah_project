import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:komah_project/theme/app_colors.dart';
import 'package:komah_project/theme/app_spacing.dart';
import 'package:komah_project/theme/app_text_styles.dart';
import 'package:komah_project/utils/location_helper.dart';
import 'package:komah_project/widgets/gradient_button.dart';
import 'package:komah_project/widgets/komah_widgets.dart';
import 'package:latlong2/latlong.dart';

/// Ganti sesuai application ID Android (android/app/build.gradle).
const String kUserAgentPackageName = 'com.example.komah_project';

const LatLng _kUnand = LatLng(-0.9142, 100.4590);

/// Rute: /alamat/peta. Mengembalikan {address, latitude, longitude}.
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _map = MapController();
  final TextEditingController _search = TextEditingController();

  bool _mapReady = false;
  LatLng? _pendingMove;
  double? _pendingZoom;

  LatLng _center = _kUnand;
  LatLng? _userPos;
  String? _address;
  LatLng? _addressPoint;
  bool _loading = false;
  bool _stale = true; // alamat belum sesuai pin terbaru
  bool _fallback = false;
  bool _searching = false;
  int _requestId = 0; // token agar hasil lama tidak menimpa hasil baru
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _locateUser());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _map.dispose();
    super.dispose();
  }

  void _onMapReady() {
    _mapReady = true;
    final p = _pendingMove;
    if (p != null) {
      _pendingMove = null;
      _map.move(p, _pendingZoom ?? 16);
    }
    _scheduleReverse();
  }

  /// Jangan setState langsung di sini; hanya catat posisi dan jadwalkan debounce.
  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    _center = camera.center;
    _requestId++;
    if (!_stale) {
      _stale = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
    _scheduleReverse();
  }

  /// Debounce 600 ms setelah peta berhenti bergerak.
  void _scheduleReverse() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _reverse);
  }

  Future<void> _reverse() async {
    if (!mounted) return;
    final id = ++_requestId;
    final point = _center;
    setState(() => _loading = true);
    final res = await LocationHelper.reverse(point);
    if (!mounted || id != _requestId) return; // hasil usang diabaikan
    setState(() {
      _address = res.address;
      _addressPoint = point;
      _fallback = res.isFallback;
      _loading = false;
      _stale = false;
    });
  }

  void _moveTo(LatLng p, {double? zoom}) {
    if (!_mapReady) {
      _pendingMove = p;
      _pendingZoom = zoom;
      return;
    }
    _map.move(p, zoom ?? _map.camera.zoom);
  }

  /// Penanganan izin lokasi: tiap status punya pesan/aksi sendiri.
  Future<void> _locateUser() async {
    final res = await LocationHelper.getCurrentPosition();
    if (!mounted) return;
    switch (res.status) {
      case LocationStatus.ok:
        final p = res.position!;
        setState(() => _userPos = p);
        _moveTo(p, zoom: 17);
      case LocationStatus.serviceDisabled:
        showAppSnack(context, 'GPS belum aktif. Aktifkan lokasi untuk memakai posisi kamu.',
            actionLabel: 'Buka Pengaturan', onAction: LocationHelper.openLocationSettings);
      case LocationStatus.denied:
        showAppSnack(context, 'Izin lokasi ditolak. Peta tetap menampilkan area UNAND.');
      case LocationStatus.deniedForever:
        showAppSnack(context, 'Izin lokasi ditolak permanen. Aktifkan lewat pengaturan aplikasi.',
            actionLabel: 'Buka Pengaturan', onAction: LocationHelper.openAppSettings);
      case LocationStatus.error:
        showAppSnack(context, 'Gagal mengambil lokasi. Coba lagi.', isError: true);
    }
  }

  Future<void> _searchPlace() async {
    final q = _search.text.trim();
    if (q.isEmpty || _searching) return;
    FocusScope.of(context).unfocus();
    setState(() => _searching = true);
    final res = await LocationHelper.search(q);
    if (!mounted) return;
    setState(() => _searching = false);
    if (res.position != null) {
      _moveTo(res.position!, zoom: 17);
    } else if (res.networkError) {
      showAppSnack(context, 'Gagal mencari tempat. Periksa koneksi internet kamu.', isError: true);
    } else {
      showAppSnack(context, 'Tempat tidak ditemukan.');
    }
  }

  void _select() {
    final p = _addressPoint;
    if (p == null || _address == null) return;
    Navigator.of(context).pop({'address': _address, 'latitude': p.latitude, 'longitude': p.longitude});
  }

  @override
  Widget build(BuildContext context) {
    final canSelect = !_loading && !_stale && _address != null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: _kUnand,
                    initialZoom: 16,
                    minZoom: 3,
                    maxZoom: 19,
                    onMapReady: _onMapReady,
                    onPositionChanged: _onPositionChanged,
                    onTap: (_, point) => _moveTo(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: kUserAgentPackageName,
                      maxZoom: 19,
                    ),
                    if (_userPos != null)
                      MarkerLayer(markers: [
                        Marker(
                          point: _userPos!,
                          width: 22,
                          height: 22,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                          ),
                        ),
                      ]),
                    // Atribusi berada di area peta, di atas card bawah.
                    const RichAttributionWidget(
                      alignment: AttributionAlignment.bottomLeft,
                      attributions: [TextSourceAttribution('OpenStreetMap contributors')],
                    ),
                  ],
                ),
                // Pin tengah: ujung bawah ikon tepat di titik tengah peta.
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(Icons.location_on_rounded, size: 48, color: AppColors.kmCoral),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Material(
                          color: Colors.white,
                          shape: CircleBorder(),
                          elevation: 3,
                          child: AppBackButton(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(14),
                            child: TextField(
                              controller: _search,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _searchPlace(),
                              style: AppTextStyles.km(),
                              decoration: InputDecoration(
                                hintText: 'Cari nama tempat',
                                hintStyle: AppTextStyles.km(color: AppColors.kmGrey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                                suffixIcon: _searching
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                                      )
                                    : IconButton(icon: const Icon(Icons.search_rounded), onPressed: _searchPlace),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  bottom: 36,
                  child: FloatingActionButton.extended(
                    heroTag: 'lokasi_saya',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.kmNavy,
                    onPressed: _locateUser,
                    icon: const Icon(Icons.my_location_rounded),
                    label: Text('Lokasi Saya', style: AppTextStyles.km(weight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Lokasi dipilih', style: AppTextStyles.km(weight: FontWeight.w800)),
                      const SizedBox(width: 8),
                      if (_loading || _stale)
                        const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.kmCoral)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _address ?? 'Memuat alamat...',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.km(color: AppColors.kmGrey, height: 1.4),
                  ),
                  if (_fallback)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('Alamat tidak ditemukan, memakai koordinat.',
                          style: AppTextStyles.km(size: 11.5, color: AppColors.kmLavenderText)),
                    ),
                  const SizedBox(height: 12),
                  // Nonaktif selama geocoding atau alamat belum sesuai pin terbaru.
                  GradientButton(
                    text: 'Pilih Lokasi Ini',
                    height: AppSpacing.kmButtonHeight,
                    radius: AppSpacing.kmButtonRadius,
                    enabled: canSelect,
                    onPressed: _select,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}