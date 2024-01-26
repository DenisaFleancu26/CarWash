import 'package:car_wash/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionController {
  final User? user = AuthController().currentUser;

  Future<void> saveTransaction(
      {required String dataQR,
      required String carwash,
      required String address,
      required double totalPrice}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .collection('transaction')
        .add({
      "dataQR": dataQR,
      "carWash": carwash,
      "address": address,
      "totalPrice": totalPrice,
    });
  }
}
