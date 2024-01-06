import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:car_wash/screens/home_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/auth.dart';

class CarWashScreen extends StatefulWidget {
  final CarWash carwash;
  const CarWashScreen({Key? key, required this.carwash}) : super(key: key);

  @override
  State<CarWashScreen> createState() => _CarWashState();
}

class _CarWashState extends State<CarWashScreen> {
  int index = 1;
  final User? user = Auth().currentUser;
  String username = '';
  final TextEditingController _userReview = TextEditingController();
  double rating = 0.0;

  String managerId = '';
  String carwashId = '';

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

  Future<void> getUserDetails() async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .get();
      setState(() {
        if (userQuerySnapshot.exists) {
          username = userQuerySnapshot['username'];
        }
      });
    } catch (e) {
      print('Error getting documents $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    findId(widget.carwash.name, widget.carwash.address);
  }

  Future findId(String name, String address) async {
    final managers =
        await FirebaseFirestore.instance.collection('Managers').get();

    if (managers.docs.isNotEmpty) {
      for (var manager in managers.docs) {
        var managerCarWashes = await FirebaseFirestore.instance
            .collection('Managers')
            .doc(manager.id)
            .collection('car-wash')
            .get();
        for (var element in managerCarWashes.docs) {
          if (element['name'] == name && element['address'] == address) {
            managerId = manager.id;
            carwashId = element.id;
          }
        }
      }
    }
  }

  Widget generateSeats(int nr, IconData icon) {
    return Container(
        width: MediaQuery.of(context).size.width / 5.5,
        height: MediaQuery.of(context).size.width / 5.5,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 34, 34, 34),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 2, 2, 2).withOpacity(0.5),
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
              icon,
              color: const Color.fromARGB(255, 157, 157, 157),
              size: MediaQuery.of(context).size.width / 11,
            ),
            Text(
              nr.toString(),
              style: TextStyle(
                color: const Color.fromARGB(255, 157, 157, 157),
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width / 30,
              ),
            ),
          ],
        ));
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
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FirebaseImageProvider(FirebaseUrl(widget.carwash.image)),
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
                              initialRating: widget.carwash.averageRating(
                                  widget.carwash.nrRatings,
                                  widget.carwash.totalRatings),
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
                        widget.carwash.name,
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
                        widget.carwash.address,
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
                        for (var i = 0;
                            i < widget.carwash.smallVehicleSeats;
                            i++)
                          generateSeats(i + 1, Icons.drive_eta),
                        for (var i = widget.carwash.smallVehicleSeats;
                            i <
                                widget.carwash.bigVehicleSeats +
                                    widget.carwash.smallVehicleSeats;
                            i++)
                          generateSeats(i + 1, Icons.local_shipping),
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
                      widget.carwash.facilities,
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
                      height: widget.carwash.reviews.isEmpty ? 30 : 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          if (widget.carwash.reviews.isEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                "No reviews..",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(197, 216, 216, 216),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 30,
                                ),
                              ),
                            )
                          else
                            for (var review in widget.carwash.reviews)
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color:
                                        const Color.fromARGB(255, 34, 34, 34),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            const Color.fromARGB(255, 2, 2, 2)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            review.username,
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
                                            initialRating:
                                                review.rating.toDouble(),
                                            itemSize: 20.0,
                                            itemBuilder: (context, _) =>
                                                const Icon(Icons.star,
                                                    color: Colors.amber),
                                            onRatingUpdate: (rating) {},
                                            ignoreGestures: true,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        review.feedback,
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              197, 216, 216, 216),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: const Color.fromARGB(255, 157, 157, 157),
                          size: MediaQuery.of(context).size.width / 17,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          username,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 157, 157, 157),
                            fontSize: MediaQuery.of(context).size.width / 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    RatingBar.builder(
                      minRating: 1,
                      itemSize: 30.0,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                    TextField(
                      controller: _userReview,
                      decoration: const InputDecoration(
                        hintText: "Write a review..",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        counterStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.white),
                      maxLength: 200,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (rating != 0.0 || _userReview.text != '') {
                          if (rating != 0.0) {
                            widget.carwash.addRating(
                                rating.toInt(), managerId, carwashId);
                          }
                          widget.carwash.addReview(username, _userReview,
                              rating.toInt(), managerId, carwashId);
                        }

                        widget.carwash.reviews =
                            await getReviews(managerId, carwashId);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarWashScreen(
                                    carwash: widget.carwash,
                                  )),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 13,
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                        child: Text(
                          'Post Review >',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 25,
                            shadows: const [
                              Shadow(color: Colors.grey, offset: Offset(0, -5))
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
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
                            FlutterPhoneDirectCaller.callNumber(
                                widget.carwash.phone.toString());
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
