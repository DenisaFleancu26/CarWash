import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/controllers/payment_controller.dart';
import 'package:car_wash/controllers/user_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/announcement_screen.dart';
import 'package:car_wash/screens/login_screen.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/screens/offer_screen.dart';
import 'package:car_wash/screens/qr_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/horizontal_line.dart';
import 'package:car_wash/widgets/meniu_button.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:car_wash/widgets/spot_button.dart';
import 'package:car_wash/widgets/spot_generate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarWashScreen extends StatefulWidget {
  final CarWash carwash;
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
  Set<int> activatedButtons = {};

  @override
  void initState() {
    _userController.getUsername(
        displayUsername: (username) =>
            setState(() => _userController.username = username),
        collection: 'Users');
    _carWashController.findId(
        name: widget.carwash.name, address: widget.carwash.address);
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
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select the broken spot:',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 34, 34, 34),
                        fontSize: MediaQuery.of(context).size.width / 20,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: [
                        for (var i = 0;
                            i < widget.carwash.smallVehicleSeats;
                            i++)
                          SeatButton(
                            nr: i + 1,
                            icon: Icons.drive_eta,
                            activated:
                                widget.carwash.brokenSpots.contains(i + 1)
                                    ? true
                                    : false,
                            onButtonPressed: (index, isPressed) {
                              updateActivatedIndices(index, isPressed);
                            },
                          ),
                        for (var i = widget.carwash.smallVehicleSeats;
                            i <
                                widget.carwash.bigVehicleSeats +
                                    widget.carwash.smallVehicleSeats;
                            i++)
                          SeatButton(
                            nr: i + 1,
                            icon: Icons.local_shipping,
                            activated:
                                widget.carwash.brokenSpots.contains(i + 1)
                                    ? true
                                    : false,
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
                          child: Text(
                            'You can select one or more spots!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: MediaQuery.of(context).size.width / 30,
                            ),
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    CustomButton(
                      onTap: () {
                        _carWashController.updateBrokenSpots(
                            brokenSpots: widget.carwash.brokenSpots);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CarWashScreen(
                                      carwash: widget.carwash,
                                      isManager: widget.isManager,
                                    )));
                      },
                      withGradient: false,
                      text: "Save",
                      rowText: false,
                      color: const Color.fromARGB(255, 34, 34, 34),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ]),
            );
          });
        });
  }

  void updateActivatedIndices(int index, bool isPressed) {
    setState(() {
      if (isPressed) {
        if (!widget.carwash.brokenSpots.contains(index)) {
          widget.carwash.brokenSpots.add(index);
        }
      } else {
        widget.carwash.brokenSpots.remove(index);
      }
    });
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
            return SizedBox(
              height: (widget.carwash.offerType == 0 ||
                      widget.carwash.offerDate == '')
                  ? MediaQuery.of(context).size.height * 0.2
                  : MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.carwash.offerType != 0 &&
                      widget.carwash.offerDate != '')
                    Text(
                      textAlign: TextAlign.center,
                      "Today's Offer:",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 23, 156, 0),
                          fontSize: MediaQuery.of(context).size.width / 13,
                          fontWeight: FontWeight.bold),
                    ),
                  if (widget.carwash.offerType != 0 &&
                      widget.carwash.offerDate != '')
                    Text(
                      textAlign: TextAlign.center,
                      widget.carwash.offerType == 1
                          ? "${widget.carwash.offerValue}% discount to the final price!"
                          : "Buy ${widget.carwash.offerValue.toInt()} tokens, get one free",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 23, 156, 0),
                          fontSize: MediaQuery.of(context).size.width / 18,
                          fontWeight: FontWeight.bold),
                    ),
                  if (widget.carwash.offerType != 0 &&
                      widget.carwash.offerDate != '')
                    HorizontalLine(
                        distance: MediaQuery.of(context).size.height * 0.03),
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
                          Text(
                            'Tokens:',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              fontSize: MediaQuery.of(context).size.width / 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$tokens',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 34, 34, 34),
                                fontSize:
                                    MediaQuery.of(context).size.width / 20,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 34, 34, 34),
                                fontSize:
                                    MediaQuery.of(context).size.width / 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.carwash.offerType == 1 &&
                                    widget.carwash.offerDate != ''
                                ? '${widget.carwash.price * tokens * (100 - widget.carwash.offerValue) / 100} RON'
                                : '${widget.carwash.price * tokens} RON',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 34, 34, 34),
                                fontSize:
                                    MediaQuery.of(context).size.width / 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      MeniuButton(
                        icon: Icons.credit_card,
                        label: 'Make Payment',
                        onTap: () async {
                          if (tokens > 0) {
                            if (user != null) {
                              await _paymentController
                                  .makePayment((widget.carwash.offerType == 1 &&
                                          widget.carwash.offerDate != '')
                                      ? widget.carwash.price *
                                          tokens *
                                          (100 - widget.carwash.offerValue)
                                      : widget.carwash.price * tokens * 100)
                                  .then((value) => {
                                        if (_paymentController
                                                .successfulPayment ==
                                            true)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRScreen(
                                                        carwashId:
                                                            _carWashController
                                                                .carwashId,
                                                        tokens: tokens,
                                                        carWash: widget.carwash,
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(index: index),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FirebaseImageProvider(FirebaseUrl(widget.carwash.image)),
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.01),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: _carWashController.averageRating(
                                  widget.carwash.nrRatings,
                                  widget.carwash.totalRatings),
                              itemSize: MediaQuery.of(context).size.width / 15,
                              unratedColor:
                                  const Color.fromARGB(195, 255, 255, 255),
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {},
                              ignoreGestures: true,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${widget.carwash.nrRatings})',
                              style: TextStyle(
                                color: const Color.fromARGB(195, 190, 190, 190),
                                fontSize:
                                    MediaQuery.of(context).size.width / 30,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                if (widget.carwash.hours == 'non-stop')
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.22,
                    right: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.52,
                        height: MediaQuery.of(context).size.height * 0.045,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 196, 21),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.013,
                              left: MediaQuery.of(context).size.width * 0.03),
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
                if (widget.carwash.hours == 'non-stop')
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.21,
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
                        widget.carwash.name,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                    if (widget.carwash.announcements.isNotEmpty)
                      const HorizontalLine(distance: 15),
                    if (widget.carwash.announcements.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: MediaQuery.of(context).size.width / 20,
                            color: const Color.fromARGB(255, 240, 0, 0),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              'New Announcement!',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 240, 0, 0),
                                fontSize:
                                    MediaQuery.of(context).size.width / 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    for (var add in widget.carwash.announcements)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Posted on ${add.date}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                    color: Colors.grey,
                                  )),
                              if (widget.isManager)
                                GestureDetector(
                                  onTap: () => {
                                    _carWashController
                                        .deleteAnnouncement(
                                            announcement: add,
                                            carwash: widget.carwash)
                                        .whenComplete(() async {
                                      widget.carwash.announcements =
                                          await _carWashController
                                              .getAnnouncements(
                                                  manager: _carWashController
                                                      .managerId,
                                                  carwash: _carWashController
                                                      .carwashId)
                                              .whenComplete(() =>
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CarWashScreen(
                                                                carwash: widget
                                                                    .carwash,
                                                                isManager: true,
                                                              ))));
                                    }),
                                  },
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width / 25,
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    child: Center(
                                      child: Text("Delete ➔",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.grey,
                                          )),
                                    ),
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            add.message,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: MediaQuery.of(context).size.width / 28,
                            ),
                          ),
                        ],
                      ),
                    const HorizontalLine(distance: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Availability',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: MediaQuery.of(context).size.width / 25,
                          ),
                        ),
                        if (widget.isManager)
                          GestureDetector(
                            onTap: () => {
                              showSpots(),
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width / 25,
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(
                                child: Text("Mark a broken spot ➔",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              30,
                                      decoration: TextDecoration.underline,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: [
                        for (var i = 0;
                            i < widget.carwash.smallVehicleSeats;
                            i++)
                          SpotGenerate(
                              contain:
                                  widget.carwash.brokenSpots.contains(i + 1),
                              icon: Icons.drive_eta,
                              nr: i + 1),
                        for (var i = widget.carwash.smallVehicleSeats;
                            i <
                                widget.carwash.bigVehicleSeats +
                                    widget.carwash.smallVehicleSeats;
                            i++)
                          SpotGenerate(
                              contain:
                                  widget.carwash.brokenSpots.contains(i + 1),
                              icon: Icons.local_shipping,
                              nr: i + 1),
                      ],
                    ),
                    const HorizontalLine(distance: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Facilities',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: MediaQuery.of(context).size.width / 25,
                          ),
                        ),
                        if (widget.carwash.hours != 'non-stop')
                          Text(
                            widget.carwash.hours,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      widget.carwash.facilities,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 181, 181, 181),
                        fontSize: MediaQuery.of(context).size.width / 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Token: ${widget.carwash.price} RON',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width / 23,
                      ),
                    ),
                    const HorizontalLine(distance: 15),
                    Text(
                      'Clients Review',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                                  margin: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.03),
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
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.01,
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      right: MediaQuery.of(context).size.width *
                                          0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            color: const Color.fromARGB(
                                                255, 157, 157, 157),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                20,
                                          ),
                                          const SizedBox(width: 5),
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
                                            itemSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                            itemBuilder: (context, _) =>
                                                const Icon(Icons.star,
                                                    color: Colors.amber),
                                            onRatingUpdate: (rating) {},
                                            ignoreGestures: true,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
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
                    if (_userController.username != '')
                      Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: const Color.fromARGB(255, 157, 157, 157),
                            size: MediaQuery.of(context).size.width / 17,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _userController.username,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 157, 157, 157),
                              fontSize: MediaQuery.of(context).size.width / 25,
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
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) => setState(() {
                          _carWashController.rating = rating;
                        }),
                      ),
                    if (_userController.username != '')
                      TextField(
                        controller: _carWashController.userReview,
                        decoration: const InputDecoration(
                          hintText: "Write a review..",
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
                              carwash: widget.carwash,
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
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 25,
                          child: Text(
                            'Post Review >',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              shadows: const [
                                Shadow(
                                    color: Colors.grey, offset: Offset(0, -5))
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!widget.isManager)
                          MeniuButton(
                            icon: Icons.phone,
                            label: 'Call',
                            onTap: () {
                              FlutterPhoneDirectCaller.callNumber(
                                  widget.carwash.phone.toString());
                            },
                          ),
                        if (widget.isManager)
                          MeniuButton(
                            icon: Icons.campaign,
                            label: 'Announcement',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnnouncementScreen(
                                          carwash: widget.carwash,
                                          controller: _carWashController,
                                        )),
                              );
                            },
                          ),
                        if (!widget.isManager)
                          MeniuButton(
                            icon: Icons.shopping_cart,
                            label: 'Buy tokens',
                            onTap: () {
                              showBottomSheet();
                            },
                          ),
                        if (widget.isManager)
                          MeniuButton(
                            icon: Icons.local_offer,
                            label: 'Offer',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OfferScreen(
                                          controller: _carWashController,
                                          carwash: widget.carwash,
                                        )),
                              );
                            },
                          ),
                        MeniuButton(
                          icon: Icons.map,
                          label: 'Map',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                      address: widget.carwash.address)),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
