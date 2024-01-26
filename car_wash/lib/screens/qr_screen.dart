import 'package:car_wash/controllers/transaction_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/transaction_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:randomstring_dart/randomstring_dart.dart';

class QRScreen extends StatefulWidget {
  final String? carwashId;
  final int tokens;
  final CarWash carWash;
  const QRScreen(
      {Key? key,
      required this.carwashId,
      required this.tokens,
      required this.carWash})
      : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  int index = 1;

  final TransactionController _transactionController = TransactionController();
  String qr = '';
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    qr =
        '${widget.carwashId} ${widget.tokens} ${RandomString().getRandomString()}';
    _transactionController.saveTransaction(
        dataQR: qr,
        carwash: widget.carWash.name,
        address: widget.carWash.address,
        totalPrice: widget.tokens * widget.carWash.price,
        date: "${currentDate.day}/${currentDate.month}/${currentDate.year}");
    super.initState();
  }

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
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
              children: [
                QrImageView(
                  data: qr,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                CustomButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionScreen()));
                  },
                  withGradient: false,
                  text: "Done",
                  rowText: false,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      size: MediaQuery.of(context).size.width / 22,
                      color: const Color.fromARGB(197, 216, 216, 216),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        'Scan the QR code at the Car Wash to pick up the tokens!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width / 35,
                        ),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}