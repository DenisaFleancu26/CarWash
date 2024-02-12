import 'package:car_wash/controllers/notification_controller.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationController notificationController = NotificationController();
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/start_background.png"),
        fit: BoxFit.cover,
      )),
      child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2,
              bottom: MediaQuery.of(context).size.height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Car Wash",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: MediaQuery.of(context).size.height * 0.0015,
                      fontSize: MediaQuery.of(context).size.width / 5,
                      fontFamily: 'Nosifer',
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(222, 146, 146, 146),
                            Color.fromARGB(239, 255, 255, 255)
                          ],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                      shadows: [
                        Shadow(
                          offset: const Offset(3.0, 3.0),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomButton(
                onTap: () async {
                  await notificationController.saveToken().whenComplete(() =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())));
                },
                withGradient: true,
                text: "",
                rowText: true,
                colorGradient1: const Color.fromARGB(108, 14, 14, 14),
                colorGradient2: const Color.fromARGB(107, 255, 255, 255),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Get Started!",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 20,
                        color: const Color.fromARGB(255, 199, 199, 199),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 239, 239, 239),
                    ),
                  ],
                ),
              )
            ],
          )),
    ));
  }
}
