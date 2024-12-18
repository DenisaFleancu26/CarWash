import 'dart:ui';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:car_wash/widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final User? user = AuthController().currentUser;
  bool display = true;
  final CarWashController _carWashController = CarWashController();
  String date =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

  @override
  void initState() {
    super.initState();
    _carWashController.fetchCarWashesFromFirebase(
      displayInfo: () => setState(() => display = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: CustomNavigationBar(index: index),
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
                            top: MediaQuery.of(context).size.width * 0.15,
                            left: MediaQuery.of(context).size.width * 0.20,
                            right: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: TextField(
                            controller: _carWashController.searchController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: Locales.string(context, 'search'),
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _carWashController.carWashes =
                                        _carWashController.saveCarWashes;
                                    _carWashController.searchController.clear();
                                  });
                                },
                              ),
                              suffixIcon: const Icon(Icons.search,
                                  color: Color.fromARGB(255, 164, 164, 164)),
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
                              _carWashController.searchCarWashes(
                                query: value,
                                onSuccess: (result) => setState(() =>
                                    _carWashController.carWashes = result),
                              );
                            },
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: _carWashController.carWashes.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: FirebaseDatabase.instance
                                          .ref(_carWashController
                                              .carWashes.entries
                                              .elementAt(index)
                                              .key)
                                          .child('offer')
                                          .onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          Map<dynamic, dynamic> data = snapshot
                                              .data!
                                              .snapshot
                                              .value as Map<dynamic, dynamic>;
                                          String offerDate =
                                              data['data'] as String;
                                          int offerType = data['type'] as int;

                                          return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) => CarWashScreen(
                                                            carwash:
                                                                _carWashController
                                                                    .carWashes
                                                                    .entries
                                                                    .elementAt(
                                                                        index),
                                                            isManager:
                                                                _carWashController
                                                                    .authController
                                                                    .isManager))));
                                              },
                                              child: Stack(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.016),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                        sigmaX: 4,
                                                        sigmaY: 4,
                                                      ),
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.19,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          color: Color.fromARGB(
                                                              70,
                                                              122,
                                                              122,
                                                              122),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.33,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.19,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image: FirebaseImageProvider(FirebaseUrl(_carWashController
                                                                      .carWashes
                                                                      .entries
                                                                      .elementAt(
                                                                          index)
                                                                      .value
                                                                      .image)),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
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
                                                                      RatingBar
                                                                          .builder(
                                                                        initialRating: _carWashController.averageRating(
                                                                            _carWashController.carWashes.entries.elementAt(index).value.nrRatings,
                                                                            _carWashController.carWashes.entries.elementAt(index).value.totalRatings),
                                                                        itemSize:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.06,
                                                                        unratedColor: const Color
                                                                            .fromARGB(
                                                                            195,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        itemBuilder: (context, _) => const Icon(
                                                                            Icons
                                                                                .star,
                                                                            color:
                                                                                Colors.amber),
                                                                        onRatingUpdate:
                                                                            (rating) {},
                                                                        ignoreGestures:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              2),
                                                                      Text(
                                                                        '(${_carWashController.carWashes.entries.elementAt(index).value.nrRatings})',
                                                                        style:
                                                                            TextStyle(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              195,
                                                                              190,
                                                                              190,
                                                                              190),
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width / 30,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.48,
                                                                  child: Text(
                                                                    Locales.currentLocale(context)?.languageCode ==
                                                                            'ro'
                                                                        ? _carWashController
                                                                            .carWashes
                                                                            .entries
                                                                            .elementAt(
                                                                                index)
                                                                            .value
                                                                            .name_ro
                                                                        : _carWashController
                                                                            .carWashes
                                                                            .entries
                                                                            .elementAt(index)
                                                                            .value
                                                                            .name_en,
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          223,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width /
                                                                              20,
                                                                      shadows: [
                                                                        Shadow(
                                                                          offset: const Offset(
                                                                              3.0,
                                                                              3.0),
                                                                          blurRadius:
                                                                              10.0,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.30),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.47,
                                                                  child: Text(
                                                                    Locales.currentLocale(context)?.languageCode ==
                                                                            'ro'
                                                                        ? _carWashController
                                                                            .carWashes
                                                                            .entries
                                                                            .elementAt(
                                                                                index)
                                                                            .value
                                                                            .address_ro
                                                                        : _carWashController
                                                                            .carWashes
                                                                            .entries
                                                                            .elementAt(index)
                                                                            .value
                                                                            .address_en,
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          197,
                                                                          216,
                                                                          216,
                                                                          216),
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width /
                                                                              50,
                                                                      shadows: [
                                                                        Shadow(
                                                                          offset: const Offset(
                                                                              3.0,
                                                                              3.0),
                                                                          blurRadius:
                                                                              10.0,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.30),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 3,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.47,
                                                                  child: Text(
                                                                    Locales.string(
                                                                            context,
                                                                            'token') +
                                                                        " ${_carWashController.carWashes.entries.elementAt(index).value.price} RON",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width /
                                                                              23,
                                                                      shadows: [
                                                                        Shadow(
                                                                          offset: const Offset(
                                                                              3.0,
                                                                              3.0),
                                                                          blurRadius:
                                                                              10.0,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.30),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 3,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (offerType != 0 &&
                                                    offerDate == date)
                                                  Positioned(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1035,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.041,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.117,
                                                      decoration:
                                                          const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/offer.png"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ]));
                                        } else
                                          return Container();
                                      });
                                }))
                      ]))));
  }
}
