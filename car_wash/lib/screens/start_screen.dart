import 'package:car_wash/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/startCar.jpg"),
        fit: BoxFit.cover,
      )),
      child: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    width: 120,
                  ),
                  Text(
                    "Car Wash",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 0.99,
                      fontSize: 80,
                      fontFamily: 'Nosifer',
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 0, 122, 162),
                            Color.fromARGB(192, 255, 255, 255)
                          ],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
                    ),
                  ),
                ],
              ),
              CustomButton(
                onTap: () => {},
                withGradient: true,
                text: "",
                rowText: true,
                colorGradient1: const Color.fromARGB(110, 7, 144, 190),
                colorGradient2: const Color.fromARGB(130, 255, 255, 255),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Get Started!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          )),
    ));
  }
}
