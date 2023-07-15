import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.color,
      this.textColor});

  final Function()? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
                backgroundColor:
                    MaterialStateProperty.all<Color>(color ?? Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            onPressed: onPressed,
            child: Text(text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ))));
  }
}
