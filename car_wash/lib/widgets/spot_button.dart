import 'package:flutter/material.dart';

class SeatButton extends StatefulWidget {
  final int nr;
  final IconData icon;
  final bool activated;
  final Function(int, bool) onButtonPressed;
  const SeatButton(
      {super.key,
      required this.nr,
      required this.icon,
      required this.activated,
      required this.onButtonPressed});

  @override
  State<SeatButton> createState() => _SeatButtonState();
}

class _SeatButtonState extends State<SeatButton> {
  late bool isButtonPressed;

  @override
  void initState() {
    isButtonPressed = widget.activated;
    super.initState();
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
