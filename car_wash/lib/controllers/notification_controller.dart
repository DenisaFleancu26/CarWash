import 'dart:convert';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../.env';

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

  Future<void> sendNotification(
      {required int offerType,
      required String name,
      required String offerValue,
      required title,
      required offer1,
      required offer2}) async {
    final collection =
        await FirebaseFirestore.instance.collection('UserTokens').get();

    Set<String> tokens = {};

    for (var element in collection.docs) {
      if (!tokens.contains(element['token'])) {
        tokens.add(element['token']);
      }
    }

    for (var element in tokens) {
      try {
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': offerType == 1
                    ? offer1
                            .replaceAll(
                                '{value}', double.parse(offerValue).toString())
                            .replaceAll('{name}', name) +
                        ' 💦🚘'
                    : offer2
                            .replaceAll('{value}', offerValue)
                            .toString()
                            .replaceAll('{name}', name) +
                        ' 💦🚘',
                'title': title + '  📢',
                'visibility': 'public',
              },
              'notification': <String, dynamic>{
                'title': title + '  📢',
                'body': offerType == 1
                    ? offer1
                            .replaceAll(
                                '{value}', double.parse(offerValue).toString())
                            .replaceAll('{name}', name) +
                        ' 💦🚘'
                    : offer2
                            .replaceAll('{value}', offerValue)
                            .toString()
                            .replaceAll('{name}', name) +
                        ' 💦🚘',
                'android_channel_id': 'dbfood'
              },
              'to': element
            }));
      } catch (e) {
        if (kDebugMode) {
          print('error push notification' + e.toString());
        }
      }
    }
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {}
