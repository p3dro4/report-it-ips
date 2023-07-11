import 'package:flutter/material.dart';

class CustomSettingsInputField extends StatefulWidget {
  const CustomSettingsInputField({
    super.key,
    this.label,
    this.hintText,
    this.currentValue,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.capitalization = TextCapitalization.none,
  });

  final String? label;
  final String? hintText;
  final String? currentValue;
  final Function(String?)? onSaved;
  final Function(String?)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization capitalization;

  @override
  State<CustomSettingsInputField> createState() =>
      _CustomSettingsInputFieldState();
}

class _CustomSettingsInputFieldState extends State<CustomSettingsInputField> {
  String? currentValue;

  @override
  void initState() {
    currentValue = widget.currentValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          onTapOutside: (value) {
            FocusScope.of(context).unfocus();
          },
          textInputAction: widget.textInputAction,
          textCapitalization: widget.capitalization,
          initialValue: currentValue,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  width: 4.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  width: 4.0,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 4.0,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                  width: 4.0,
                )),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            ),
            fillColor: Theme.of(context).primaryColor,
            filled: true,
          ),
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
        ),
      ],
    );
  }
}
