import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, required this.top, required this.bottom});

  final bool bottom;

  final bool top;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (top)
        Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/images/backgrounds/background_top.png",
              scale: 1.75,
            )),
      if (bottom)
        Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/images/backgrounds/background_bottom.png",
              scale: 2,
            ))
    ]);
  }
}
