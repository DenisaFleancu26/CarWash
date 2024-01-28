import 'package:car_wash/models/review.dart';

class CarWash {
  final String name;
  final String hours;
  final String image;
  final String address;
  final String facilities;
  final int phone;
  final int smallVehicleSeats;
  final int bigVehicleSeats;
  final double price;
  int totalRatings;
  int nrRatings;
  List<Review> reviews;
  List brokenSpots;

  CarWash(
      {required this.name,
      required this.hours,
      required this.image,
      required this.address,
      required this.facilities,
      required this.phone,
      required this.smallVehicleSeats,
      required this.bigVehicleSeats,
      required this.price,
      required this.totalRatings,
      required this.nrRatings,
      required this.reviews,
      required this.brokenSpots});
}
