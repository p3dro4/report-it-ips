import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.callback, this.text, this.color});
  final Function? callback;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => callback!(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: color,
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
        label: Text(
          text != null ? text! : "",
          style: TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700),
        ));
  }
}
