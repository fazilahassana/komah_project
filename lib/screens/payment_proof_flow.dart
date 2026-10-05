import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentProofFlow extends StatefulWidget {
  const PaymentProofFlow({super.key});

  @override
  State<PaymentProofFlow> createState() => _PaymentProofFlowState();
}

class _PaymentProofFlowState extends State<PaymentProofFlow> {
  int _step = 0;
  bool _cameraSelected = true;
  bool _photoVisible = true;

  static const _cream = Color(0xFFFFF8F3);
  static const _navy = Color(0xFF1E2A5A);
  static const _orange = Color(0xFFFF6B35);
  static const _lightOrange = Color(0xFFFF8F66);
  static const _body = Color(0xFF6B7280);
  static const _border = Color(0xFFF1E4DA);
  static const _green = Color(0xFF21875A);

  static const _titles = [
    'Bukti Pembayaran',
    'Unggah Bukti Pembayaran',
    'Konfirmasi Bukti Pembayaran',
    'Bukti Pembayaran Berhasil',
  ];

  static const _subtitles = [
    'Unggah bukti pembayaran untuk menyelesaikan pesanan.',
    'Pilih sumber foto untuk mengunggah bukti pembayaran.',
    'Periksa foto bukti pembayaran sudah jelas dan sesuai.',
    'Bukti pembayaran kamu telah berhasil dikirim dan sedang diverifikasi.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heading(_titles[_step], _subtitles[_step]),
                    const SizedBox(height: 20),
                    if (_step == 0) _firstStep(),
                    if (_step == 1) _uploadStep(),
                    if (_step == 2) _confirmationStep(),
                    if (_step == 3) _successStep(),
                  ],
                ),
              ),
            ),
            _bottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 22, 0),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Kembali',
              onPressed: () {
                if (_step > 0) {
                  setState(() => _step--);
                }
              },
              icon: const Icon(Icons.arrow_back_rounded, color: _navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: List.generate(4, (index) {
                  final active = index <= _step;
                  return Expanded(
                    child: Container(
                      height: 5,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 7),
                      decoration: BoxDecoration(
                        color: active ? _orange : const Color(0xFFE9DED7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _font(
            size: 22,
            weight: FontWeight.w800,
            color: _navy,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: _font(size: 13, color: _body, height: 1.5),
        ),
      ],
    );
  }

  Widget _firstStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderCard(compact: false),
        const SizedBox(height: 16),
        _totalPayment(),
        const SizedBox(height: 20),
        _sectionTitle('Metode Pembayaran'),
        const SizedBox(height: 10),
        _paymentCard(expanded: true),
        const SizedBox(height: 12),
        _infoBox(
          'Pastikan nominal pembayaran pada bukti pembayaran sesuai dengan total pesanan.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Unggah Bukti Pembayaran'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _sourceCard(
                camera: true,
                selected: false,
                firstScreen: true,
                onTap: () => _openUpload(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _sourceCard(
                camera: false,
                selected: false,
                firstScreen: true,
                onTap: () => _openUpload(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _uploadStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderCard(compact: true),
        const SizedBox(height: 20),
        _sectionTitle('Pilih Sumber Foto'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _sourceCard(
                camera: true,
                selected: _cameraSelected,
                onTap: () => setState(() {
                  _cameraSelected = true;
                  _photoVisible = true;
                }),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _sourceCard(
                camera: false,
                selected: !_cameraSelected,
                onTap: () => setState(() {
                  _cameraSelected = false;
                  _photoVisible = true;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _sectionTitle('Pratinjau Foto'),
        const SizedBox(height: 10),
        _photoVisible
            ? _receiptPreview(height: 226, removable: true)
            : _emptyPhoto(),
      ],
    );
  }

  Widget _confirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _photoVisible
            ? _receiptPreview(height: 204, removable: true, downloadable: true)
            : _emptyPhoto(),
        const SizedBox(height: 20),
        _sectionTitle('Detail Pesanan'),
        const SizedBox(height: 10),
        _orderCard(compact: true, showPayment: true),
        const SizedBox(height: 18),
        _sectionTitle('Metode Pembayaran'),
        const SizedBox(height: 10),
        _paymentCard(expanded: false),
        const SizedBox(height: 12),
        _infoBox(
          'Pastikan foto bukti pembayaran terlihat jelas dan dapat dibaca dengan baik.',
        ),
      ],
    );
  }

  Widget _successStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _successIllustration(),
        const SizedBox(height: 20),
        _sectionTitle('Detail Pesanan'),
        const SizedBox(height: 10),
        _orderCard(compact: true, showPayment: true),
        const SizedBox(height: 16),
        _sectionTitle('Metode Pembayaran'),
        const SizedBox(height: 9),
        _paymentCard(expanded: false),
        const SizedBox(height: 16),
        _sectionTitle('Bukti Pembayaran'),
        const SizedBox(height: 9),
        _transactionCard(),
      ],
    );
  }

  Widget _orderCard({required bool compact, bool showPayment = false}) {
    return _card(
      padding: EdgeInsets.all(compact ? 13 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 36 : 42,
                height: compact ? 36 : 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEE6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.two_wheeler_rounded,
                  color: _orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KOMah Reguler',
                      style: _font(
                        size: 14,
                        weight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Asrama FTI UNAND → Kampus UNAND',
                      style: _font(size: 10.5, color: _body),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sen, 6 Okt 2026 · 10:15 WIB',
                      style: _font(size: 10.5, color: _body),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (compact || showPayment) ...[
            const SizedBox(height: 11),
            const Divider(height: 1, color: _border),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Pembayaran',
                    style: _font(size: 11, color: _body),
                  ),
                ),
                Text(
                  'Rp 12.000',
                  style: _font(
                    size: 13,
                    weight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _statusBadge(),
          ],
        ],
      ),
    );
  }

  Widget _totalPayment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Pembayaran', style: _font(size: 12, color: _body)),
              const SizedBox(height: 2),
              Text(
                'Rp 12.000',
                style: _font(size: 24, weight: FontWeight.w800, color: _navy),
              ),
            ],
          ),
        ),
        _statusBadge(),
      ],
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Menunggu Pembayaran',
        style: _font(size: 9.5, weight: FontWeight.w700, color: _orange),
      ),
    );
  }

  Widget _paymentCard({required bool expanded}) {
    return _card(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E8),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.qr_code_2_rounded, color: _orange, size: 23),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QRIS',
                  style: _font(size: 13, weight: FontWeight.w700, color: _navy),
                ),
                if (expanded) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Pembayaran dilakukan dengan scan QR Code',
                    style: _font(size: 10.5, color: _body),
                  ),
                ],
              ],
            ),
          ),
          if (expanded)
            const Icon(Icons.chevron_right_rounded, color: _body, size: 22),
        ],
      ),
    );
  }

  Widget _sourceCard({
    required bool camera,
    required bool selected,
    required VoidCallback onTap,
    bool firstScreen = false,
  }) {
    final title = camera ? 'Ambil Foto' : 'Pilih dari Galeri';
    final description = camera
        ? 'Gunakan kamera untuk mengambil foto'
        : 'Unggah foto atau screenshot dari galeri';
    final icon = camera ? Icons.photo_camera_outlined : Icons.photo_library_outlined;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: firstScreen ? 143 : 94,
        padding: EdgeInsets.all(firstScreen ? 12 : 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0E8) : Colors.white,
          border: Border.all(
            color: selected ? _orange : _border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Color(0x0A51331F), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: selected
                  ? const Icon(Icons.check_circle_rounded, color: _orange, size: 18)
                  : const SizedBox(width: 18, height: 18),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: selected ? _orange : _navy, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: _font(
                      size: firstScreen ? 11.5 : 11,
                      weight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                  if (firstScreen) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _font(size: 9, color: _body, height: 1.35),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptPreview({
    required double height,
    bool removable = false,
    bool downloadable = false,
  }) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEE5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Container(
                  width: 182,
                  padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x142B1B11),
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'KOMah',
                        style: _font(size: 13, weight: FontWeight.w800, color: _navy),
                      ),
                      Text(
                        'BUKTI PEMBAYARAN',
                        style: _font(size: 7, weight: FontWeight.w700, color: _body),
                      ),
                      const SizedBox(height: 6),
                      const SizedBox(width: 66, height: 66, child: CustomPaint(painter: _QrPainter())),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F6EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pembayaran Berhasil',
                          style: _font(size: 7, weight: FontWeight.w700, color: _green),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp 12.000  ·  QRIS',
                        style: _font(size: 8, weight: FontWeight.w700, color: _navy),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (removable)
            Positioned(
              top: 9,
              right: 9,
              child: _roundPhotoAction(
                icon: Icons.close_rounded,
                label: 'Hapus foto',
                onTap: () => setState(() => _photoVisible = false),
              ),
            ),
          if (downloadable)
            Positioned(
              right: 10,
              bottom: 10,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 15),
                label: Text('Unduh', style: _font(size: 10, weight: FontWeight.w700)),
                style: TextButton.styleFrom(
                  foregroundColor: _navy,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _roundPhotoAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Tooltip(
            message: label,
            child: Icon(icon, color: _navy, size: 17),
          ),
        ),
      ),
    );
  }

  Widget _emptyPhoto() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Foto bukti pembayaran belum dipilih',
          style: _font(size: 12, color: _body),
        ),
      ),
    );
  }

  Widget _successIllustration() {
    return Container(
      height: 174,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8DA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 38,
            top: 23,
            child: Icon(Icons.stars_rounded, color: _orange.withValues(alpha: .45), size: 22),
          ),
          Positioned(
            right: 51,
            top: 32,
            child: Icon(Icons.auto_awesome_rounded, color: _orange.withValues(alpha: .55), size: 18),
          ),
          Container(
            width: 124,
            height: 124,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7F0),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            bottom: 8,
            child: Container(
              width: 104,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9A70),
                borderRadius: BorderRadius.circular(48).copyWith(
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
              ),
              child: const Icon(Icons.person_rounded, size: 68, color: Colors.white),
            ),
          ),
          Positioned(
            top: 28,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF3D2940),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.face_3_rounded, color: Color(0xFFFFD1AE), size: 48),
            ),
          ),
          Positioned(
            right: 93,
            bottom: 39,
            child: Transform.rotate(
              angle: -.12,
              child: Container(
                width: 24,
                height: 39,
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
              ),
            ),
          ),
          Positioned(
            right: 62,
            top: 23,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 23),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionCard() {
    return _card(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 72,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3EC),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const CustomPaint(painter: _QrPainter()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailLine('Tanggal', '6 Okt 2026'),
                _detailLine('Waktu', '10:15 WIB'),
                _detailLine('ID Transaksi', 'KMH-061026-2841'),
                _detailLine('Nominal', 'Rp 12.000', strong: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLine(String label, String value, {bool strong = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _font(size: 9, color: _body))),
          Text(
            value,
            style: _font(
              size: 9,
              weight: strong ? FontWeight.w800 : FontWeight.w600,
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE5),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: _font(size: 10.5, color: _navy, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: _font(size: 14, weight: FontWeight.w800, color: _navy),
    );
  }

  Widget _card({required Widget child, EdgeInsets padding = const EdgeInsets.all(14)}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0851331F), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _bottomAction() {
    final labels = [
      'Lanjutkan',
      'Lanjutkan',
      'Konfirmasi Bukti Pembayaran',
      'Kembali ke Layanan Pesanan',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      decoration: const BoxDecoration(
        color: _cream,
        border: Border(top: BorderSide(color: Color(0x16A76C4C))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_orange, _lightOrange]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x33FF6B35), blurRadius: 13, offset: Offset(0, 5)),
            ],
          ),
          child: ElevatedButton(
            onPressed: _advance,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  labels[_step],
                  style: _font(size: 14, weight: FontWeight.w800, color: Colors.white),
                ),
                if (_step == 1 || _step == 2) ...[
                  const SizedBox(width: 7),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _font({
    required double size,
    Color color = _navy,
    FontWeight weight = FontWeight.w500,
    double height = 1.25,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
    );
  }

  void _openUpload(bool camera) {
    setState(() {
      _cameraSelected = camera;
      _photoVisible = true;
      _step = 1;
    });
  }

  void _advance() {
    setState(() {
      if (_step == 3) {
        _step = 0;
        _cameraSelected = true;
        _photoVisible = true;
      } else {
        _step++;
        if (_step == 1) _photoVisible = true;
      }
    });
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final module = size.width / 21;
    final ink = Paint()..color = const Color(0xFF202B36);
    final paper = Paint()..color = Colors.white;
    for (var row = 0; row < 21; row++) {
      for (var column = 0; column < 21; column++) {
        final finder = _finderModule(row, column);
        final filled = finder ?? ((row * row + column * 7 + row * column) % 5 < 2);
        if (finder == false) continue;
        canvas.drawRect(
          Rect.fromLTWH(column * module, row * module, module + .15, module + .15),
          filled ? ink : paper,
        );
      }
    }
  }

  bool? _finderModule(int row, int column) {
    for (final origin in const [(0, 0), (0, 14), (14, 0)]) {
      final localRow = row - origin.$1;
      final localColumn = column - origin.$2;
      if (localRow < 0 || localRow > 6 || localColumn < 0 || localColumn > 6) {
        continue;
      }
      final edge = localRow == 0 || localRow == 6 || localColumn == 0 || localColumn == 6;
      final center = localRow >= 2 && localRow <= 4 && localColumn >= 2 && localColumn <= 4;
      return edge || center;
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => false;
}