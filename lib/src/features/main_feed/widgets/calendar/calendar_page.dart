import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO: Implement CalendarPage
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      title: Text(L.of(context)!.calendar,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
