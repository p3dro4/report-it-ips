import 'package:flutter/material.dart';

class CustomWidgets {
  static Padding customSubmitButton(
      Function? callback, String text, Color color, Color textColor) {
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
          child: Text(text,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                  color: textColor)),
        )));
  }

  static TextButton customBackButton(
      Function? callback, String text, Color color) {
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
          text,
          style: TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700),
        ));
  }

  static TextFormField customFormInputField(
      {IconData? prefixIcon,
      String? labelText,
      Color color = Colors.black,
      Color errorColor = Colors.red,
      IconData? suffixIcon,
      Function? callbackSuffixIcon,
      FormFieldValidator? validator,
      bool obscureText = false,
      FormFieldSetter? onSaved,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      ValueChanged<String>? onFieldSubmitted}) {
    return TextFormField(
      decoration: _inputFieldDecorations(prefixIcon!, labelText!, color,
          errorColor, suffixIcon, callbackSuffixIcon),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  static InputDecoration _inputFieldDecorations(
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
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: errorColor),
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
