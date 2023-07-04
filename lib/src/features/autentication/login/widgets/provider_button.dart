import 'package:flutter/material.dart';

class ProviderButton extends StatelessWidget {
  const ProviderButton(
      {super.key,
      this.onPressed,
      required this.imageLocation,
      required this.height,
      required this.width});

  final Function? onPressed;
  final String imageLocation;
  final double? height;
  final double? width;
  void callback() {
    onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:55,
      height: 55,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(5),
        ),
        child: Image.asset(
          imageLocation,
          alignment: Alignment.center,
          height: height,
          width: width,
        ),
      ),
    );
  }
}
