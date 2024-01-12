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
          title: const Text('No Internet Connection'),
          content: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Color.fromARGB(255, 157, 157, 157),
                size: 50,
              ),
              Text('Please check your internet connection and try again!'),
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
              child: const Text('Retry!'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(user: user, index: index),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 170),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Log In",
                        style: TextStyle(
                          color: const Color.fromARGB(223, 255, 255, 255),
                          fontSize: 40,
                          shadows: [
                            Shadow(
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.30),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                          onTap: () {},
                          title: 'Email Address',
                          iconData: Icons.email,
                          controller: _authController.email,
                          hasObscureText: false,
                          obscureText: false,
                          errorMessage: _authController.emailError,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: CustomEntryField(
                            onTap: () => {
                              setState(() {
                                _obscureText = !_obscureText;
                              })
                            },
                            title: 'Password',
                            iconData: Icons.lock,
                            controller: _authController.password,
                            hasObscureText: true,
                            obscureText: _obscureText,
                            errorMessage: _authController.passwordError,
                          )),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen())),
                        },
                        child: const SizedBox(
                          height: 30,
                          width: 200,
                          child: Center(
                              child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          )),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
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
                                onEmailError: (error) => setState(
                                    () => _authController.emailError = error),
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
                          text: "Log In",
                          rowText: false,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account yet?",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
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
                                child: const SizedBox(
                                  height: 50,
                                  width: 60,
                                  child: Center(
                                      child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  )),
                                ),
                              ),
                            ],
                          ))
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
