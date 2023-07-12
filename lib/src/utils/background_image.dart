import 'package:flutter/material.dart';

class BackgroundImage extends StatefulWidget {
  const BackgroundImage(
      {super.key, required this.top, required this.bottom, this.opacity});
  final bool top;
  final bool bottom;
  final double? opacity;

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (widget.top)
        Opacity(
            opacity: widget.opacity ?? 1,
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  "assets/images/backgrounds/background_top.png",
                  scale: 1.75,
                ))),
      if (widget.bottom)
        Opacity(
            opacity: widget.opacity ?? 1,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  "assets/images/backgrounds/background_bottom.png",
                  scale: 2,
                )))
    ]);
  }
}
