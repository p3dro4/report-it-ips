import 'package:flutter/material.dart';

class CustomFormInputField extends StatelessWidget {
  const CustomFormInputField(
      {super.key,
      this.prefixIcon,
      this.labelText,
      this.suffixIcon,
      this.callbackSuffixIcon,
      this.obscureText = false,
      this.validator,
      this.onSaved,
      this.keyboardType,
      this.textInputAction,
      this.onFieldSubmitted,
      this.color = Colors.black,
      this.errorColor = Colors.red});
  final IconData? prefixIcon;
  final String? labelText;
  final Color color;
  final Color errorColor;
  final IconData? suffixIcon;
  final Function? callbackSuffixIcon;
  final FormFieldValidator? validator;
  final bool obscureText;
  final FormFieldSetter? onSaved;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  InputDecoration _inputFieldDecorations(IconData prefixIcon, String labelText,
      Color color, Color errorColor, IconData? suffixIcon, Function? callback) {
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

  @override
  Widget build(BuildContext context) {
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
}
