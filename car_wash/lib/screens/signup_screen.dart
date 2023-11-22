import 'dart:async';
import 'dart:ui';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_wash/services/auth.dart';
import 'package:car_wash/widgets/custom_button.dart';
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
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  final User? user = Auth().currentUser;

  var isDeviceConnected = false;
  bool isAlertSet = false;

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

  Future<void> signUp() async {
    usernameError = null;
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;

    if (_controllerUsername.text.isEmpty) {
      setState(() {
        usernameError = "Please enter your Username!";
      });
      return;
    }
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
    if (_controllerConfirmPassword.text.isEmpty) {
      setState(() {
        confirmPasswordError = "Please enter your Password again!";
      });
      return;
    }
    if (_controllerPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        confirmPasswordError = "The passwords you entered do not match!";
      });
      return;
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(value.user?.uid)
            .set({
          'username': _controllerUsername.text,
          'email': _controllerEmail.text,
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StartScreen()));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'weak-password':
            passwordError = 'Password should be at least 6 characters';
            break;
          case 'email-is-already-in-use':
            emailError = 'The Email has already been registered!';
            break;
          case 'invalid-email':
            emailError = 'Your Email Address is invalid!';
            break;
        }
      });
    }
  }

  Widget _entryField(
      String title,
      IconData iconData,
      TextEditingController controller,
      bool hasObscureText,
      bool obscureText,
      int nrField,
      String? errorMessage) {
    return TextField(
      obscureText: hasObscureText ? obscureText : false,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: title,
        errorText: errorMessage,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 157, 157, 157),
          shadows: [
            Shadow(
              offset: const Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 157, 157, 157)),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 29, 29, 29))),
        prefixIcon: Icon(
          iconData,
          color: const Color.fromARGB(255, 157, 157, 157),
          size: 30,
          shadows: [
            Shadow(
              offset: const Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: Visibility(
          visible: hasObscureText,
          child: GestureDetector(
            onTap: () {
              setState(() {
                switch (nrField) {
                  case 1:
                    _obscureText = !_obscureText;
                    obscureText = _obscureText;
                    break;
                  case 2:
                    _obscureConfirm = !_obscureConfirm;
                    obscureText = _obscureConfirm;
                    break;
                }
              });
            },
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromARGB(255, 157, 157, 157),
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: _entryField(
                            'Username',
                            Icons.person,
                            _controllerUsername,
                            false,
                            false,
                            0,
                            usernameError),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: _entryField('Email Address', Icons.email,
                            _controllerEmail, false, false, 0, emailError),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: _entryField(
                            'Password',
                            Icons.lock,
                            _controllerPassword,
                            true,
                            _obscureText,
                            1,
                            passwordError),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: _entryField(
                            'Confirm Password',
                            Icons.lock,
                            _controllerConfirmPassword,
                            true,
                            _obscureConfirm,
                            2,
                            confirmPasswordError),
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
                              signUp();
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
                                  height: 30,
                                  width: 50,
                                  child: Center(
                                      child: Text(
                                    "Log in",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 19, 19, 19)),
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
