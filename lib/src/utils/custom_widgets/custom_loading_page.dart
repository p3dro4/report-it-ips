import 'package:flutter/material.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class CustomLoadingPage extends StatelessWidget {
  const CustomLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Stack(children: [
        BackgroundImage(top: true, bottom: true),
        Center(child: CircularProgressIndicator()),
      ]),
    ));
  }
}
