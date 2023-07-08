import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.callback, this.text, this.color});
  final Function? callback;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              onPressed: () => callback!(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: color,
                size: 20,
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              label: Text(
                text != null ? text! : "",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700),
              ))),
    );
  }
}
