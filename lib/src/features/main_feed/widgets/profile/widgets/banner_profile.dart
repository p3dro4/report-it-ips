import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BannerProfile extends StatefulWidget {
  const BannerProfile(
      {super.key, this.label, this.icon, this.value, this.iconColor});

  final String? label;
  final IconData? icon;
  final Color? iconColor;
  final String? value;

  @override
  State<BannerProfile> createState() => _BannerProfileState();
}

class _BannerProfileState extends State<BannerProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
            height: 115,
            width: 115,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor ??
                      Theme.of(context).colorScheme.onPrimary,
                  shadows: const [Shadow(color: Colors.black, blurRadius: 3)],
                  size: 40,
                ),
                Text(
                  widget.value ?? '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                AutoSizeText(
                  widget.label ?? '',
                  maxLines: 1,
                  maxFontSize: 10,
                  minFontSize: 5,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )));
  }
}
