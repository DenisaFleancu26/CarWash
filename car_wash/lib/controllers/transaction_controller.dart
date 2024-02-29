import 'package:car_wash/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:car_wash/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionController {
  final User? user = AuthController().currentUser;
  List<TransactionModel> transactions = [];

  Future<void> saveTransaction(
      {required String dataQR,
      required String carwash_ro,
      required String carwash_en,
      required String address_ro,
      required String address_en,
      required double totalPrice,
      required String date}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .collection('transaction')
        .add({
      "dataQR": dataQR,
      "carWash_ro": carwash_ro,
      "carwash_en": carwash_en,
      "address_ro": address_ro,
      "address_en": address_en,
      "totalPrice": totalPrice,
      'date': date
    });
  }

  Future<void> fetchTransactions({required Function() displayInfo}) async {
    final collection = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .collection('transaction')
        .get();

    if (collection.docs.isNotEmpty) {
      for (var element in collection.docs) {
        TransactionModel transaction = TransactionModel(
            dataQR: element['dataQR'],
            carwash_ro: element['carWash_ro'],
            carwash_en: element['carWash_en'],
            address_ro: element['address_ro'],
            address_en: element['address_en'],
            totalPrice: element['totalPrice'],
            date: element['date']);
        transactions.add(transaction);
      }
    }

    transactions.sort((a, b) {
      DateTime dateA = DateFormat('dd/MM/yyyy').parse(a.date);
      DateTime dateB = DateFormat('dd/MM/yyyy').parse(b.date);
      return dateB.compareTo(dateA);
    });

    displayInfo();
  }
}
