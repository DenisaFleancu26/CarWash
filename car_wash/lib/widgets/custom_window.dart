import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomWindow extends StatelessWidget {
  const CustomWindow({super.key, required this.carwash});

  final CarWash carwash;

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
            width: 140,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              image: DecorationImage(
                image: FirebaseImageProvider(FirebaseUrl(carwash.image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                RatingBar.builder(
                  initialRating: carwash.averageRating(
                      carwash.nrRatings, carwash.totalRatings),
                  itemSize: 20.0,
                  unratedColor: const Color.fromARGB(195, 255, 255, 255),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                ),
                const SizedBox(width: 2),
                Text(
                  '(${carwash.nrRatings})',
                  style: TextStyle(
                    color: const Color.fromARGB(195, 190, 190, 190),
                    fontSize: MediaQuery.of(context).size.width / 30,
                  ),
                ),
              ]),
              SizedBox(
                width: 140,
                child: Text(
                  carwash.name,
                  style: TextStyle(
                    color: const Color.fromARGB(223, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
                width: 140,
                child: Text(
                  carwash.address,
                  style: TextStyle(
                    color: const Color.fromARGB(198, 255, 255, 255),
                    fontSize: 8,
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
                padding: const EdgeInsets.only(left: 60),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CarWashScreen(carwash: carwash)),
                    ),
                  },
                  child: const SizedBox(
                    height: 20,
                    width: 70,
                    child: Center(
                        child: Text(
                      "View more ➔",
                      style: TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 222, 222, 222)),
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
