import '../models/driver.dart';

class DriverRepository {
  static const List<Driver> drivers = [
    Driver(
      id: 'D001',
      name: 'Budi',
      rating: 4.8,
      totalReviews: 120,
      vehicle: 'Honda Beat',
      plateNumber: 'BA 1234 ABC',
      experienceYears: 3,
      distanceKm: 1.2,
      etaMinutes: 3,
      isAvailable: true,
    ),

    Driver(
      id: 'D002',
      name: 'Rizky',
      rating: 4.7,
      totalReviews: 98,
      vehicle: 'Yamaha NMAX',
      plateNumber: 'BA 5678 DEF',
      experienceYears: 2,
      distanceKm: 1.8,
      etaMinutes: 5,
      isAvailable: true,
    ),

    Driver(
      id: 'D003',
      name: 'Fahri',
      rating: 4.6,
      totalReviews: 76,
      vehicle: 'Honda Vario',
      plateNumber: 'BA 9012 GHI',
      experienceYears: 2,
      distanceKm: 2.1,
      etaMinutes: 7,
      isAvailable: false,
    ),

    Driver(
      id: 'D004',
      name: 'Dimas',
      rating: 4.9,
      totalReviews: 150,
      vehicle: 'Honda Beat',
      plateNumber: 'BA 3456 JKL',
      experienceYears: 4,
      distanceKm: 2.5,
      etaMinutes: 8,
      isAvailable: true,
    ),

    Driver(
      id: 'D005',
      name: 'Alif',
      rating: 4.5,
      totalReviews: 64,
      vehicle: 'Yamaha Mio',
      plateNumber: 'BA 7890 MNO',
      experienceYears: 1,
      distanceKm: 3.0,
      etaMinutes: 10,
      isAvailable: true,
    ),
  ];
}