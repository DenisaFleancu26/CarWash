import 'package:car_wash/models/review.dart';

class CarWash {
  final String name_ro;
  final String name_en;
  final String hours;
  final String image;
  final String address_ro;
  final String address_en;
  final String facilities_ro;
  final String facilities_en;
  final int phone;
  final int smallVehicleSeats;
  final int bigVehicleSeats;
  final double price;
  int totalRatings;
  int nrRatings;
  List<Review> reviews;

  CarWash(
      {required this.name_ro,
      required this.name_en,
      required this.hours,
      required this.image,
      required this.address_ro,
      required this.address_en,
      required this.facilities_ro,
      required this.facilities_en,
      required this.phone,
      required this.smallVehicleSeats,
      required this.bigVehicleSeats,
      required this.price,
      required this.totalRatings,
      required this.nrRatings,
      required this.reviews});
}
