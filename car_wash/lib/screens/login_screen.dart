import 'dart:ui';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/connectivity_controller.dart';
import 'package:car_wash/screens/forgot_password.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/signup_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  int index = 2;
  final User? user = AuthController().currentUser;
  final AuthController _authController = AuthController();
  final ConectivityController _conectivityController = ConectivityController();

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const LocaleText('internet_connection'),
          content: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Color.fromARGB(255, 157, 157, 157),
                size: 50,
              ),
              LocaleText('internet_connection_message'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => _conectivityController.isAlertSet = false);
                _conectivityController.isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!_conectivityController.isDeviceConnected &&
                    !_conectivityController.isAlertSet) {
                  showDialogBox();
                  setState(() => _conectivityController.isAlertSet = true);
                }
              },
              child: const LocaleText('internet_connection_button'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(index: index),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.07,
                vertical: MediaQuery.of(context).size.height * 0.22),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Container(
                  padding: const EdgeInsets.only(),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Color.fromARGB(70, 122, 122, 122),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LocaleText(
                        "log_in",
                        style: TextStyle(
                          color: const Color.fromARGB(223, 255, 255, 255),
                          fontSize: MediaQuery.of(context).size.width / 10,
                          shadows: [
                            Shadow(
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.30),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08,
                            ),
                            child: CustomEntryField(
                              onTap: () {},
                              title: Locales.string(context, 'email_address'),
                              iconData: Icons.email,
                              controller: _authController.email,
                              hasObscureText: false,
                              obscureText: false,
                              errorMessage: _authController.emailError,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                              child: CustomEntryField(
                                onTap: () => {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  })
                                },
                                title: Locales.string(context, 'password'),
                                iconData: Icons.lock,
                                controller: _authController.password,
                                hasObscureText: true,
                                obscureText: _obscureText,
                                errorMessage: _authController.passwordError,
                              )),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen())),
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Center(
                                  child: LocaleText(
                                'forgot_your_password',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    decoration: TextDecoration.underline,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)),
                              )),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: CustomButton(
                              onTap: () async {
                                _conectivityController.isAlertSet = false;
                                await _conectivityController
                                    .checkInternetConnection(
                                        box: () => showDialogBox(),
                                        onAlert: () => setState(() =>
                                            _conectivityController.isAlertSet =
                                                true));
                                if (_conectivityController.isDeviceConnected) {
                                  await _authController.logIn(
                                    context: context,
                                    onEmailError: (error) => setState(() =>
                                        _authController.emailError = error),
                                    onPasswordError: (error) => setState(() =>
                                        _authController.passwordError = error),
                                    onSuccess: () => {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst),
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen())),
                                    },
                                  );
                                }
                              },
                              withGradient: false,
                              text: Locales.string(context, 'log_in'),
                              rowText: false,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LocaleText(
                                    "dont_have_an_account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignupScreen()))
                                    },
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: Locales.currentLocale(context)
                                                  ?.languageCode ==
                                              'ro'
                                          ? MediaQuery.of(context).size.width *
                                              0.27
                                          : MediaQuery.of(context).size.width *
                                              0.16,
                                      child: Center(
                                          child: LocaleText(
                                        "create_account",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            decoration:
                                                TextDecoration.underline,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      )),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
