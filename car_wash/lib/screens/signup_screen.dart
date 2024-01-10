import 'dart:ui';
import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/connectivity_controller.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
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
                        "Sign Up",
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                            onTap: () {},
                            title: 'Username',
                            iconData: Icons.person,
                            controller: _authController.username,
                            hasObscureText: false,
                            obscureText: false,
                            errorMessage: _authController.usernameError),
                      ),
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
                            errorMessage: _authController.emailError),
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
                            errorMessage: _authController.passwordError),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                            onTap: () => {
                                  setState(() {
                                    _obscureConfirm = !_obscureConfirm;
                                  })
                                },
                            title: 'Confirm Password',
                            iconData: Icons.lock,
                            controller: _authController.confirmPassword,
                            hasObscureText: true,
                            obscureText: _obscureConfirm,
                            errorMessage: _authController.confirmPasswordError),
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
                              await _authController.signUp(
                                onUsernameError: (error) => setState(() =>
                                    _authController.usernameError = error),
                                onEmailError: (error) => setState(
                                    () => _authController.emailError = error),
                                onPasswordError: (error) => setState(() =>
                                    _authController.passwordError = error),
                                onConfirmPasswordError: (error) => setState(
                                    () => _authController.confirmPasswordError =
                                        error),
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
                          text: "Sign Up",
                          rowText: false,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
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
                                              const LoginScreen()))
                                },
                                child: const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                      child: Text(
                                    "Log In",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 15,
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
