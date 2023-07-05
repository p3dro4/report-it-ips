import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton(
      {super.key, this.callback, this.text, this.color, this.textColor});
  final Function? callback;
  final String? text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
            child: ElevatedButton(
          onPressed: () => callback!(),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shadowColor: MaterialStateProperty.all(Colors.black),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20)),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 45)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(color),
          ),
          child: Text(text != null ? text! : "",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  color: textColor)),
        )));
  }
}
