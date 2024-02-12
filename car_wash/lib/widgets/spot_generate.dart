import 'package:flutter/material.dart';

class SpotGenerate extends StatelessWidget {
  final bool contain;
  final IconData icon;
  final int nr;
  const SpotGenerate(
      {super.key, required this.contain, required this.icon, required this.nr});

  @override
  Widget build(BuildContext context) {
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
            color: contain
                ? const Color.fromARGB(255, 6, 6, 6)
                : const Color.fromARGB(255, 2, 196, 21),
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 157, 157, 157),
              size: MediaQuery.of(context).size.width / 12,
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
}
