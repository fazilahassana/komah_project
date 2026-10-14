import 'package:flutter/material.dart';
import '../models/driver.dart';
import '../data/driver_repository.dart';

const Color kPrimary = Color(0xFFE9785D);
const Color kSecondary = Color(0xFFF1B45B);
const Color kText = Color(0xFF27232A);
const Color kMutedText = Color(0xFF7D7880);
const Color kBackground = Color(0xFFFFFBF7);
const Color kCard = Colors.white;
const Color kGreen = Color(0xFF49A86B);

class DriverSelectionScreen extends StatefulWidget {
  const DriverSelectionScreen({super.key});

  @override
  State<DriverSelectionScreen> createState() => _DriverSelectionScreenState();
}

class _DriverSelectionScreenState extends State<DriverSelectionScreen> {
  Driver? selectedDriver;

  final OrderSummary orderSummary = const OrderSummary(
    pickup: 'Kos FTI UNAND',
    destination: 'Kampus UNAND (Gerbang Utama)',
    serviceType: 'KOMah Reguler',
    estimatedMinutes: 10,
    price: 12000,
  );

  void selectDriver(Driver driver) {
    // VALIDATION
    if (!driver.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Driver sedang tidak tersedia. Silakan pilih driver lain.',
          ),
        ),
      );
      return;
    }

    // STATE
    setState(() {
      selectedDriver = driver;
    });

    // NAVIGATION
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverDetailScreen(
          driver: driver,
          orderSummary: orderSummary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drivers = DriverRepository.drivers;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const DriverHeader(
              title: 'Pilih Driver',
              currentStep: 1,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Driver',
                      style: TextStyle(
                        color: kText,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Pilih driver yang tersedia untuk mengantarmu ke tujuan.',
                      style: TextStyle(
                        color: kMutedText,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 18),

                    RouteCard(
                      pickup: orderSummary.pickup,
                      destination: orderSummary.destination,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Driver Tersedia',
                      style: TextStyle(
                        color: kText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Pilih salah satu driver di bawah ini.',
                      style: TextStyle(
                        color: kMutedText,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...drivers.map(
                      (driver) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DriverListCard(
                          driver: driver,
                          onTap: () => selectDriver(driver),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// FRAME 2 — DETAIL DRIVER
// ================================================================

class DriverDetailScreen extends StatelessWidget {
  final Driver driver;
  final OrderSummary orderSummary;

  const DriverDetailScreen({
    super.key,
    required this.driver,
    required this.orderSummary,
  });

  void chooseDriver(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverConfirmationScreen(
          driver: driver,
          orderSummary: orderSummary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const DriverHeader(
              title: 'Detail Driver',
              currentStep: 2,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cek informasi driver sebelum memilihnya.',
                      style: TextStyle(
                        color: kMutedText,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DriverDetailCard(driver: driver),

                    const SizedBox(height: 18),

                    SectionCard(
                      title: 'Penilaian dari Pengguna',
                      trailing: 'Lihat Semua',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                '4.8',
                                style: TextStyle(
                                  color: kText,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (_) => const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: kSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${driver.totalReviews} ulasan',
                                    style: const TextStyle(
                                      color: kMutedText,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          const ReviewItem(
                            name: 'Rara',
                            text:
                                'Driver ramah dan datang tepat waktu.',
                          ),

                          const ReviewItem(
                            name: 'Siska',
                            text:
                                'Perjalanan nyaman, recommended banget.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    SectionCard(
                      title: 'Informasi Tambahan',
                      child: Column(
                        children: [
                          InfoLine(
                            icon: Icons.verified_outlined,
                            text: 'Driver telah terverifikasi',
                          ),
                          InfoLine(
                            icon: Icons.info_outline,
                            text: 'Menggunakan atribut KOMah',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomGradientButton(
              text: 'Pilih Driver Ini',
              onPressed: () => chooseDriver(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// FRAME 3 — KONFIRMASI DRIVER
// ================================================================

class DriverConfirmationScreen extends StatefulWidget {
  final Driver driver;
  final OrderSummary orderSummary;

  const DriverConfirmationScreen({
    super.key,
    required this.driver,
    required this.orderSummary,
  });

  @override
  State<DriverConfirmationScreen> createState() =>
      _DriverConfirmationScreenState();
}

class _DriverConfirmationScreenState
    extends State<DriverConfirmationScreen> {
  bool isLoading = false;

  Future<void> confirmDriver() async {
    // VALIDATION
    if (!widget.driver.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Driver sudah tidak tersedia.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverSuccessScreen(
          driver: widget.driver,
          orderSummary: widget.orderSummary,
        ),
      ),
    );
  }

  void chooseAnotherDriver(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const DriverHeader(
              title: 'Konfirmasi Driver',
              currentStep: 3,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pastikan driver yang kamu pilih sudah sesuai sebelum melanjutkan.',
                      style: TextStyle(
                        color: kMutedText,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 16),

                    DriverCompactCard(
                      driver: widget.driver,
                    ),

                    const SizedBox(height: 16),

                    RouteCard(
                      pickup: widget.orderSummary.pickup,
                      destination: widget.orderSummary.destination,
                    ),

                    const SizedBox(height: 16),

                    SectionCard(
                      title: 'Ringkasan Pesanan',
                      child: Column(
                        children: [
                          SummaryLine(
                            label: 'Tipe Layanan',
                            value: widget.orderSummary.serviceType,
                          ),
                          SummaryLine(
                            label: 'Estimasi Waktu',
                            value:
                                '${widget.orderSummary.estimatedMinutes} menit',
                          ),
                          SummaryLine(
                            label: 'Estimasi Harga',
                            value:
                                formatRupiah(widget.orderSummary.price),
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => chooseAnotherDriver(context),
                        child: const Text(
                          'Pilih Driver Lain',
                          style: TextStyle(
                            color: kPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomGradientButton(
              text: isLoading
                  ? 'Memproses...'
                  : 'Konfirmasi Driver',
              onPressed: isLoading ? null : confirmDriver,
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// FRAME 4 — SUCCESS
// ================================================================

class DriverSuccessScreen extends StatelessWidget {
  final Driver driver;
  final OrderSummary orderSummary;

  const DriverSuccessScreen({
    super.key,
    required this.driver,
    required this.orderSummary,
  });

  void finish(BuildContext context) {
    Navigator.pop(context, driver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const DriverHeader(
              title: 'Driver Berhasil Dipilih',
              currentStep: 4,
              showBack: false,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 170,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEEE7),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.two_wheeler,
                                  size: 70,
                                  color: kPrimary,
                                ),
                                Positioned(
                                  right: 24,
                                  top: 20,
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 42,
                                    color: kGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'Driver Berhasil Dipilih',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kText,
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Kamu berhasil memilih driver untuk perjalananmu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kMutedText,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    DriverCompactCard(
                      driver: driver,
                    ),

                    const SizedBox(height: 14),

                    SectionCard(
                      title: 'Ringkasan Pesanan',
                      child: Column(
                        children: [
                          SummaryLine(
                            label: 'Rute',
                            value:
                                '${orderSummary.pickup} → ${orderSummary.destination}',
                          ),
                          SummaryLine(
                            label: 'Tipe Layanan',
                            value: orderSummary.serviceType,
                          ),
                          SummaryLine(
                            label: 'Estimasi Waktu',
                            value:
                                '${orderSummary.estimatedMinutes} menit',
                          ),
                          SummaryLine(
                            label: 'Estimasi Harga',
                            value:
                                formatRupiah(orderSummary.price),
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomGradientButton(
              text: 'Lanjut ke Status Pesanan',
              onPressed: () => finish(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// HEADER
// ================================================================

class DriverHeader extends StatelessWidget {
  final String title;
  final int currentStep;
  final bool showBack;

  const DriverHeader({
    super.key,
    required this.title,
    required this.currentStep,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
          child: Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: kText,
                  ),
                )
              else
                const SizedBox(width: 18),

              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 18),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 7,
          ),
          child: Row(
            children: List.generate(
              4,
              (index) {
                final active = index < currentStep;

                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? kPrimary
                              : const Color(0xFFD8D1CD),
                        ),
                      ),
                      if (index < 3)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: index < currentStep - 1
                                ? kPrimary
                                : const Color(0xFFD8D1CD),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// ROUTE CARD
// ================================================================

class RouteCard extends StatelessWidget {
  final String pickup;
  final String destination;

  const RouteCard({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEDE5E0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(
                Icons.radio_button_checked,
                size: 17,
                color: kPrimary,
              ),
              Container(
                width: 1.5,
                height: 22,
                color: const Color(0xFFD8D1CD),
              ),
              const Icon(
                Icons.location_on,
                size: 18,
                color: kPrimary,
              ),
            ],
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dari',
                  style: TextStyle(
                    color: kMutedText,
                    fontSize: 10,
                  ),
                ),
                Text(
                  pickup,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Ke',
                  style: TextStyle(
                    color: kMutedText,
                    fontSize: 10,
                  ),
                ),
                Text(
                  destination,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: const Text(
              'Ubah',
              style: TextStyle(
                color: kPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DRIVER LIST CARD
// ================================================================

class DriverListCard extends StatelessWidget {
  final Driver driver;
  final VoidCallback onTap;

  const DriverListCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final available = driver.isAvailable;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFEDE5E0),
            ),
          ),
          child: Row(
            children: [
              DriverAvatar(
                size: 48,
                driver: driver,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driver.name,
                          style: const TextStyle(
                            color: kText,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.star,
                          size: 13,
                          color: kSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          driver.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    Text(
                      driver.vehicle,
                      style: const TextStyle(
                        color: kMutedText,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      driver.plateNumber,
                      style: const TextStyle(
                        color: kMutedText,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              StatusBadge(
                available: available,
              ),

              const SizedBox(width: 4),

              Icon(
                available
                    ? Icons.chevron_right
                    : Icons.lock_outline,
                size: 18,
                color: const Color(0xFFB5ACA7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// DRIVER DETAIL CARD
// ================================================================

class DriverDetailCard extends StatelessWidget {
  final Driver driver;

  const DriverDetailCard({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDE5E0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              DriverAvatar(
                size: 68,
                driver: driver,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        color: kText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: kSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${driver.rating.toStringAsFixed(1)} (${driver.totalReviews})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    StatusBadge(
                      available: driver.isAvailable,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Divider(height: 1),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: SmallInfo(
                  icon: Icons.two_wheeler,
                  title: 'Motor',
                  value: driver.vehicle,
                ),
              ),
              Expanded(
                child: SmallInfo(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Nomor Polisi',
                  value: driver.plateNumber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SmallInfo(
                  icon: Icons.work_outline,
                  title: 'Pengalaman',
                  value: '${driver.experienceYears} tahun',
                ),
              ),
              Expanded(
                child: SmallInfo(
                  icon: Icons.location_on_outlined,
                  title: 'Jarak dari kamu',
                  value:
                      '${driver.distanceKm.toStringAsFixed(1)} km',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================
// COMPACT DRIVER CARD
// ================================================================

class DriverCompactCard extends StatelessWidget {
  final Driver driver;

  const DriverCompactCard({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEDE5E0),
        ),
      ),
      child: Row(
        children: [
          DriverAvatar(
            size: 52,
            driver: driver,
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${driver.vehicle} • ${driver.plateNumber}',
                  style: const TextStyle(
                    color: kMutedText,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 13,
                      color: kSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      driver.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.check_circle,
            color: kGreen,
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DRIVER AVATAR
// ================================================================

class DriverAvatar extends StatelessWidget {
  final Driver driver;
  final double size;

  const DriverAvatar({
    super.key,
    required this.driver,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFE6D8),
        border: Border.all(
          color: const Color(0xFFFFC7A8),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.55,
        color: kPrimary,
      ),
    );
  }
}

// ================================================================
// STATUS BADGE
// ================================================================

class StatusBadge extends StatelessWidget {
  final bool available;

  const StatusBadge({
    super.key,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: available
            ? const Color(0xFFE8F7ED)
            : const Color(0xFFFFEFE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: available ? kGreen : kPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            available ? 'Tersedia' : 'Sedang Pesanan',
            style: TextStyle(
              color: available ? kGreen : kPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SECTION CARD
// ================================================================

class SectionCard extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEDE5E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: const TextStyle(
                    color: kPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }
}

// ================================================================
// SMALL INFO
// ================================================================

class SmallInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SmallInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: kPrimary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: kMutedText,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: kText,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================================================================
// INFO LINE
// ================================================================

class InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoLine({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: kPrimary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: kText,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// REVIEW ITEM
// ================================================================

class ReviewItem extends StatelessWidget {
  final String name;
  final String text;

  const ReviewItem({
    super.key,
    required this.name,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFE6D8),
            ),
            child: const Icon(
              Icons.person,
              size: 18,
              color: kPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(
                    5,
                    (_) => const Icon(
                      Icons.star,
                      size: 10,
                      color: kSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: const TextStyle(
                    color: kMutedText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SUMMARY LINE
// ================================================================

class SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const SummaryLine({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: kMutedText,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: kText,
                fontSize: 10,
                fontWeight:
                    bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// BOTTOM BUTTON
// ================================================================

class BottomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BottomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                kPrimary,
                kSecondary,
              ],
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// FORMAT RUPIAH
// ================================================================

String formatRupiah(int value) {
  final valueString = value.toString();

  final result = valueString.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );

  return 'Rp $result';
}

// ================================================================
// ENTRY POINT — KHUSUS MENJALANKAN FITUR DRIVER
// ================================================================

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DriverSelectionScreen(),
    ),
  );
}