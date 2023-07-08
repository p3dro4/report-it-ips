import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.labelText,
    this.validator,
    this.onSaved,
    this.color = Colors.black,
    this.errorColor = Colors.red,
  });
  final String labelText;
  final Color color;
  final Color errorColor;
  final FormFieldValidator? validator;
  final FormFieldSetter<DateTime?>? onSaved;

  @override
  State<CustomDatePicker> createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  void callOnSaved() {
    widget.onSaved!(selectedDate);
  }

  InputDecoration _inputFieldDecorations(
      String labelText, Color color, Color errorColor) {
    var decorations = InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        alignLabelWithHint: true,
        prefixIcon: Align(
            widthFactor: 1,
            alignment: Alignment.center,
            heightFactor: 1,
            child: Icon(
              Icons.calendar_month_outlined,
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
    return decorations;
  }

  void pickDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((value) => {
          if (value != null)
            {
              setState(() {
                selectedDate = value;
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: _inputFieldDecorations(
          widget.labelText, widget.color, widget.errorColor),
      readOnly: true,
      onTap: () => pickDate(context),
      onTapOutside: (value) => FocusScope.of(context).unfocus(),
      controller: TextEditingController(
          text: selectedDate != null
              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
              : null),
      validator: widget.validator,
      onSaved: (_) => {callOnSaved()},
    );
  }
}
