import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SpotGenerate extends StatefulWidget {
  final IconData icon;
  final int nr;
  final String id;

  const SpotGenerate(
      {super.key, required this.id, required this.icon, required this.nr});

  @override
  State<SpotGenerate> createState() => _SpotGenerate();
}

class _SpotGenerate extends State<SpotGenerate> {
  Color colors = Color.fromARGB(0, 0, 255, 8);
  int? broken = 0;

  void reloadData() {
    FirebaseDatabase.instance
        .ref(widget.id)
        .child('spots')
        .child(widget.nr.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<String, int> spot = {};
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          spot[key] = value as int;
        });
        if (mounted) {
          setState(() {
            colors = spot['broken'] == 1
                ? const Color.fromARGB(255, 6, 6, 6)
                : spot['available'] == 1
                    ? const Color.fromARGB(255, 255, 17, 0)
                    : const Color.fromARGB(255, 0, 255, 8);
          });
        }
      }
    });
  }

  @override
  void initState() {
    reloadData();

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
          color: colors,
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
