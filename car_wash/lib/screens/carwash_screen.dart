import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/auth.dart';

class CarWashScreen extends StatefulWidget {
  const CarWashScreen({super.key});

  @override
  State<CarWashScreen> createState() => _CarWashState();
}

class _CarWashState extends State<CarWashScreen> {
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.64,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/carwash.png"),
              fit: BoxFit.cover,
            )),
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 1.1),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 34, 34, 34),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 25, top: 15, right: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: 4,
                              itemSize: 25.0,
                              unratedColor:
                                  const Color.fromARGB(195, 255, 255, 255),
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {},
                              ignoreGestures: true,
                            ),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.width * 0.49,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 2, 196, 21),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Text(
                          'CAR WASH SERVICE',
                          style: TextStyle(
                            color: const Color.fromARGB(223, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.0, 1.0),
                                blurRadius: 7.0,
                                color: Colors.black.withOpacity(0.30),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Positioned(
                  top: 180,
                  right: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 2, 196, 21),
                      borderRadius: BorderRadius.circular(50),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/clock.png"),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 50, 50, 50)
                              .withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 34, 34),
            ),
            child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'CarWash Quick JET Romania',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Calea Stan Vidrighin 6, Timișoara 300013',
                        style: TextStyle(
                          color: const Color.fromARGB(197, 216, 216, 216),
                          fontSize: MediaQuery.of(context).size.width / 30,
                        ),
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      height: 1,
                      color: const Color.fromARGB(255, 157, 157, 157),
                    ),
                    Text(
                      'Availability',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 17.0,
                      runSpacing: 15.0,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 5.5,
                            height: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 2, 2, 2)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 2, 196, 21),
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color:
                                      const Color.fromARGB(255, 157, 157, 157),
                                  size: MediaQuery.of(context).size.width / 11,
                                ),
                                Text(
                                  '1',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 157, 157, 157),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width / 5.5,
                            height: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 2, 2, 2)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color:
                                      const Color.fromARGB(255, 157, 157, 157),
                                  size: MediaQuery.of(context).size.width / 11,
                                ),
                                Text(
                                  '2',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 157, 157, 157),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width / 5.5,
                            height: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 2, 2, 2)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color:
                                      const Color.fromARGB(255, 157, 157, 157),
                                  size: MediaQuery.of(context).size.width / 11,
                                ),
                                Text(
                                  '3',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 157, 157, 157),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width / 5.5,
                            height: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 2, 2, 2)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 2, 196, 21),
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.drive_eta,
                                  color:
                                      const Color.fromARGB(255, 157, 157, 157),
                                  size: MediaQuery.of(context).size.width / 11,
                                ),
                                Text(
                                  '4',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 157, 157, 157),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width / 5.5,
                            height: MediaQuery.of(context).size.width / 5.5,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 2, 2, 2)
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 2, 196, 21),
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_shipping,
                                  color:
                                      const Color.fromARGB(255, 157, 157, 157),
                                  size: MediaQuery.of(context).size.width / 11,
                                ),
                                Text(
                                  '5',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 157, 157, 157),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      height: 1,
                      color: const Color.fromARGB(255, 157, 157, 157),
                    ),
                    Text(
                      'Facilities',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sisteme de suflare puternică pentru a usca eficient vehiculul după spălare. Dispozitive reglabile pentru direcționarea fluxului de aer în zonele dorite. tații self-service cu aspiratoare puternice pentru curățarea interioară a vehiculului. Accesoriile adecvate pentru aspirare eficientă a tapițeriei, covorașelor și altor zone dificil de curățat.',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 181, 181, 181),
                        fontSize: MediaQuery.of(context).size.width / 28,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      height: 1,
                      color: const Color.fromARGB(255, 157, 157, 157),
                    ),
                    Text(
                      'Clients Review',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color.fromARGB(255, 34, 34, 34),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 2, 2, 2)
                                        .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Username',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      RatingBar.builder(
                                        initialRating: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber),
                                        onRatingUpdate: (rating) {},
                                        ignoreGestures: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'I love it! fv df vdf gvd f df v gdfg fd gd f g df g  fd gd  g df g df gfd ff g fd g f g df gd fg d fg  dgvbfgv bf d f b df v d ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          197, 216, 216, 216),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                    ),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color.fromARGB(255, 34, 34, 34),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 2, 2, 2)
                                        .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Username',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      RatingBar.builder(
                                        initialRating: 5,
                                        itemSize: 20.0,
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber),
                                        onRatingUpdate: (rating) {},
                                        ignoreGestures: true,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'I love it! fv df vdf gvd f df v gdfg fd gd f g df g  fd gd  g df g df gfd ff g fd g f g df gd fg d fg  dgvbfgv bf d f b df v d ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          197, 216, 216, 216),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                    ),
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      height: 1,
                      color: const Color.fromARGB(255, 157, 157, 157),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FlutterPhoneDirectCaller.callNumber('+4076545789');
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: const Color.fromARGB(255, 34, 34, 34),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 2, 2, 2)
                                        .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color.fromARGB(255, 26, 26, 26),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(children: [
                                Icon(Icons.phone,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216)),
                                const SizedBox(width: 5),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 23,
                                  ),
                                ),
                              ])),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: const Color.fromARGB(255, 34, 34, 34),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 2, 2, 2)
                                        .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color.fromARGB(255, 26, 26, 26),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(children: [
                                Icon(Icons.shopping_cart,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216)),
                                const SizedBox(width: 5),
                                Text(
                                  'Buy tokens',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 23,
                                  ),
                                ),
                              ])),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: const Color.fromARGB(255, 34, 34, 34),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 2, 2, 2)
                                        .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color.fromARGB(255, 26, 26, 26),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(children: [
                                Icon(Icons.map,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216)),
                                const SizedBox(width: 5),
                                Text(
                                  'Map',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 23,
                                  ),
                                ),
                              ])),
                        ),
                      ],
                    ),
                    const SizedBox(height: 75),
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
