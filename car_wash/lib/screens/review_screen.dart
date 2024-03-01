import 'package:car_wash/models/review.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ClientsReviewScreen extends StatefulWidget {
  final List<Review> reviews;
  const ClientsReviewScreen({Key? key, required this.reviews})
      : super(key: key);

  @override
  State<ClientsReviewScreen> createState() => _ClientsReviewScreenState();
}

class _ClientsReviewScreenState extends State<ClientsReviewScreen> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomNavigationBar(index: index),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 34, 34, 34),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                  left: MediaQuery.of(context).size.width * 0.07,
                ),
                child: LocaleText(
                  'clients_review',
                  style: TextStyle(
                    color: const Color.fromARGB(223, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width / 15,
                    shadows: [
                      Shadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.30),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.reviews.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.04,
                                left: MediaQuery.of(context).size.width * 0.04,
                                right:
                                    MediaQuery.of(context).size.width * 0.04),
                            width: MediaQuery.of(context).size.width,
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
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: const Color.fromARGB(
                                          255, 157, 157, 157),
                                      size: MediaQuery.of(context).size.width /
                                          20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.reviews[index].username,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                30,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                RatingBar.builder(
                                  initialRating:
                                      widget.reviews[index].rating.toDouble(),
                                  itemSize: MediaQuery.of(context).size.height *
                                      0.025,
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  onRatingUpdate: (rating) {},
                                  ignoreGestures: true,
                                ),
                                if (widget.reviews[index].feedback != '')
                                  SizedBox(
                                    height: 5,
                                  ),
                                Text(
                                  widget.reviews[index].feedback,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        197, 216, 216, 216),
                                    fontSize:
                                        MediaQuery.of(context).size.width / 30,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.reviews[index].feedback != '')
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.015)
                              ],
                            ));
                      })),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
