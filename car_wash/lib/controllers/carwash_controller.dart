import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CarWashController {
  List<CarWash> carWashes = [];
  List<CarWash> saveCarWashes = [];
  TextEditingController searchController = TextEditingController();
  final TextEditingController userReview = TextEditingController();
  String managerId = '';
  String carwashId = '';
  double rating = 0.0;

  Future<List<CarWash>> fetchCarWashesFromFirebase({
    required Function() displayInfo,
  }) async {
    final managers =
        await FirebaseFirestore.instance.collection('Managers').get();

    if (managers.docs.isNotEmpty) {
      for (var manager in managers.docs) {
        var managerCarWashes = await FirebaseFirestore.instance
            .collection('Managers')
            .doc(manager.id)
            .collection('car-wash')
            .get();
        for (var element in managerCarWashes.docs) {
          List<Review> reviews =
              await getReviews(manager: manager.id, carwash: element.id);
          CarWash carwash = CarWash(
            name: element['name'],
            hours: element['hours'],
            image: element['image'] ?? '',
            address: element['address'],
            facilities: element['facilities'],
            phone: element['phone'],
            smallVehicleSeats: element['small-vehicle'],
            bigVehicleSeats: element['big-vehicle'],
            price: (element['price']).toDouble(),
            nrRatings: element['nrRatings'],
            totalRatings: element['totalRatings'],
            reviews: reviews,
          );
          carWashes.add(carwash);
        }
      }
    }

    displayInfo();
    saveCarWashes = carWashes;

    return carWashes;
  }

  void searchCarWashes({
    required String query,
    required Function(List<CarWash> searchResults) onSuccess,
  }) {
    List<CarWash> searchResults = [];

    for (var carwash in carWashes) {
      if (carwash.name.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(carwash);
      }
    }

    onSuccess(searchResults);
  }

  Future findId({required String name, required String address}) async {
    final managers =
        await FirebaseFirestore.instance.collection('Managers').get();

    if (managers.docs.isNotEmpty) {
      for (var manager in managers.docs) {
        var managerCarWashes = await FirebaseFirestore.instance
            .collection('Managers')
            .doc(manager.id)
            .collection('car-wash')
            .get();
        for (var element in managerCarWashes.docs) {
          if (element['name'] == name && element['address'] == address) {
            managerId = manager.id;
            carwashId = element.id;
          }
        }
      }
    }
  }

  Future<List<Review>> getReviews(
      {required String manager, required String carwash}) async {
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

  Future<void> postReviewButton(
      {required CarWash carwash, required String username}) async {
    if (rating != 0.0 || userReview.text != '') {
      if (rating != 0.0) {
        addRating(
            carwash: carwash,
            rating: rating.toInt(),
            manager: managerId,
            carwashID: carwashId);
      }
      addReview(
          username: username,
          feedback: userReview,
          rating: rating.toInt(),
          manager: managerId,
          carwash: carwashId);
    }

    carwash.reviews = await getReviews(manager: managerId, carwash: carwashId);
  }

  Future<void> addRating(
      {required CarWash carwash,
      required int rating,
      required String manager,
      required String carwashID}) async {
    carwash.totalRatings += rating;
    carwash.nrRatings++;

    await FirebaseFirestore.instance
        .collection('Managers')
        .doc(manager)
        .collection('car-wash')
        .doc(carwashID)
        .update({
      'totalRatings': carwash.totalRatings,
      'nrRatings': carwash.nrRatings
    });
  }

  Future<void> addReview(
      {required String username,
      required TextEditingController feedback,
      required int rating,
      required String manager,
      required String carwash}) async {
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
