import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, required this.top, required this.bottom});

  final bool bottom;

  final bool top;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: []),
    );
  }
}
