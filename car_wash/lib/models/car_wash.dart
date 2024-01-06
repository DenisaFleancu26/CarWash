import 'package:car_wash/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  CarWash({
    required this.name,
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
  });

  Future<void> addRating(int rating, String manager, String carwash) async {
    totalRatings += rating;
    nrRatings++;

    await FirebaseFirestore.instance
        .collection('Managers')
        .doc(manager)
        .collection('car-wash')
        .doc(carwash)
        .update({'totalRatings': totalRatings, 'nrRatings': nrRatings});
  }

  Future<void> addReview(String username, TextEditingController feedback,
      int rating, String manager, String carwash) async {
    await FirebaseFirestore.instance
        .collection('Managers')
        .doc(manager)
        .collection('car-wash')
        .doc(carwash)
        .collection('review')
        .add({
      'username': username,
      'feedback': feedback.text,
      'rating': rating
    });
  }

  double averageRating(int nrRatings, int totalRatings) {
    return nrRatings == 0 ? 0.0 : totalRatings / nrRatings;
  }
}

Future<List<Review>> getReviews(String manager, String carwash) async {
  final collection = await FirebaseFirestore.instance
      .collection('Managers')
      .doc(manager)
      .collection('car-wash')
      .doc(carwash)
      .collection('review')
      .get();

  List<Review> reviews = [];
  for (var element in collection.docs) {
    if (element.data().containsKey('username') &&
        (element.data().containsKey('feedback') ||
            element.data().containsKey('rating'))) {
      Review review = Review(
          username: element['username'],
          feedback: element['feedback'],
          rating: element['rating']);
      reviews.add(review);
    }
  }

  return reviews;
}
