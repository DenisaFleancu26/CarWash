import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/notification_controller.dart';
import 'package:car_wash/models/announcement.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class CarWashController {
  Map<String, CarWash> carWashes = {};
  Map<String, CarWash> saveCarWashes = {};
  TextEditingController searchController = TextEditingController();
  final TextEditingController userReview = TextEditingController();
  TextEditingController announcementController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  final AuthController authController = AuthController();
  final NotificationController notificationController =
      NotificationController();
  String managerId = '';
  String carwashId = '';
  double rating = 0.0;

  Future<Map<String, CarWash>> fetchCarWashesFromFirebase({
    required Function() displayInfo,
  }) async {
    if (AuthController().currentUser != null) {
      await authController.checkIsManager(
        id: AuthController().currentUser!.uid,
      );
    }

    if (authController.isManager == true) {
      final manager = await FirebaseFirestore.instance
          .collection('Managers')
          .doc(AuthController().currentUser!.uid)
          .collection('car-wash')
          .get();

      if (manager.docs.isNotEmpty) {
        for (var element in manager.docs) {
          List<Review> reviews = await getReviews(
              manager: AuthController().currentUser!.uid, carwash: element.id);
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
          carWashes[element.id] = carwash;
        }
      }
    } else {
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
            carWashes[element.id] = carwash;
          }
        }
      }
    }
    displayInfo();
    saveCarWashes = carWashes;

    return carWashes;
  }

  void searchCarWashes({
    required String query,
    required Function(Map<String, CarWash> searchResults) onSuccess,
  }) {
    Map<String, CarWash> searchResults = {};

    carWashes.forEach((key, value) {
      if (value.name.toLowerCase().contains(query.toLowerCase())) {
        searchResults[key] = value;
      }
    });

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

  Future<void> postAnnouncement({required String carwashID}) async {
    FirebaseDatabase.instance.ref(carwashID).child('announcements').push().set({
      'message': announcementController.text,
      'data':
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
    });
  }

  Future<void> deleteAnnouncement({required Announcement announcement}) async {
    DatabaseReference parentRef =
        FirebaseDatabase.instance.ref(carwashId).child('announcements');
    parentRef.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> children =
            event.snapshot.value as Map<dynamic, dynamic>;
        children.forEach((key, value) {
          if (value['data'] == announcement.date &&
              value['message'] == announcement.message) {
            parentRef.child(key).remove();
          }
        });
      }
    });
  }

  Future<void> makeOffer(
      {required int offerType,
      required CarWash carwash,
      required String id,
      required String title,
      required String offer1,
      required String offer2}) async {
    await FirebaseDatabase.instance.ref(id).child('offer').update({
      'type': offerType,
      'value': double.parse(offerController.text),
      'data':
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
    });
    await notificationController.sendNotification(
        title: title,
        offer1: offer1,
        offer2: offer2,
        offerType: offerType,
        name: carwash.name,
        offerValue: offerController.text);
  }

  Future<void> disableOffer({required String id}) async {
    await FirebaseDatabase.instance
        .ref(id)
        .child('offer')
        .update({'type': 0, 'value': 0, 'data': ''});
  }
}
