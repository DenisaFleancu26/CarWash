import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.withGradient,
      required this.text,
      this.colorGradient1,
      this.colorGradient2,
      this.width,
      this.height,
      this.color,
      this.textColor,
      this.child,
      required this.rowText});

  final void Function() onTap;
  final bool withGradient;
  final Color? colorGradient1;
  final Color? colorGradient2;
  final String text;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final Row? child;
  final bool rowText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 10),
          height: height ?? 50,
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: withGradient
                  ? LinearGradient(
                      colors: [
                        colorGradient1!,
                        colorGradient2!,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: !withGradient ? color ?? Colors.white : null,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4))
              ]),
          child: rowText
              ? child
              : Center(
                  child: Text(
                  text,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )),
        ),
      ),
    );
  }
}
