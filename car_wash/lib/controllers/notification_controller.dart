import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController {
  Future<void> initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}
