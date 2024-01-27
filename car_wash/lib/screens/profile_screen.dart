import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/user_controller.dart';
import 'package:car_wash/screens/change_password.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/transaction_screen.dart';
import 'package:car_wash/widgets/horizontal_line.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int index = 2;
  bool display = true;

  final AuthController _authController = AuthController();
  final UserController _userController = UserController();
  final User? user = AuthController().currentUser;

  @override
  void initState() {
    super.initState();
    _authController.checkIsManager(id: user!.uid).whenComplete(() => {
          if (_authController.isManager)
            {
              _userController.getUserDetails(
                  displayInfo: () => setState(() => display = false),
                  collection: 'Managers')
            }
          else
            {
              _userController.getUserDetails(
                  displayInfo: () => setState(() => display = false),
                  collection: 'Users')
            }
        });
  }

  Widget _customProfileButton(
      String title, IconData icon, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: const Color.fromARGB(255, 157, 157, 157),
                size: MediaQuery.of(context).size.width / 15,
                shadows: [
                  Shadow(
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onTap,
                child: SizedBox(
                  height: 30,
                  child: Center(
                      child: Text(
                    title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 23,
                        shadows: [
                          Shadow(
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.30),
                          ),
                        ],
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  )),
                ),
              ),
            ],
          ),
          const HorizontalLine(distance: 5)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(index: index),
      body: SingleChildScrollView(
        child: display
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 255, 255),
                        value: 0.6,
                      ),
                    )
                  ],
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                )),
                child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Text(
                          "Profile",
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
                        const SizedBox(height: 20),
                        Icon(
                          Icons.account_circle,
                          size: MediaQuery.of(context).size.width / 2.5,
                          color: const Color.fromARGB(255, 157, 157, 157),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _userController.username,
                          style: TextStyle(
                            color: const Color.fromARGB(223, 255, 255, 255),
                            fontSize: MediaQuery.of(context).size.width / 18,
                            shadows: [
                              Shadow(
                                offset: const Offset(3.0, 3.0),
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.30),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _userController.email,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 157, 157, 157),
                            fontSize: MediaQuery.of(context).size.width / 28,
                            shadows: [
                              Shadow(
                                offset: const Offset(3.0, 3.0),
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.30),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 70),
                        _customProfileButton('Change Password', Icons.lock, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen()));
                        }),
                        if (!_authController.isManager)
                          const SizedBox(height: 20),
                        if (!_authController.isManager)
                          _customProfileButton(
                              'Transaction', Icons.account_balance_wallet, () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TransactionScreen()));
                          }),
                        const SizedBox(height: 20),
                        _customProfileButton('Logout', Icons.logout, () {
                          _authController.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }),
                      ],
                    )),
              ),
      ),
    );
  }
}
