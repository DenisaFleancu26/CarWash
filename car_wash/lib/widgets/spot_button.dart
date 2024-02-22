import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpotButton extends StatefulWidget {
  final int nr;
  final IconData icon;
  final String id;
  final Function(int, bool) onButtonPressed;
  const SpotButton(
      {super.key,
      required this.nr,
      required this.icon,
      required this.id,
      required this.onButtonPressed});

  @override
  State<SpotButton> createState() => _SeatButtonState();
}

class _SeatButtonState extends State<SpotButton> {
  bool isButtonPressed = false;

  @override
  void initState() {
    reloadData(widget.id);
    super.initState();
  }

  void reloadData(String id) {
    FirebaseDatabase.instance
        .ref(id)
        .child('spots')
        .child(widget.nr.toString())
        .child('broken')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (mounted) {
          setState(() {
            isButtonPressed = event.snapshot.value == 1 ? true : false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isButtonPressed = !isButtonPressed;
          widget.onButtonPressed(widget.nr, isButtonPressed);
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 5.5,
          height: MediaQuery.of(context).size.width / 5.5,
          decoration: BoxDecoration(
            color: isButtonPressed
                ? const Color.fromARGB(255, 34, 34, 34)
                : const Color.fromARGB(0, 34, 34, 34),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isButtonPressed
                  ? Colors.grey
                  : const Color.fromARGB(255, 34, 34, 34),
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: isButtonPressed
                    ? Colors.grey
                    : const Color.fromARGB(255, 34, 34, 34),
                size: MediaQuery.of(context).size.width / 12,
              ),
              Text(
                widget.nr.toString(),
                style: TextStyle(
                  color: isButtonPressed
                      ? Colors.grey
                      : const Color.fromARGB(255, 34, 34, 34),
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 30,
                ),
              ),
            ],
          )),
    );
  }
}
