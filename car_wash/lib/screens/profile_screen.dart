import 'package:car_wash/screens/change_password.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = Auth().currentUser;
  String username = '';
  String email = '';
  int index = 2;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .get();
      setState(() {
        if (userQuerySnapshot.exists) {
          username = userQuerySnapshot['username'];
          email = userQuerySnapshot['email'];
        }
      });
    } catch (e) {
      print('Error getting documents $e');
    }
  }

  Future<void> logOut() async {
    await Auth().signOut();
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 1,
            color: const Color.fromARGB(255, 157, 157, 157),
          ),
        ],
      ),
    );
  }

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
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
                    username,
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
                    email,
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
                  const SizedBox(height: 20),
                  _customProfileButton(
                      'Transaction', Icons.account_balance_wallet, () {}),
                  const SizedBox(height: 20),
                  _customProfileButton('Logout', Icons.logout, () {
                    logOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
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
