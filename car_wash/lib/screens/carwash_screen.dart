import 'package:car_wash/controllers/auth_controller.dart';
import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/controllers/user_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/map_screen.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarWashScreen extends StatefulWidget {
  final CarWash carwash;
  const CarWashScreen({Key? key, required this.carwash}) : super(key: key);

  @override
  State<CarWashScreen> createState() => _CarWashState();
}

class _CarWashState extends State<CarWashScreen> {
  int index = 1;
  final User? user = AuthController().currentUser;
  final UserController _userController = UserController();
  final CarWashController _carWashController = CarWashController();

  @override
  void initState() {
    super.initState();
    _userController.getUsername(
      displayUsername: (username) =>
          setState(() => _userController.username = username),
    );
    _carWashController.findId(
        name: widget.carwash.name, address: widget.carwash.address);
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
      bottomNavigationBar: CustomNavigationBar(user: user, index: index),
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
                      padding: const EdgeInsets.only(
                          left: 25, top: 15, right: 10, bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                if (widget.carwash.hours == 'non-stop')
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
                    const SizedBox(height: 10),
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
                        onTap: () async {
                          if (_carWashController.rating != 0.0 ||
                              _carWashController.userReview.text != '') {
                            if (_carWashController.rating != 0.0) {
                              widget.carwash.addRating(
                                  _carWashController.rating.toInt(),
                                  _carWashController.managerId,
                                  _carWashController.carwashId);
                            }
                            widget.carwash.addReview(
                                _userController.username,
                                _carWashController.userReview,
                                _carWashController.rating.toInt(),
                                _carWashController.managerId,
                                _carWashController.carwashId);
                          }

                          widget.carwash.reviews =
                              await _carWashController.getReviews(
                                  manager: _carWashController.managerId,
                                  carwash: _carWashController.carwashId);
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
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 10),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen(
                                      address: widget.carwash.address)),
                            );
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
