import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/gradient_button.dart';

const _cream = Color(0xFFFFF7F3);
const _lavender = Color(0xFFFAF8FF);
const _lavenderCard = Color(0xFFF1EEFC);
const _dotInactive = Color(0xFFDCD7F5);
const _ink = Color(0xFF1E1B2E);

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;
  static const int _lastIndex = 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // [NAVIGATION] Ke login (onboarding tetap di stack agar tombol back kembali)
  void _goToLogin() => Navigator.pushNamed(context, AppRoutes.login);

  void _next() {
    if (_index == _lastIndex) {
      _goToLogin();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _previous() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _index == 0 ? _cream : _lavender,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: tombol kembali + Lewati ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _index == 0
                      ? const SizedBox(width: 44, height: 44)
                      : InkWell(
                          onTap: _previous,
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDE8FB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: AppColors.brandPurple,
                            ),
                          ),
                        ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      'Lewati',
                      style: AppTextStyles.inputLabel.copyWith(
                        color: AppColors.brandPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Slide ──
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _HeroSlide(),
                  _ServicesSlide(),
                  _TrackingSlide(),
                ],
              ),
            ),

            // ── Indikator titik ──
            _Dots(current: _index, count: 3),
            const SizedBox(height: 24),

            // ── Tombol utama ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GradientButton(
                text: _index == _lastIndex ? 'Mulai Sekarang  →' : 'Lanjutkan  →',
                textStyle: AppTextStyles.buttonTextLanding,
                onPressed: _next,
              ),
            ),
            const SizedBox(height: 16),

            // ── Link "Sudah punya akun?" (hanya slide 1) ──
            Visibility(
              visible: _index == 0,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: GestureDetector(
                onTap: _goToLogin,
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.linkText.copyWith(fontSize: 14),
                    children: [
                      const TextSpan(text: 'Sudah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: AppTextStyles.linkText.copyWith(
                          fontSize: 14,
                          color: AppColors.brandPurple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ════════════════════ Indikator titik ════════════════════
class _Dots extends StatelessWidget {
  const _Dots({required this.current, required this.count});

  final int current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: active ? AppColors.accent : _dotInactive,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}

// ════════════════════ Slide 1: Hero ════════════════════
class _HeroSlide extends StatelessWidget {
  const _HeroSlide();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: AppTextStyles.headline.copyWith(fontSize: 26, height: 1.4),
              children: const [
                TextSpan(
                  text: 'Antar - Jemput kuliah, harganya ramah di kantong ',
                ),
                TextSpan(
                  text: 'anak kos.',
                  style: TextStyle(color: AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Driver KOMah mahasiswa juga ngerti jadwal kelas, '
            'ngerti isi dompet kamu.',
            style: AppTextStyles.bodyDescription.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/hero_landing.png',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 280,
                    color: const Color(0xFF2D1B33),
                    child: const Icon(
                      Icons.two_wheeler,
                      size: 80,
                      color: AppColors.primaryGradientStart,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.accent,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '100% Teman Kampus',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.savings_outlined,
                          color: Color(0xFFB3261E),
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mulai dari',
                              style: TextStyle(fontSize: 11, color: _ink),
                            ),
                            Text(
                              'Rp 5.000',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFB3261E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ════════════════════ Slide 2: Layanan ════════════════════
class _ServiceItem {
  const _ServiceItem(
    this.icon,
    this.iconBg,
    this.iconColor,
    this.title,
    this.subtitle,
    this.badge,
    this.badgeBg,
    this.badgeColor,
  );

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;
}

class _ServicesSlide extends StatelessWidget {
  const _ServicesSlide();

  static const _items = [
    _ServiceItem(
      Icons.two_wheeler,
      Color(0xFFFFD9D0),
      Color(0xFFB3261E),
      'Antar Orang',
      'Ke kelas, kos, dll',
      'Kilat',
      Color(0xFFEDE8FB),
      AppColors.brandPurple,
    ),
    _ServiceItem(
      Icons.lunch_dining,
      Color(0xFFFFE2C2),
      Color(0xFFD97706),
      'Antar Makanan',
      'Dari kantin/kafe',
      'Favorit',
      Color(0xFFFFD9D0),
      Color(0xFFC0392B),
    ),
    _ServiceItem(
      Icons.inventory_2_outlined,
      Color(0xFFE4DBFB),
      AppColors.brandPurple,
      'Antar Barang',
      'Dokumen, paket, dll',
      'Aman',
      Color(0xFFEDE8FB),
      AppColors.brandPurple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Kartu daftar layanan
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _lavenderCard,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: _items.map((item) => _ServiceTile(item: item)).toList(),
            ),
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.headline.copyWith(
                fontSize: 26,
                height: 1.35,
                color: _ink,
              ),
              children: const [
                TextSpan(text: 'Satu aplikasi untuk\n'),
                TextSpan(
                  text: 'semua',
                  style: TextStyle(color: AppColors.accent),
                ),
                TextSpan(text: ' kebutuhan\nkampus'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pilih layanan, tentukan lokasi, dan temukan driver yang tersedia.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyDescription.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _ink.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _InfoChip(icon: Icons.bolt, label: 'Driver Mahasiswa'),
              _InfoChip(icon: Icons.savings_outlined, label: 'Tarif Sahabat Kost'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.item});

  final _ServiceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: item.iconBg,
            child: Icon(item.icon, color: item.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: _ink.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.badge,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: item.badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFB3261E)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.brandPurple,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════ Slide 3: Pantau real-time ════════════════════
class _TrackingSlide extends StatelessWidget {
  const _TrackingSlide();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // ── "Peta" ilustrasi ──
                  Container(
                    height: 210,
                    width: double.infinity,
                    color: _lavenderCard,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _RoutePainter()),
                        ),
                        const Positioned(
                          top: 22,
                          left: 14,
                          child: _MapLabel(
                            icon: Icons.restaurant,
                            text: 'Kantin Teknik',
                            iconColor: Color(0xFFB3261E),
                          ),
                        ),
                        const Positioned(
                          bottom: 22,
                          right: 14,
                          child: _MapLabel(
                            icon: Icons.location_on,
                            text: 'Kos Melati',
                            iconColor: AppColors.brandPurple,
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0.05, 0.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                width: 4,
                              ),
                            ),
                            child: const Icon(
                              Icons.two_wheeler,
                              size: 20,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Kartu status pesanan ──
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFE4DBFB),
                              child: Icon(
                                Icons.delivery_dining,
                                color: AppColors.brandPurple,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Es Teh Solo & Geprek',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: _ink,
                                    ),
                                  ),
                                  Text(
                                    'Perkiraan tiba: 4 menit',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _ink.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD9D0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Otw Kampus',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC0392B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _StepItem(
                                icon: Icons.check,
                                label: 'Driver\nDitemukan',
                                state: _StepState.done,
                              ),
                            ),
                            Expanded(
                              child: _StepItem(
                                icon: Icons.check,
                                label: 'Menuju Lokasi',
                                state: _StepState.done,
                              ),
                            ),
                            Expanded(
                              child: _StepItem(
                                icon: Icons.near_me,
                                label: 'Dalam\nPerjalanan',
                                state: _StepState.active,
                              ),
                            ),
                            Expanded(
                              child: _StepItem(
                                icon: Icons.flag_outlined,
                                label: 'Selesai',
                                state: _StepState.pending,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.headline.copyWith(
                fontSize: 26,
                height: 1.35,
                color: _ink,
              ),
              children: const [
                TextSpan(text: 'Pantau pesanan secara '),
                TextSpan(
                  text: 'real-time',
                  style: TextStyle(color: AppColors.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Lihat status pesanan mulai dari driver ditemukan hingga selesai.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyDescription.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _ink.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Garis putus-putus rute dari titik jemput ke tujuan.
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGradientStart
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.25)
      ..lineTo(size.width * 0.78, size.height * 0.80);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _StepState { done, active, pending }

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.icon,
    required this.label,
    required this.state,
  });

  final IconData icon;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (state) {
      case _StepState.done:
        bg = const Color(0xFFD9F5E6);
        fg = const Color(0xFF2E9E6B);
      case _StepState.active:
        bg = const Color(0xFF3B2A5E);
        fg = Colors.white;
      case _StepState.pending:
        bg = _lavenderCard;
        fg = const Color(0xFFB9B3D6);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: bg,
          child: Icon(icon, size: 16, color: fg),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: state == _StepState.active
                ? FontWeight.w700
                : FontWeight.w500,
            color: state == _StepState.pending
                ? _ink.withValues(alpha: 0.35)
                : _ink,
          ),
        ),
      ],
    );
  }
}