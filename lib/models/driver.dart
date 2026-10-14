class Driver {
  final String id;
  final String name;
  final double rating;
  final int totalReviews;
  final String vehicle;
  final String plateNumber;
  final int experienceYears;
  final double distanceKm;
  final int etaMinutes;
  final bool isAvailable;

  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalReviews,
    required this.vehicle,
    required this.plateNumber,
    required this.experienceYears,
    required this.distanceKm,
    required this.etaMinutes,
    required this.isAvailable,
  });
}

class OrderSummary {
  final String pickup;
  final String destination;
  final String serviceType;
  final int estimatedMinutes;
  final int price;

  const OrderSummary({
    required this.pickup,
    required this.destination,
    required this.serviceType,
    required this.estimatedMinutes,
    required this.price,
  });
}