import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/horizontal_line.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatefulWidget {
  final MapEntry<String, CarWash> carwash;
  final CarWashController controller;
  const OfferScreen({Key? key, required this.controller, required this.carwash})
      : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  int index = 1;
  String errorMessage = '';
  int offer = 1;

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
            image: DecorationImage(
          image: AssetImage("assets/images/qr_background.png"),
          fit: BoxFit.cover,
        )),
        child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1),
            child: (widget.carwash.value.offerType == 0 ||
                    widget.carwash.value.offerDate == '')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What type of offer are you looking for today?',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width / 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05),
                          child: Container(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  padding: const EdgeInsets.all(2),
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 34, 34, 34),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  offer = 1;
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: offer == 1
                                                        ? const Color.fromARGB(
                                                            255, 255, 255, 255)
                                                        : const Color.fromARGB(
                                                            255, 34, 34, 34),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Text("X% discount",
                                                    style: TextStyle(
                                                      color: offer == 1
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 34, 34, 34)
                                                          : const Color
                                                              .fromARGB(255,
                                                              255, 255, 255),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              25,
                                                    )),
                                              ))),
                                      Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  offer = 2;
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: offer == 2
                                                        ? const Color.fromARGB(
                                                            255, 255, 255, 255)
                                                        : const Color.fromARGB(
                                                            255, 34, 34, 34),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Text(
                                                    "Buy X tokens, get one free",
                                                    style: TextStyle(
                                                      color: offer == 2
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 34, 34, 34)
                                                          : const Color
                                                              .fromARGB(255,
                                                              255, 255, 255),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              25,
                                                    )),
                                              ))),
                                    ],
                                  )))),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.06,
                        ),
                        child: Text(
                            offer == 1
                                ? "What percentage do you want for the discount?"
                                : "How many tokens need to be purchased to receive one for free?",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 34, 34, 34),
                              fontSize: MediaQuery.of(context).size.width / 25,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                errorMessage == ''
                                    ? BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4))
                                    : const BoxShadow(
                                        spreadRadius: 1,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      )
                              ]),
                          child: TextField(
                            controller: widget.controller.offerController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: offer == 1 ? 'X%...' : 'X...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              errorText: errorMessage,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                                top: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            offer == 1 ? Icons.info : null,
                            size: MediaQuery.of(context).size.width / 25,
                            color: const Color.fromARGB(197, 216, 216, 216),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              offer == 1
                                  ? 'It will be applied to the final price.'
                                  : '',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width / 33,
                              ),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      CustomButton(
                        onTap: () {
                          if (widget.controller.offerController.text.isEmpty) {
                            setState(() {
                              errorMessage = offer == 1
                                  ? 'Please enter the percentage!'
                                  : 'Please enter the number of tokens!';
                            });
                          } else {
                            widget.carwash.value.offerType = offer;
                            widget.carwash.value.offerValue = double.parse(
                                widget.controller.offerController.text);
                            widget.carwash.value.offerDate =
                                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                            widget.controller
                                .makeOffer(
                                    offerType: offer,
                                    carwash: widget.carwash.value)
                                .whenComplete(() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OfferScreen(
                                              controller: widget.controller,
                                              carwash: widget.carwash,
                                            ))));
                          }
                        },
                        withGradient: false,
                        text: "Make Offer",
                        rowText: false,
                        color: const Color.fromARGB(255, 34, 34, 34),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Today's Offer",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width / 10,
                            fontWeight: FontWeight.bold),
                      ),
                      HorizontalLine(
                          distance: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        widget.carwash.value.offerType == 1
                            ? "${widget.carwash.value.offerValue}% discount"
                            : "Buy ${widget.carwash.value.offerValue.toInt()} tokens, get one free",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width / 15,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      HorizontalLine(
                          distance: MediaQuery.of(context).size.height * 0.05),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(
                        "Do you want to disable the offer?",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width / 23),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      CustomButton(
                        onTap: () {
                          widget.controller.offerController.clear();
                          widget.carwash.value.offerType = 0;
                          widget.carwash.value.offerValue = 0;
                          widget.carwash.value.offerDate = "";
                          widget.controller
                              .disableOffer()
                              .whenComplete(() => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferScreen(
                                            controller: widget.controller,
                                            carwash: widget.carwash,
                                          ))));
                        },
                        withGradient: false,
                        text: "Disable",
                        rowText: false,
                        color: const Color.fromARGB(255, 34, 34, 34),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ],
                  )),
      )),
    );
  }
}
