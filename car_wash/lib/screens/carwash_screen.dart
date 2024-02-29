import 'dart:async';

import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/controllers/payment_controller.dart';
import 'package:car_wash/controllers/user_controller.dart';
import 'package:car_wash/models/announcement.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/announcement_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/offer_screen.dart';
import 'package:car_wash/screens/qr_screen.dart';
import 'package:car_wash/widgets/horizontal_line.dart';
import 'package:car_wash/widgets/meniu_button.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:car_wash/widgets/spot_button.dart';
import 'package:car_wash/widgets/spot_generate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:translator/translator.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

class CarWashScreen extends StatefulWidget {
  final MapEntry<String, CarWash> carwash;
  final bool isManager;
  const CarWashScreen(
      {Key? key, required this.carwash, required this.isManager})
      : super(key: key);

  @override
  State<CarWashScreen> createState() => _CarWashState();
}

class _CarWashState extends State<CarWashScreen> {
  int index = 1;
  int tokens = 0;
  final User? user = AuthController().currentUser;
  final UserController _userController = UserController();
  final CarWashController _carWashController = CarWashController();
  final PaymentController _paymentController = PaymentController();
  bool display = true;
  Map<String, Announcement> announcements = {};
  String date =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

  final transaltor = GoogleTranslator();

  @override
  void initState() {
    _userController.getUsername(
        displayUsername: (username) =>
            setState(() => _userController.username = username),
        collection: 'Users');

    _carWashController.findId(
        name: widget.carwash.value.name_en,
        address: widget.carwash.value.address_en);

    FirebaseDatabase.instance
        .ref(widget.carwash.key)
        .child('announcements')
        .onValue
        .listen((event) {
      Map<String, Announcement> adds = {};
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          var originalLanguage;
          var newLanguage;
          if (mounted) {
            originalLanguage = langdetect.detect(value['message']);
            newLanguage = Locales.currentLocale(context)!.languageCode;
          }
          if (originalLanguage != newLanguage) {
            transaltor
                .translate(value['message'],
                    to: newLanguage, from: originalLanguage)
                .then((result) {
              Announcement add =
                  Announcement(message: result.toString(), date: value['data']);
              if (!adds.containsKey(key)) {
                setState(() {
                  adds[key] = add;
                });
              }
            });
          } else {
            Announcement add =
                Announcement(message: value['message'], date: value['data']);
            if (!adds.entries.contains(add)) {
              setState(() {
                adds[key] = add;
              });
            }
          }
        });
      }
      announcements = adds;
    });
    display = false;

    super.initState();
  }

  Future showSpots() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromARGB(255, 216, 216, 216),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              height: widget.carwash.value.bigVehicleSeats +
                          widget.carwash.value.smallVehicleSeats >
                      4
                  ? MediaQuery.of(context).size.height * 0.33
                  : MediaQuery.of(context).size.height * 0.22,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleText(
                          'broken_spot',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            fontSize: MediaQuery.of(context).size.width / 20,
                          ),
                        ),
                        GestureDetector(
                            child: Icon(Icons.highlight_off,
                                color: const Color.fromARGB(255, 34, 34, 34),
                                size: MediaQuery.of(context).size.width / 15),
                            onTap: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: [
                        for (var i = 0;
                            i < widget.carwash.value.smallVehicleSeats;
                            i++)
                          SpotButton(
                            nr: i + 1,
                            icon: Icons.drive_eta,
                            id: widget.carwash.key,
                            onButtonPressed: (index, isPressed) {
                              updateActivatedIndices(index, isPressed);
                            },
                          ),
                        for (var i = widget.carwash.value.smallVehicleSeats;
                            i <
                                widget.carwash.value.bigVehicleSeats +
                                    widget.carwash.value.smallVehicleSeats;
                            i++)
                          SpotButton(
                            nr: i + 1,
                            icon: Icons.local_shipping,
                            id: widget.carwash.key,
                            onButtonPressed: (index, isPressed) {
                              updateActivatedIndices(index, isPressed);
                            },
                          ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info,
                          size: MediaQuery.of(context).size.width / 25,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: LocaleText(
                            'broken_spot_message',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: MediaQuery.of(context).size.width / 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
            );
          });
        });
  }

  void updateActivatedIndices(int index, bool isPressed) {
    FirebaseDatabase.instance
        .ref(widget.carwash.key)
        .child('spots')
        .child(index.toString())
        .child('broken')
        .set(isPressed == true ? 1 : 0);
  }

  Future showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: const Color.fromARGB(255, 216, 216, 216),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref(widget.carwash.key)
                      .child('offer')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      Map<dynamic, dynamic> data = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      String offerDate = data['data'] as String;
                      int offerType = data['type'] as int;
                      double offerValue = data['value'].toDouble();

                      return SizedBox(
                        height: (offerType == 0 || offerDate != date)
                            ? MediaQuery.of(context).size.height * 0.2
                            : MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (offerType != 0 && offerDate == date)
                              LocaleText(
                                textAlign: TextAlign.center,
                                'todays_offer',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 23, 156, 0),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (offerType != 0 && offerDate == date)
                              Text(
                                textAlign: TextAlign.center,
                                offerType == 1
                                    ? Locales.string(context, 'offer1')
                                        .replaceAll(
                                            '{discount}', offerValue.toString())
                                    : Locales.string(context, 'offer2')
                                        .replaceAll('{tokens}',
                                            offerValue.toInt().toString()),
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 23, 156, 0),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (offerType != 0 && offerDate == date)
                              HorizontalLine(
                                  distance: MediaQuery.of(context).size.height *
                                      0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MeniuButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      setState(() {
                                        if (tokens > 0) tokens--;
                                      });
                                    }),
                                Row(
                                  children: [
                                    LocaleText(
                                      'tokens',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 34, 34, 34),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$tokens',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 34, 34, 34),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                MeniuButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      setState(() {
                                        tokens++;
                                      });
                                    })
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 34, 34, 34),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      offerType == 1 && offerDate == date
                                          ? '${widget.carwash.value.price * tokens * (100 - offerValue) / 100} RON'
                                          : '${widget.carwash.value.price * tokens} RON',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 34, 34, 34),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                MeniuButton(
                                  icon: Icons.credit_card,
                                  label:
                                      Locales.string(context, 'make_payment'),
                                  onTap: () async {
                                    if (tokens > 0) {
                                      if (user != null) {
                                        await _paymentController
                                            .makePayment((offerType == 1 &&
                                                    offerDate == date)
                                                ? widget.carwash.value.price *
                                                    tokens *
                                                    (100 - offerValue)
                                                : widget.carwash.value.price *
                                                    tokens *
                                                    100)
                                            .then((value) => {
                                                  if (_paymentController
                                                          .successfulPayment ==
                                                      true)
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    QRScreen(
                                                                      tokens:
                                                                          tokens,
                                                                      carWash:
                                                                          widget
                                                                              .carwash,
                                                                      offerDate:
                                                                          offerDate,
                                                                      offerType:
                                                                          offerType,
                                                                      offerValue:
                                                                          offerValue,
                                                                    )))
                                                });
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      }
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    } else
                      return Container();
                  });
            },
          );
        });
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
                        alignment: Alignment.center,
                        color: const Color.fromARGB(255, 18, 18, 18),
                        child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: FirebaseImageProvider(
                            FirebaseUrl(widget.carwash.value.image)),
                        fit: BoxFit.cover,
                      )),
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, 1.05),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 34, 34, 34),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(50)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.06,
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            _carWashController.averageRating(
                                                widget.carwash.value.nrRatings,
                                                widget.carwash.value
                                                    .totalRatings),
                                        itemSize:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        unratedColor: const Color.fromARGB(
                                            195, 255, 255, 255),
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber),
                                        onRatingUpdate: (rating) {},
                                        ignoreGestures: true,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '(${widget.carwash.value.nrRatings})',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              195, 190, 190, 190),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          if (widget.carwash.value.hours == 'non-stop')
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.22,
                              right: MediaQuery.of(context).size.width * 0.1,
                              child: Container(
                                  width: Locales.currentLocale(context)
                                              ?.languageCode ==
                                          'ro'
                                      ? MediaQuery.of(context).size.width * 0.56
                                      : MediaQuery.of(context).size.width *
                                          0.52,
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 2, 196, 21),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.013,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    child: LocaleText(
                                      'carwash_service',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            223, 255, 255, 255),
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        shadows: [
                                          Shadow(
                                            offset: const Offset(2.0, 1.0),
                                            blurRadius: 7.0,
                                            color:
                                                Colors.black.withOpacity(0.30),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          if (widget.carwash.value.hours == 'non-stop')
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.21,
                              right: MediaQuery.of(context).size.width * 0.05,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 2, 196, 21),
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/clock.png"),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 50, 50, 50)
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
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  Locales.currentLocale(context)
                                              ?.languageCode ==
                                          'ro'
                                      ? widget.carwash.value.name_ro
                                      : widget.carwash.value.name_en,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 16,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  Locales.currentLocale(context)
                                              ?.languageCode ==
                                          'ro'
                                      ? widget.carwash.value.address_ro
                                      : widget.carwash.value.address_en,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                  softWrap: true,
                                  maxLines: 3,
                                ),
                              ),
                              if (announcements.isNotEmpty)
                                const HorizontalLine(distance: 15),
                              if (announcements.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: MediaQuery.of(context).size.width /
                                          20,
                                      color:
                                          const Color.fromARGB(255, 240, 0, 0),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: LocaleText(
                                        'new_announcements',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 240, 0, 0),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              for (var add in announcements.entries)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            Locales.string(context,
                                                    'announcement_date')
                                                .replaceAll(
                                                    '{date}', add.value.date),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  30,
                                              color: Colors.grey,
                                            )),
                                        if (widget.isManager)
                                          GestureDetector(
                                            onTap: () => {
                                              setState(() {
                                                announcements.remove(add);
                                              }),
                                              _carWashController
                                                  .deleteAnnouncement(
                                                      announcement: add.key,
                                                      id: widget.carwash.key)
                                            },
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              child: Center(
                                                child: LocaleText('delete',
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              30,
                                                      shadows: const [
                                                        Shadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, -2))
                                                      ],
                                                      color: Colors.transparent,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Colors.grey,
                                                    )),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      add.value.message,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                28,
                                      ),
                                    ),
                                  ],
                                ),
                              const HorizontalLine(distance: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LocaleText(
                                    'availability',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                    ),
                                  ),
                                  if (widget.isManager)
                                    GestureDetector(
                                      onTap: () => {
                                        showSpots(),
                                      },
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        child: Center(
                                          child: LocaleText(
                                              'broken_spot_button',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    30,
                                                shadows: const [
                                                  Shadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0, -2))
                                                ],
                                                color: Colors.transparent,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.grey,
                                              )),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Wrap(
                                spacing: 15.0,
                                runSpacing: 15.0,
                                children: [
                                  for (var i = 0;
                                      i <
                                          widget
                                              .carwash.value.smallVehicleSeats;
                                      i++)
                                    SpotGenerate(
                                        id: widget.carwash.key,
                                        icon: Icons.drive_eta,
                                        nr: i + 1),
                                  for (var i = widget
                                          .carwash.value.smallVehicleSeats;
                                      i <
                                          widget.carwash.value.bigVehicleSeats +
                                              widget.carwash.value
                                                  .smallVehicleSeats;
                                      i++)
                                    SpotGenerate(
                                        id: widget.carwash.key,
                                        icon: Icons.local_shipping,
                                        nr: i + 1),
                                ],
                              ),
                              const HorizontalLine(distance: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LocaleText(
                                    'facilities',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                    ),
                                  ),
                                  if (widget.carwash.value.hours != 'non-stop')
                                    Text(
                                      widget.carwash.value.hours,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Text(
                                Locales.currentLocale(context)?.languageCode ==
                                        'ro'
                                    ? widget.carwash.value.facilities_ro
                                    : widget.carwash.value.facilities_en,
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 181, 181, 181),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                Locales.string(context, 'token') +
                                    ' ${widget.carwash.value.price} RON',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 23,
                                ),
                              ),
                              const HorizontalLine(distance: 15),
                              LocaleText(
                                'clients_review',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              SizedBox(
                                height: widget.carwash.value.reviews.isEmpty
                                    ? 30
                                    : 100,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    if (widget.carwash.value.reviews.isEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: LocaleText(
                                          'no_reviews',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                197, 216, 216, 216),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                          ),
                                        ),
                                      )
                                    else
                                      for (var review
                                          in widget.carwash.value.reviews)
                                        Container(
                                            margin: EdgeInsets.all(
                                                MediaQuery.of(context).size.width *
                                                    0.03),
                                            height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: const Color.fromARGB(
                                                  255, 34, 34, 34),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 2, 2, 2)
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.account_circle,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              157,
                                                              157,
                                                              157),
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      review.username,
                                                      style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            30,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    RatingBar.builder(
                                                      initialRating: review
                                                          .rating
                                                          .toDouble(),
                                                      itemSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.025,
                                                      itemBuilder: (context,
                                                              _) =>
                                                          const Icon(Icons.star,
                                                              color:
                                                                  Colors.amber),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                      ignoreGestures: true,
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  review.feedback,
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        197, 216, 216, 216),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            30,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01)
                                              ],
                                            )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_userController.username != '')
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: const Color.fromARGB(
                                          255, 157, 157, 157),
                                      size: MediaQuery.of(context).size.width /
                                          17,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _userController.username,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 157, 157, 157),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_userController.username != '')
                                const SizedBox(height: 5),
                              if (_userController.username != '')
                                RatingBar.builder(
                                  minRating: 1,
                                  itemSize: 30.0,
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  onRatingUpdate: (rating) => setState(() {
                                    _carWashController.rating = rating;
                                  }),
                                ),
                              if (_userController.username != '')
                                TextField(
                                  controller: _carWashController.userReview,
                                  decoration: InputDecoration(
                                    hintText:
                                        Locales.string(context, 'write_review'),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    counterStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  maxLength: 200,
                                ),
                              if (_userController.username != '')
                                GestureDetector(
                                  onTap: () {
                                    _carWashController.postReviewButton(
                                        carwash: widget.carwash.value,
                                        username: _userController.username);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CarWashScreen(
                                                carwash: widget.carwash,
                                                isManager: false,
                                              )),
                                    );
                                  },
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    child: LocaleText(
                                      'post_review',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        shadows: const [
                                          Shadow(
                                              color: Colors.grey,
                                              offset: Offset(0, -2))
                                        ],
                                        color: Colors.transparent,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              const HorizontalLine(distance: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (!widget.isManager)
                                    MeniuButton(
                                      icon: Icons.phone,
                                      label: Locales.string(context, 'call'),
                                      onTap: () {
                                        FlutterPhoneDirectCaller.callNumber(
                                            widget.carwash.value.phone
                                                .toString());
                                      },
                                    ),
                                  if (widget.isManager)
                                    MeniuButton(
                                      icon: Icons.campaign,
                                      label: Locales.string(
                                          context, 'announcement'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AnnouncementScreen(
                                                    carwash: widget.carwash,
                                                    controller:
                                                        _carWashController,
                                                  )),
                                        );
                                      },
                                    ),
                                  if (!widget.isManager)
                                    MeniuButton(
                                      icon: Icons.shopping_cart,
                                      label:
                                          Locales.string(context, 'buy_tokens'),
                                      onTap: () {
                                        showBottomSheet();
                                      },
                                    ),
                                  if (widget.isManager)
                                    MeniuButton(
                                      icon: Icons.local_offer,
                                      label: Locales.string(context, 'offer'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OfferScreen(
                                                    controller:
                                                        _carWashController,
                                                    carwash: widget.carwash,
                                                  )),
                                        );
                                      },
                                    ),
                                  MeniuButton(
                                    icon: Icons.map,
                                    label: Locales.string(context, 'map'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapScreen(
                                                address: widget
                                                    .carwash.value.address_ro)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                            ],
                          )),
                    ),
                  ],
                )),
    );
  }
}
