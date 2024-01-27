import 'package:car_wash/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final User? user = AuthController().currentUser;
  String username = '';
  String email = '';

  Future<void> getUserDetails(
      {required Function() displayInfo, required String collection}) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(user?.uid)
          .get();
      if (userQuerySnapshot.exists) {
        username = userQuerySnapshot['username'];
        email = userQuerySnapshot['email'];
      }
    } catch (e) {
      print('Error getting documents $e');
    }
    displayInfo();
  }

  Future<void> getUsername(
      {required Function(String username) displayUsername,
      required String collection}) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(user?.uid)
          .get();
      if (userQuerySnapshot.exists) {
        displayUsername(userQuerySnapshot['username']);
      }
    } catch (e) {
      print('Error getting documents $e');
    }
  }
}
