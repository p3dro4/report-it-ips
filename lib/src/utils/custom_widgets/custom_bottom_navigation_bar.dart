import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key, this.currentIndex});
  final int? currentIndex;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex ?? 0,
      backgroundColor: Theme.of(context).primaryColor,
      onTap: (value) => {},
      items: [
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.home_filled,
            fill: 0,
          ),
          label: L.of(context)!.home,
          tooltip: L.of(context)!.home,
          activeIcon: const Icon(Icons.home_filled, fill: 1),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: L.of(context)!.profile,
            tooltip: L.of(context)!.profile),
      ],
    );
  }
}
