import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomWindow extends StatelessWidget {
  final bool isManager;
  CustomWindow({super.key, required this.carwash, required this.isManager});

  final MapEntry<String, CarWash> carwash;
  final CarWashController _carWashController = CarWashController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color.fromARGB(218, 122, 122, 122),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.51,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              image: DecorationImage(
                image: FirebaseImageProvider(FirebaseUrl(carwash.value.image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                RatingBar.builder(
                  initialRating: _carWashController.averageRating(
                      carwash.value.nrRatings, carwash.value.totalRatings),
                  itemSize: MediaQuery.of(context).size.width / 17,
                  unratedColor: const Color.fromARGB(195, 255, 255, 255),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                ),
                const SizedBox(width: 2),
                Text(
                  '(${carwash.value.nrRatings})',
                  style: TextStyle(
                    color: const Color.fromARGB(195, 190, 190, 190),
                    fontSize: MediaQuery.of(context).size.width / 30,
                  ),
                ),
              ]),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  carwash.value.name,
                  style: TextStyle(
                    color: const Color.fromARGB(223, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 22,
                    shadows: [
                      Shadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.30),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  carwash.value.address,
                  style: TextStyle(
                    color: const Color.fromARGB(198, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width / 40,
                    shadows: [
                      Shadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.30),
                      ),
                    ],
                  ),
                  softWrap: true,
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarWashScreen(
                                carwash: carwash,
                                isManager: isManager,
                              )),
                    ),
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Center(
                        child: LocaleText(
                      'map_button',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 35,
                        shadows: const [
                          Shadow(color: Colors.white, offset: Offset(0, -2))
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
