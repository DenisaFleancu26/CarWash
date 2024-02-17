import 'package:car_wash/controllers/carwash_controller.dart';
import 'package:car_wash/models/car_wash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpotGenerate extends StatefulWidget {
  final bool contain;
  final IconData icon;
  final int nr;
  final CarWash carwash;

  const SpotGenerate(
      {super.key,
      required this.carwash,
      required this.contain,
      required this.icon,
      required this.nr});

  @override
  State<SpotGenerate> createState() => _SpotGenerate();
}

class _SpotGenerate extends State<SpotGenerate> {
  Color colors = const Color.fromARGB(255, 0, 255, 8);
  final CarWashController _carWashController = CarWashController();

  void reloadData(String id) {
    FirebaseDatabase.instance
        .ref(id)
        .child(widget.nr.toString())
        .child('available')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        if (mounted) {
          setState(() {
            colors = event.snapshot.value == 1
                ? const Color.fromARGB(255, 255, 17, 0)
                : const Color.fromARGB(255, 0, 255, 8);
          });
        }
      }
    });
  }

  @override
  void initState() {
    _carWashController
        .findId(name: widget.carwash.name, address: widget.carwash.address)
        .whenComplete(() {
      reloadData(_carWashController.carwashId);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          color: widget.contain ? const Color.fromARGB(255, 6, 6, 6) : colors,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            widget.icon,
            color: const Color.fromARGB(255, 157, 157, 157),
            size: MediaQuery.of(context).size.width / 12,
          ),
          Text(
            widget.nr.toString(),
            style: TextStyle(
              color: const Color.fromARGB(255, 157, 157, 157),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 30,
            ),
          ),
        ],
      ),
    );
  }
}
