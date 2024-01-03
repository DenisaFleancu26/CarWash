import 'package:cloud_firestore/cloud_firestore.dart';

class CarWash {
  final String name;
  final String hours;
  final String image;
  final String address;
  final int phone;
  final int smallVehicleSeats;
  final int bigVehicleSeats;
  final double price;
  int totalRatings;
  int nrRatings;
  Map<int, List<String>> reviews;

  CarWash({
    required this.name,
    required this.hours,
    required this.image,
    required this.address,
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

  Future<void> addReview(
      String username, String feedback, String manager, String carwash) async {
    await FirebaseFirestore.instance
        .collection('Managers')
        .doc(manager)
        .collection('car-wash')
        .doc(carwash)
        .collection('review')
        .add({'username': username, 'feedback': feedback});
  }

  double averageRating(int nrRatings, int totalRatings) {
    return nrRatings == 0 ? 0.0 : totalRatings / nrRatings;
  }
}

Future<Map<int, List<String>>> getReviews(
    String manager, String carwash) async {
  final collection = await FirebaseFirestore.instance
      .collection('Managers')
      .doc(manager)
      .collection('car-wash')
      .doc(carwash)
      .collection('review')
      .get();

  int nr = 1;

  Map<int, List<String>> reviews = {};
  for (var element in collection.docs) {
    if (element.data().containsKey('username') &&
        element.data().containsKey('feedback')) {
      List<String> listReview = [];
      listReview.add(element['username']);
      listReview.add(element['feedback']);
      reviews[nr] = listReview;
      nr++;
    }
  }

  return reviews;
}
