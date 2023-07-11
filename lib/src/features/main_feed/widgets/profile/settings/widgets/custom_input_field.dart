import 'package:flutter/material.dart';

class CustomSettingsInputField extends StatelessWidget {
  const CustomSettingsInputField(
      {super.key, this.label, this.hintText, this.currentValue, this.onSaved});

  final String? hintText;
  final String? label;
  final String? currentValue;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
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
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            ),
            fillColor: Theme.of(context).primaryColor,
            filled: true,
          ),
        ),
      ],
    );
  }
}
