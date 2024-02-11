import 'package:car_wash/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController {
  Future<void> saveToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('UserTokens')
          .where('token', isEqualTo: token)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('UserTokens')
            .doc(AuthController().currentUser?.uid ??
                FirebaseFirestore.instance.collection('UserTokens').doc().id)
            .set({'token': token});
      }
    });
  }

  Future<void> initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}
