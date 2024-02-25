import 'dart:ui';
import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/connectivity_controller.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  bool _obscureConfirm = true;
  final User? user = AuthController().currentUser;
  final AuthController _authController = AuthController();
  final ConectivityController _conectivityController = ConectivityController();
  int index = 2;

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
                vertical: MediaQuery.of(context).size.height * 0.17),
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
                        "sign_up",
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
                                title: Locales.string(context, 'username'),
                                iconData: Icons.person,
                                controller: _authController.username,
                                hasObscureText: false,
                                obscureText: false,
                                errorMessage: _authController.usernameError),
                          ),
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
                                errorMessage: _authController.emailError),
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
                                errorMessage: _authController.passwordError),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08,
                            ),
                            child: CustomEntryField(
                                onTap: () => {
                                      setState(() {
                                        _obscureConfirm = !_obscureConfirm;
                                      })
                                    },
                                title:
                                    Locales.string(context, 'confirm_password'),
                                iconData: Icons.lock,
                                controller: _authController.confirmPassword,
                                hasObscureText: true,
                                obscureText: _obscureConfirm,
                                errorMessage:
                                    _authController.confirmPasswordError),
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
                                  await _authController.signUp(
                                    context: context,
                                    onUsernameError: (error) => setState(() =>
                                        _authController.usernameError = error),
                                    onEmailError: (error) => setState(() =>
                                        _authController.emailError = error),
                                    onPasswordError: (error) => setState(() =>
                                        _authController.passwordError = error),
                                    onConfirmPasswordError: (error) => setState(
                                        () => _authController
                                            .confirmPasswordError = error),
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
                              text: Locales.string(context, 'sign_up'),
                              rowText: false,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LocaleText(
                                    'already_have_an_account',
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
                                                  const LoginScreen()))
                                    },
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: Locales.currentLocale(context)
                                                  ?.languageCode ==
                                              'ro'
                                          ? MediaQuery.of(context).size.width *
                                              0.25
                                          : MediaQuery.of(context).size.width *
                                              0.15,
                                      child: Center(
                                          child: LocaleText(
                                        "log_in_button",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      )),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )
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
