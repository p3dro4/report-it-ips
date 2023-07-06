import 'package:flutter/material.dart';

class CustomSubmitButton extends StatefulWidget {
  const CustomSubmitButton(
      {super.key,
      this.callback,
      this.text,
      this.color,
      this.textColor,
      this.enabled = true});

  final Function? callback;
  final Color? color;
  final bool enabled;
  final String? text;
  final Color? textColor;

  @override
  State<CustomSubmitButton> createState() => _CustomSubmitButtonState();
}

class _CustomSubmitButtonState extends State<CustomSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
            child: ElevatedButton(
          onPressed: widget.enabled ? () => widget.callback!() : null,
          style: ButtonStyle(
            elevation: widget.enabled ? MaterialStateProperty.all(5) : null,
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
            backgroundColor: MaterialStateProperty.all(widget.enabled
                ? widget.color
                : Theme.of(context).disabledColor),
          ),
          child: Text(widget.text != null ? widget.text! : "",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  color: widget.textColor)),
        )));
  }
}
