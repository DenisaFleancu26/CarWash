import 'package:flutter/material.dart';

class CustomEntryField extends StatelessWidget {
  const CustomEntryField(
      {super.key,
      required this.onTap,
      required this.title,
      required this.controller,
      required this.hasObscureText,
      required this.obscureText,
      this.iconData,
      this.errorMessage});

  final String title;
  final TextEditingController controller;
  final bool hasObscureText;
  final bool obscureText;
  final IconData? iconData;
  final String? errorMessage;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hasObscureText ? obscureText : false,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: title,
        errorText: errorMessage,
        hintStyle: TextStyle(
          color: const Color.fromARGB(255, 157, 157, 157),
          shadows: [
            Shadow(
              offset: const Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 157, 157, 157)),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 29, 29, 29))),
        prefixIcon: Icon(
          iconData,
          color: const Color.fromARGB(255, 157, 157, 157),
          size: MediaQuery.of(context).size.width / 15,
          shadows: [
            Shadow(
              offset: const Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.25),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: Visibility(
          visible: hasObscureText,
          child: GestureDetector(
            onTap: onTap,
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromARGB(255, 157, 157, 157),
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
