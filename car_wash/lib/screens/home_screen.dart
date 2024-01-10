import 'dart:ui';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/models/review.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final User? user = AuthController().currentUser;
  List<CarWash> carWashes = [];
  List<CarWash> saveCarWashes = [];
  TextEditingController searchController = TextEditingController();
  bool display = true;

  final items = const <Widget>[
    Icon(Icons.map_rounded, size: 30),
    Icon(Icons.home, size: 30),
    Icon(Icons.account_circle, size: 30),
  ];

  @override
  void initState() {
    super.initState();
    fetchCarWashesFromFirebase();
  }

  Future<List<CarWash>> fetchCarWashesFromFirebase() async {
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
          List<Review> reviews = await getReviews(manager.id, element.id);
          CarWash carwash = CarWash(
            name: element['name'],
            hours: element['hours'],
            image: element['image'] ?? '',
            address: element['address'],
            facilities: element['facilities'],
            phone: element['phone'],
            smallVehicleSeats: element['small-vehicle'],
            bigVehicleSeats: element['big-vehicle'],
            price: (element['price']).toDouble(),
            nrRatings: element['nrRatings'],
            totalRatings: element['totalRatings'],
            reviews: reviews,
          );
          carWashes.add(carwash);
        }
      }
    }
    try {
      setState(() {
        display = false;
        saveCarWashes = carWashes;
      });
    } catch (e, stackTrace) {
      if (!mounted) {
        print('Error: $e\n$stackTrace');
      }
    }

    return carWashes;
  }

  void searchCarWashes(String query) {
    List<CarWash> searchResults = [];

    for (var carwash in carWashes) {
      if (carwash.name.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(carwash);
      }
    }

    setState(() {
      carWashes = searchResults;
    });
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
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }
                break;
            }
          }),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                )),
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
                                  image: AssetImage(
                                      "assets/images/background.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 50,
                            left: MediaQuery.of(context).size.width * 0.25,
                            right: 30,
                          ),
                          child: TextField(
                            controller: searchController,
                            textAlign:
                                TextAlign.right, // Aliniere text în dreapta
                            decoration: InputDecoration(
                              hintText: 'Search a CarWash..',
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.grey), // Icon de "back"
                                onPressed: () {
                                  setState(() {
                                    carWashes = saveCarWashes;
                                    searchController.clear();
                                  });
                                },
                              ),
                              suffixIcon: const Icon(Icons.search,
                                  color: Color.fromARGB(
                                      255, 164, 164, 164)), // Icon după text
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 82, 82, 82)),
                              ),
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 164, 164, 164)),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              searchCarWashes(value);
                            },
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: carWashes.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  CarWashScreen(
                                                      carwash:
                                                          carWashes[index]))));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 4,
                                            sigmaY: 4,
                                          ),
                                          child: Container(
                                            height: 160,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Color.fromARGB(
                                                  70, 122, 122, 122),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.33,
                                                  height: 160,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                    ),
                                                    image: DecorationImage(
                                                      image:
                                                          FirebaseImageProvider(
                                                              FirebaseUrl(
                                                                  carWashes[
                                                                          index]
                                                                      .image)),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating: carWashes[
                                                                    index]
                                                                .averageRating(
                                                                    carWashes[
                                                                            index]
                                                                        .nrRatings,
                                                                    carWashes[
                                                                            index]
                                                                        .totalRatings),
                                                            itemSize: 20.0,
                                                            unratedColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    195,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            itemBuilder: (context,
                                                                    _) =>
                                                                const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber),
                                                            onRatingUpdate:
                                                                (rating) {},
                                                            ignoreGestures:
                                                                true,
                                                          ),
                                                          const SizedBox(
                                                              width: 2),
                                                          Text(
                                                            '(${carWashes[index].nrRatings})',
                                                            style: TextStyle(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  195,
                                                                  190,
                                                                  190,
                                                                  190),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  30,
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.48,
                                                      child: Text(
                                                        carWashes[index].name,
                                                        style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(223,
                                                              255, 255, 255),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                          shadows: [
                                                            Shadow(
                                                              offset:
                                                                  const Offset(
                                                                      3.0, 3.0),
                                                              blurRadius: 10.0,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.30),
                                                            ),
                                                          ],
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.47,
                                                      child: Text(
                                                        carWashes[index]
                                                            .address,
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              197,
                                                              216,
                                                              216,
                                                              216),
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              50,
                                                          shadows: [
                                                            Shadow(
                                                              offset:
                                                                  const Offset(
                                                                      3.0, 3.0),
                                                              blurRadius: 10.0,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.30),
                                                            ),
                                                          ],
                                                        ),
                                                        softWrap: true,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.47,
                                                      child: Text(
                                                        "Token: " +
                                                            carWashes[index]
                                                                .price
                                                                .toString() +
                                                            " RON",
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              23,
                                                          shadows: [
                                                            Shadow(
                                                              offset:
                                                                  const Offset(
                                                                      3.0, 3.0),
                                                              blurRadius: 10.0,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.30),
                                                            ),
                                                          ],
                                                        ),
                                                        softWrap: true,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }))
                      ]))));
  }
}
