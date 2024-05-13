import 'package:car_wash/controllers/language_controller.dart';
import 'package:car_wash/controllers/notification_controller.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  LanguageController _languageController = LanguageController();
  NotificationController notificationController = NotificationController();

  @override
  void initState() {
    _languageController.getLanguage(onSuccess: () => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              bottom: MediaQuery.of(context).size.height * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.height * 0.32),
                      child: Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.04,
                              padding: const EdgeInsets.all(2),
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 34, 34, 34),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _languageController.language =
                                                  'en';
                                              _languageController.setLanguage();
                                              Locales.change(context, 'en');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: _languageController
                                                            .language ==
                                                        'en'
                                                    ? const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : const Color.fromARGB(
                                                        255, 34, 34, 34),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Text("EN",
                                                style: TextStyle(
                                                  color: _languageController
                                                              .language ==
                                                          'en'
                                                      ? const Color.fromARGB(
                                                          255, 34, 34, 34)
                                                      : const Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                )),
                                          ))),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _languageController.language =
                                                  'ro';
                                              _languageController.setLanguage();
                                              Locales.change(context, 'ro');
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: _languageController
                                                            .language ==
                                                        'ro'
                                                    ? const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : const Color.fromARGB(
                                                        255, 34, 34, 34),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                            child: Text("RO",
                                                style: TextStyle(
                                                  color: _languageController
                                                              .language ==
                                                          'ro'
                                                      ? const Color.fromARGB(
                                                          255, 34, 34, 34)
                                                      : const Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                )),
                                          ))),
                                ],
                              )))),
                  Text(
                    "Smart Wash",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: MediaQuery.of(context).size.height * 0.0015,
                      fontSize: MediaQuery.of(context).size.width / 5.1,
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
                    LocaleText(
                      'get_started',
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
