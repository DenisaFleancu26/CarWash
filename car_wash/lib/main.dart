import 'package:car_wash/controllers/notification_controller.dart';
import 'package:car_wash/firebase_options.dart';
import 'package:car_wash/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '.env';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationController().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}
