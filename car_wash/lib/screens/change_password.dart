import 'dart:ui';

import 'package:car_wash/screens/profile_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {
  User user = FirebaseAuth.instance.currentUser!;

  String? errorCurrentPassword;
  String? errorNewPassword;
  String? errorConfirmPassword;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _controllerCurrentPassword =
      TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

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

  Future<void> changePassword() async {
    errorConfirmPassword = null;
    errorCurrentPassword = null;
    errorNewPassword = null;

    if (_controllerCurrentPassword.text.isEmpty) {
      setState(() {
        errorCurrentPassword = "Please enter your current password!";
      });
      return;
    }
    if (_controllerNewPassword.text.isEmpty) {
      setState(() {
        errorNewPassword = "Please enter your new password!";
      });
      return;
    }
    if (_controllerConfirmPassword.text.isEmpty) {
      setState(() {
        errorConfirmPassword = "Please enter your new password again!";
      });
      return;
    }
    if (_controllerNewPassword.text.length < 6) {
      setState(() {
        errorNewPassword = "Password must be at least 6 characters!";
      });
      return;
    }
    if (_controllerNewPassword.text != _controllerConfirmPassword.text) {
      setState(() {
        errorConfirmPassword = "The passwords you entered do not match!";
      });
      return;
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _controllerCurrentPassword.text,
      );
      await user.reauthenticateWithCredential(credential).then((value) {
        user.updatePassword(_controllerNewPassword.text).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()));
        });
      });
    } on FirebaseAuthException {
      setState(() {
        errorCurrentPassword = 'Your password is invalid, please try again!';
      });
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 180),
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
                        "Change Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(223, 255, 255, 255),
                          fontSize: MediaQuery.of(context).size.width / 12,
                          shadows: [
                            Shadow(
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.30),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                            onTap: () => {
                                  setState(() {
                                    _obscureCurrentPassword =
                                        !_obscureCurrentPassword;
                                  })
                                },
                            title: 'Current Password',
                            iconData: Icons.lock,
                            controller: _controllerCurrentPassword,
                            hasObscureText: true,
                            obscureText: _obscureCurrentPassword,
                            errorMessage: errorCurrentPassword),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                            onTap: () => {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  })
                                },
                            title: 'New Password',
                            iconData: Icons.lock,
                            controller: _controllerNewPassword,
                            hasObscureText: true,
                            obscureText: _obscureNewPassword,
                            errorMessage: errorNewPassword),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: CustomEntryField(
                            onTap: () => {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  })
                                },
                            title: 'Confirm New Password',
                            iconData: Icons.lock,
                            controller: _controllerConfirmPassword,
                            hasObscureText: true,
                            obscureText: _obscureConfirmPassword,
                            errorMessage: errorConfirmPassword),
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: CustomButton(
                          onTap: () async {
                            isAlertSet = false;
                            await checkInternetConnection();
                            if (isDeviceConnected) {
                              changePassword();
                            }
                          },
                          withGradient: false,
                          text: "Update Password",
                          rowText: false,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                        ),
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
