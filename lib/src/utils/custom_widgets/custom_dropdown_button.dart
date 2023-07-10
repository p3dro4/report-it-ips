import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton(
      {super.key,
      this.prefixIcon,
      this.label = "",
      this.color = Colors.black,
      this.errorColor = Colors.red,
      this.onSaved,
      this.validator,
      this.onChanged,
      this.value,
      required this.items});
  final Map<String, String> items;
  final String label;
  final Color color;
  final Color errorColor;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final String? value;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  Map<String, String> get items => widget.items;
  String? dropdownValue;

  InputDecoration _inputFieldDecorations(
      IconData? icon, String labelText, Color color, Color errorColor) {
    var decorations = InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        alignLabelWithHint: true,
        labelText: labelText,
        prefixIcon: icon != null
            ? Align(
                widthFactor: 1,
                alignment: Alignment.center,
                heightFactor: 1,
                child: Icon(
                  icon,
                  color: color,
                ))
            : null,
        labelStyle: TextStyle(color: color),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: color, width: 2)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 2)));
    return decorations;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: _inputFieldDecorations(
        widget.prefixIcon,
        widget.label,
        widget.color,
        widget.errorColor,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: widget.color,
      ),
      menuMaxHeight: 300,
      isExpanded: true,
      items: items.entries
          .map((e) => DropdownMenuItem(
                value: e.key,
                child: AutoSizeText(
                  e.value,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  minFontSize: 5,
                  maxFontSize: 16,
                ),
              ))
          .toList(),
      value: widget.value,
      onChanged: (value) => setState(() => {
            if (widget.onChanged != null) widget.onChanged!(value ?? ""),
            dropdownValue = value
          }),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
