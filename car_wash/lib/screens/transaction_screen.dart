import 'dart:ui';

import 'package:car_wash/controllers/transaction_controller.dart';
import 'package:car_wash/screens/qr_screen.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  int index = 2;
  bool display = false;
  final TransactionController _transactionController = TransactionController();

  @override
  void initState() {
    super.initState();
    _transactionController.fetchTransactions(
        displayInfo: () => setState(() => display = false));
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/background.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          value: 0.6,
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width * 0.07,
                        ),
                        child: Text(
                          "Transaction",
                          style: TextStyle(
                            color: const Color.fromARGB(223, 255, 255, 255),
                            fontSize: MediaQuery.of(context).size.width / 10,
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
                              itemCount:
                                  _transactionController.transactions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 4,
                                        sigmaY: 4,
                                      ),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          color:
                                              Color.fromARGB(70, 122, 122, 122),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.015,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.005,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.02),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      QRScreen(
                                                                        transaction:
                                                                            _transactionController.transactions[index],
                                                                      )));
                                                    },
                                                    child: QrImageView(
                                                      data:
                                                          _transactionController
                                                              .transactions[
                                                                  index]
                                                              .dataQR,
                                                      version: QrVersions.auto,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.22,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  _transactionController
                                                      .transactions[index].date,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.48,
                                                  child: Text(
                                                    _transactionController
                                                        .transactions[index]
                                                        .carwash,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              223,
                                                              255,
                                                              255,
                                                              255),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      shadows: [
                                                        Shadow(
                                                          offset: const Offset(
                                                              3.0, 3.0),
                                                          blurRadius: 10.0,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.30),
                                                        ),
                                                      ],
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.47,
                                                  child: Text(
                                                    _transactionController
                                                        .transactions[index]
                                                        .address,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              197,
                                                              216,
                                                              216,
                                                              216),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              50,
                                                      shadows: [
                                                        Shadow(
                                                          offset: const Offset(
                                                              3.0, 3.0),
                                                          blurRadius: 10.0,
                                                          color: Colors.black
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.47,
                                                  child: Text(
                                                    "- ${_transactionController.transactions[index].totalPrice} RON",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 2, 2),
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20,
                                                      shadows: [
                                                        Shadow(
                                                          offset: const Offset(
                                                              3.0, 3.0),
                                                          blurRadius: 10.0,
                                                          color: Colors.black
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
                                );
                              }))
                    ],
                  ))),
    );
  }
}
