import 'package:flutter/material.dart';

class MeniuButton extends StatelessWidget {
  const MeniuButton({
    super.key,
    required this.icon,
    this.label,
    required this.onTap,
  });

  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(255, 34, 34, 34),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 2, 2, 2).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(255, 26, 26, 26),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: MediaQuery.of(context).size.width / 20,
              color: const Color.fromARGB(197, 216, 216, 216),
            ),
            if (label != null) const SizedBox(width: 5),
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  color: const Color.fromARGB(197, 216, 216, 216),
                  fontSize: MediaQuery.of(context).size.width / 23,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
