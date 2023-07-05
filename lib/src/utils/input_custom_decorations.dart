import 'package:flutter/material.dart';

class InputCustomDecorations {
  static InputDecoration textFieldInput(
      IconData prefixIcon,
      String labelText,
      Color color,
      Color errorColor,
      IconData? suffixIcon,
      Function? callback) {
    var decorations = InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        alignLabelWithHint: true,
        prefixIcon: Align(
            widthFactor: 1,
            alignment: Alignment.center,
            heightFactor: 1,
            child: Icon(
              prefixIcon,
              color: color,
            )),
        labelText: labelText,
        labelStyle: TextStyle(color: color),   
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 2)));
    if (suffixIcon != null) {
      decorations = decorations.copyWith(
          suffixIcon: Align(
              widthFactor: 1,
              alignment: Alignment.center,
              heightFactor: 1,
              child: IconButton(
                icon: Icon(suffixIcon, color: color),
                onPressed: () => callback!(),
              )));
    }
    return decorations;
  }
}
