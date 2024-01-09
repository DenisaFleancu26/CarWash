import 'dart:ui';

import 'package:car_wash/screens/forgot_password.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:car_wash/screens/signup_screen.dart';
import 'package:car_wash/services/auth.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? emailError;
  String? passwordError;

  var isDeviceConnected = false;
  bool isAlertSet = false;

  int index = 2;
  final User? user = Auth().currentUser;

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

  Future<void> checkInternetConnection() async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && !isAlertSet) {
      showDialogBox();
      setState(() => isAlertSet = true);
    }
  }

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
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && !isAlertSet) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('Retry!'),
            ),
          ],
        ),
      );

  Future<void> logIn() async {
    emailError = null;
    passwordError = null;

    if (_controllerEmail.text.isEmpty) {
      setState(() {
        emailError = "Please enter your Email Address!";
      });
      return;
    }
    if (_controllerPassword.text.isEmpty) {
      setState(() {
        passwordError = "Please enter your Password!";
      });
      return;
    }
    try {
      await Auth()
          .signWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text)
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalid-email':
            emailError = 'Your Email Address is invalid!';
            break;
          case 'wrong-password':
            passwordError = 'Your password is invalid, please try again!';
            break;
          case 'user-not-found':
            emailError = 'No user corresponding to the given email!';
            break;
          case 'user-disabled':
            emailError =
                'The user corresponding to the given email has been disabled!';
            break;
          default:
            passwordError = 'The mail or password you entered is wrong!';
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 255, 255, 255),
        animationDuration: const Duration(milliseconds: 300),
        height: 45,
        index: index,
        items: items,
        onTap: (index) => setState(() {
          this.index = index;
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 2:
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
              break;
          }
        }),
      ),
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
                          controller: _controllerEmail,
                          hasObscureText: false,
                          obscureText: false,
                          errorMessage: emailError,
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
                            controller: _controllerPassword,
                            hasObscureText: true,
                            obscureText: _obscureText,
                            errorMessage: passwordError,
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
                            isAlertSet = false;
                            await checkInternetConnection();
                            if (isDeviceConnected) {
                              logIn();
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
