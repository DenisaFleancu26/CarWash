import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:car_wash/screens/carwash_screen.dart';
import 'package:car_wash/widgets/custom_button.dart';
import 'package:car_wash/widgets/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class AnnouncementScreen extends StatefulWidget {
  final MapEntry<String, CarWash> carwash;
  final CarWashController controller;
  const AnnouncementScreen(
      {Key? key, required this.carwash, required this.controller})
      : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  int index = 1;
  String errorMessage = '';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleText(
                  'make_announcement',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        Locales.string(context, 'announcement_message'),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width / 35,
                        ),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.06),
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
                      controller: widget.controller.announcementController,
                      decoration: InputDecoration(
                        hintText: Locales.string(context, 'write_announcement'),
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        errorText: errorMessage,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 15, bottom: 15),
                      ),
                      maxLines: 10,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                CustomButton(
                  onTap: () async {
                    if (widget.controller.announcementController.text.isEmpty) {
                      setState(() {
                        errorMessage =
                            Locales.string(context, 'announcement_error');
                      });
                    } else {
                      errorMessage = '';
                      await widget.controller
                          .postAnnouncement(carwashID: widget.carwash.key)
                          .whenComplete(() => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CarWashScreen(
                                        carwash: widget.carwash,
                                        isManager: true,
                                      ))));
                    }
                  },
                  withGradient: false,
                  text: Locales.string(context, 'announcement_button'),
                  rowText: false,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
