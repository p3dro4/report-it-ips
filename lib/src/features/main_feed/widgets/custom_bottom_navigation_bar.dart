import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    this.currentIndex,
    this.onTap,
  });
  final int? currentIndex;
  final Function(int)? onTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int? currentIndex;

  @override
  void initState() {
    currentIndex = widget.currentIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex!,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor:
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
      type: BottomNavigationBarType.fixed,
      onTap: (value) => {
        setState(() {
          currentIndex = value;
        }),
        widget.onTap?.call(value),
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.home_outlined,
          ),
          label: L.of(context)!.home,
          tooltip: L.of(context)!.home,
          activeIcon: const Icon(
            Icons.home,
          ),
        ),
        BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            label: L.of(context)!.map,
            tooltip: L.of(context)!.map,
            activeIcon: const Icon(Icons.map)),
        BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: L.of(context)!.calendar,
            tooltip: L.of(context)!.calendar,
            activeIcon: const Icon(Icons.calendar_month)),
        BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: L.of(context)!.profile,
            tooltip: L.of(context)!.profile,
            activeIcon: const Icon(Icons.person)),
      ],
    );
  }
}
