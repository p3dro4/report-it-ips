import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO: Implement MapPage
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      title: Text(L.of(context)!.map,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
