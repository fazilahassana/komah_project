import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'camera_screen.dart';

class PaymentProofFlow extends StatefulWidget {
  const PaymentProofFlow({super.key});

  @override
  State<PaymentProofFlow> createState() => _PaymentProofFlowState();
}

class _PaymentProofFlowState extends State<PaymentProofFlow> {
  int _step = 0;

  String? _paymentMethod;

  bool _paymentSuccess = false;

  static const _cream = Color(0xFFFFF8F3);
  static const _navy = Color(0xFF1E2A5A);
  static const _orange = Color(0xFFFF6B35);
  static const _lightOrange = Color(0xFFFF8F66);
  static const _body = Color(0xFF6B7280);
  static const _border = Color(0xFFF1E4DA);
  static const _green = Color(0xFF21875A);

  static const _titles = [
    'Metode Pembayaran',
    'Pembayaran',
    'Konfirmasi Pesanan',
    'Pembayaran Berhasil',
  ];

  static const _subtitles = [
    'Pilih metode pembayaran yang ingin digunakan.',
    'Selesaikan pembayaran sesuai metode yang dipilih.',
    'Periksa kembali detail pesanan sebelum melanjutkan.',
    'Pembayaran kamu telah berhasil diproses.',
  ];

  static const _qrisData = 'KOMAH|PAYMENT|KMH-061026-2841|12000';

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

                    if (_step == 0) _paymentMethodStep(),
                    if (_step == 1) _paymentStep(),
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

  // ============================================================
  // TOP BAR
  // ============================================================

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
                  setState(() {
                    _step--;
                  });
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

  // ============================================================
  // HEADING
  // ============================================================

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

        Text(subtitle, style: _font(size: 13, color: _body, height: 1.5)),
      ],
    );
  }

  // ============================================================
  // STEP 1 - PAYMENT METHOD
  // ============================================================

  Widget _paymentMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderCard(compact: false),

        const SizedBox(height: 20),

        _sectionTitle('Pilih Metode Pembayaran'),

        const SizedBox(height: 10),

        _paymentMethodCard(
          title: 'QRIS',
          subtitle: 'Bayar menggunakan QRIS',
          icon: Icons.qr_code_2_rounded,
          selected: _paymentMethod == 'QRIS',
          onTap: () {
            setState(() {
              _paymentMethod = 'QRIS';
            });
          },
        ),

        const SizedBox(height: 12),

        _paymentMethodCard(
          title: 'Cash / Tunai',
          subtitle: 'Bayar langsung kepada driver',
          icon: Icons.payments_outlined,
          selected: _paymentMethod == 'Cash',
          onTap: () {
            setState(() {
              _paymentMethod = 'Cash';
            });
          },
        ),

        const SizedBox(height: 16),

        if (_paymentMethod == 'QRIS')
          _infoBox(
            'QRIS memungkinkan kamu melakukan '
            'pembayaran secara non-tunai melalui '
            'aplikasi pembayaran yang mendukung QRIS.',
          ),

        if (_paymentMethod == 'Cash')
          _infoBox(
            'Pembayaran dilakukan secara langsung '
            'kepada driver setelah perjalanan selesai.',
          ),
      ],
    );
  }

  // ============================================================
  // PAYMENT METHOD CARD
  // ============================================================

  Widget _paymentMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF0E8) : Colors.white,
            border: Border.all(
              color: selected ? _orange : _border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0851331F),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFFFE6D9)
                      : const Color(0xFFFFF3EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _orange, size: 25),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _font(
                        size: 14,
                        weight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(subtitle, style: _font(size: 10.5, color: _body)),
                  ],
                ),
              ),

              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? _orange : const Color(0xFFD8CCC5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STEP 2 - PAYMENT
  // ============================================================

  Widget _paymentStep() {
    if (_paymentMethod == 'Cash') {
      return _cashPaymentStep();
    }

    return _qrisPaymentStep();
  }

  // ============================================================
  // QRIS
  // ============================================================

  Widget _qrisPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderCard(compact: true),

        const SizedBox(height: 20),

        _sectionTitle('Pembayaran QRIS'),

        const SizedBox(height: 10),

        _card(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text(
                'Scan QR Code berikut',
                style: _font(size: 14, weight: FontWeight.w800, color: _navy),
              ),

              const SizedBox(height: 6),

              Text(
                'Gunakan aplikasi pembayaran '
                'yang mendukung QRIS.',
                textAlign: TextAlign.center,
                style: _font(size: 11, color: _body, height: 1.4),
              ),

              const SizedBox(height: 18),

              Container(
                width: 230,
                height: 230,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x142B1B11),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: _qrisData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  gapless: false,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Rp 12.000',
                style: _font(size: 23, weight: FontWeight.w800, color: _navy),
              ),

              const SizedBox(height: 4),

              Text('KOMah Reguler', style: _font(size: 11, color: _body)),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _scanQr,
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 19),
                  label: Text(
                    'Scan QR',
                    style: _font(
                      size: 13,
                      weight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _navy,
                    side: const BorderSide(color: _navy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _markQrisAsPaid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    'Saya Sudah Bayar',
                    style: _font(
                      size: 13,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        if (_paymentSuccess) _successPaymentBox(),
      ],
    );
  }

  // ============================================================
  // CASH
  // ============================================================

  Widget _cashPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _orderCard(compact: true),

        const SizedBox(height: 20),

        _sectionTitle('Pembayaran Cash / Tunai'),

        const SizedBox(height: 10),

        _card(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: _orange,
                  size: 38,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Bayar langsung kepada driver',
                textAlign: TextAlign.center,
                style: _font(size: 16, weight: FontWeight.w800, color: _navy),
              ),

              const SizedBox(height: 8),

              Text(
                'Tidak perlu mengunggah bukti pembayaran. '
                'Siapkan uang tunai sebesar total pembayaran '
                'dan berikan kepada driver.',
                textAlign: TextAlign.center,
                style: _font(size: 11, color: _body, height: 1.5),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4ED),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: _orange,
                      size: 20,
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Text(
                        'Total yang perlu dibayarkan',
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SCAN QR
  // ============================================================

  Future<void> _scanQr() async {
    final result = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => const CameraScreen()));

    if (!mounted || result == null) {
      return;
    }

    if (result == _qrisData) {
      _markQrisAsPaid();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code tidak sesuai dengan pembayaran KOMah.'),
      ),
    );
  }

  // ============================================================
  // QRIS PAYMENT SUCCESS
  // ============================================================

  void _markQrisAsPaid() {
    setState(() {
      _paymentSuccess = true;
    });
  }

  Widget _successPaymentBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBCE7CF)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: _green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran Berhasil',
                  style: _font(
                    size: 13,
                    weight: FontWeight.w800,
                    color: _green,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Pembayaran QRIS telah dikonfirmasi.',
                  style: _font(size: 10.5, color: _body),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 3 - CONFIRMATION
  // ============================================================

  Widget _confirmationStep() {
    final isCash = _paymentMethod == 'Cash';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCash
                      ? const Color(0xFFFFF0E8)
                      : const Color(0xFFE8F7EF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isCash
                      ? Icons.payments_outlined
                      : Icons.check_circle_outline_rounded,
                  color: isCash ? _orange : _green,
                  size: 27,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCash ? 'Cash / Tunai' : 'QRIS',
                      style: _font(
                        size: 14,
                        weight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      isCash
                          ? 'Pembayaran kepada driver'
                          : 'Pembayaran berhasil',
                      style: _font(size: 10.5, color: _body),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        _sectionTitle('Detail Pesanan'),

        const SizedBox(height: 10),

        _orderCard(compact: true, showPayment: true),

        const SizedBox(height: 18),

        _sectionTitle('Metode Pembayaran'),

        const SizedBox(height: 10),

        _paymentSummaryCard(),

        const SizedBox(height: 14),

        _infoBox(
          isCash
              ? 'Dengan memilih konfirmasi, kamu menyetujui '
                    'bahwa pembayaran akan dilakukan langsung '
                    'kepada driver.'
              : 'Pembayaran QRIS telah berhasil. '
                    'Periksa kembali detail pesanan sebelum '
                    'melanjutkan.',
        ),
      ],
    );
  }

  Widget _paymentSummaryCard() {
    final isCash = _paymentMethod == 'Cash';

    return _card(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCash ? Icons.payments_outlined : Icons.qr_code_2_rounded,
              color: _orange,
              size: 24,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCash ? 'Cash / Tunai' : 'QRIS',
                  style: _font(size: 13, weight: FontWeight.w800, color: _navy),
                ),

                const SizedBox(height: 3),

                Text(
                  isCash ? 'Bayar kepada driver' : 'Pembayaran non-tunai',
                  style: _font(size: 10, color: _body),
                ),
              ],
            ),
          ),

          Text(
            'Rp 12.000',
            style: _font(size: 13, weight: FontWeight.w800, color: _navy),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP 4 - SUCCESS
  // ============================================================

  Widget _successStep() {
    final isCash = _paymentMethod == 'Cash';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _successIllustration(isCash: isCash),

        const SizedBox(height: 20),

        _sectionTitle('Detail Pesanan'),

        const SizedBox(height: 10),

        _orderCard(compact: true, showPayment: true),

        const SizedBox(height: 16),

        _sectionTitle('Metode Pembayaran'),

        const SizedBox(height: 9),

        _paymentSummaryCard(),

        const SizedBox(height: 16),

        if (isCash)
          _infoBox(
            'Pembayaran cash akan dikonfirmasi '
            'oleh driver setelah uang diterima.',
          )
        else
          _infoBox(
            'Pembayaran QRIS telah berhasil '
            'dan tidak memerlukan upload bukti pembayaran.',
          ),
      ],
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

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
                  style: _font(size: 13, weight: FontWeight.w800, color: _navy),
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

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _paymentSuccess
            ? const Color(0xFFE5F6EC)
            : const Color(0xFFFFE8DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _paymentSuccess ? 'Pembayaran Berhasil' : 'Menunggu Pembayaran',
        style: _font(
          size: 9.5,
          weight: FontWeight.w700,
          color: _paymentSuccess ? _green : _orange,
        ),
      ),
    );
  }

  // ============================================================
  // SUCCESS ILLUSTRATION
  // ============================================================

  Widget _successIllustration({required bool isCash}) {
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
            child: Icon(
              Icons.stars_rounded,
              color: _orange.withValues(alpha: .45),
              size: 22,
            ),
          ),

          Positioned(
            right: 51,
            top: 32,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: _orange.withValues(alpha: .55),
              size: 18,
            ),
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
            bottom: 25,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: _green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(
                isCash ? Icons.payments_rounded : Icons.check_rounded,
                color: Colors.white,
                size: 48,
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
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO BOX
  // ============================================================

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
            child: Text(
              message,
              style: _font(size: 10.5, color: _navy, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: _font(size: 14, weight: FontWeight.w800, color: _navy),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0851331F),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _bottomAction() {
    final String label;

    if (_step == 0) {
      label = 'Lanjutkan';
    } else if (_step == 1) {
      label = _paymentMethod == 'Cash' ? 'Konfirmasi Pembayaran' : 'Lanjutkan';
    } else if (_step == 2) {
      label = 'Konfirmasi Pesanan';
    } else {
      label = 'Kembali ke Layanan Pesanan';
    }

    bool canContinue = false;

    if (_step == 0) {
      canContinue = _paymentMethod != null;
    } else if (_step == 1) {
      if (_paymentMethod == 'Cash') {
        canContinue = true;
      } else {
        canContinue = _paymentSuccess;
      }
    } else if (_step == 2) {
      canContinue = true;
    } else {
      canContinue = true;
    }

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
            gradient: LinearGradient(
              colors: canContinue
                  ? const [_orange, _lightOrange]
                  : const [Color(0xFFD6C8C0), Color(0xFFE0D5CF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: canContinue
                ? const [
                    BoxShadow(
                      color: Color(0x33FF6B35),
                      blurRadius: 13,
                      offset: Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: canContinue ? _advance : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: _font(
                    size: 14,
                    weight: FontWeight.w800,
                    color: canContinue ? Colors.white : _body,
                  ),
                ),

                if (_step == 1 || _step == 2) ...[
                  const SizedBox(width: 7),

                  Icon(
                    Icons.arrow_forward_rounded,
                    color: canContinue ? Colors.white : _body,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FLOW
  // ============================================================

  void _advance() {
    if (_step == 0) {
      setState(() {
        _step = 1;

        if (_paymentMethod == 'Cash') {
          _paymentSuccess = false;
        }
      });

      return;
    }

    if (_step == 1) {
      setState(() {
        _step = 2;
      });

      return;
    }

    if (_step == 2) {
      setState(() {
        _step = 3;
      });

      return;
    }

    setState(() {
      _step = 0;
      _paymentMethod = null;
      _paymentSuccess = false;
    });
  }

  // ============================================================
  // FONT
  // ============================================================

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
}
