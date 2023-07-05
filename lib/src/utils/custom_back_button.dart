import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          color: color,
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
        label: Text(
          L.of(context)!.back,
          style: TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700),
        ));
  }
}
