import 'package:flutter/material.dart';

class BannerProfile extends StatefulWidget {
  const BannerProfile({super.key, this.label, this.icon, this.value});

  final String? label;
  final IconData? icon;
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.value ?? '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.label ?? '',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )));
  }
}
