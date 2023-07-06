import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomLargeButton extends StatefulWidget {
  const CustomLargeButton(
      {super.key,
      this.icon,
      this.text = "",
      this.callback,
      this.isSelected = false,
      this.color = Colors.white,
      this.contentColor = Colors.black,
      this.selectedColor = Colors.black,
      this.selectedContentColor = Colors.white});
  final IconData? icon;
  final String text;
  final Function? callback;
  final bool isSelected;
  final Color color;
  final Color contentColor;
  final Color selectedColor;
  final Color selectedContentColor;

  @override
  State<CustomLargeButton> createState() => _CustomLargeButtonState();
}

class _CustomLargeButtonState extends State<CustomLargeButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () => {widget.callback!()},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                widget.isSelected ? widget.selectedColor : widget.color,
              ),
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 100)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: widget.isSelected
                            ? widget.selectedColor
                            : widget.contentColor,
                        width: 1)),
              ),
            ),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Icon(
                widget.icon,
                size: 50,
                color: widget.isSelected
                    ? widget.selectedContentColor
                    : widget.contentColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AutoSizeText(
                        widget.text,
                        style: TextStyle(
                          color: widget.isSelected
                              ? widget.selectedContentColor
                              : widget.contentColor,
                          fontSize: 35,
                        ),
                        stepGranularity: 1,
                        wrapWords: false,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )))
            ])));
  }
}
