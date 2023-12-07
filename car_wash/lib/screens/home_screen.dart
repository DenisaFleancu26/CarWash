import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final User? user = Auth().currentUser;

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
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
              break;
          }
        }),
      ),
    );
  }
}
