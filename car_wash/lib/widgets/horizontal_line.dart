import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key, required this.distance});

  final double distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: distance,
      ),
      height: 1,
      color: const Color.fromARGB(255, 157, 157, 157),
    );
  }
}
