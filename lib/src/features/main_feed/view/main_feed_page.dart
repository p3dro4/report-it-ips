import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/app_user.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key, this.user});

  final AppUser? user;
  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool processing = false;
  AppUser? user;
  int currentIndex = 0;

  //pages
  List<Widget>? _pages;

  @override
  void initState() {
    if (widget.user != null) {
      user = widget.user;
    } else {
      user = AppUser();
    }
    _pages = [
      const HomePage(),
      const MapPage(),
      const CalendarPage(),
      const ProfilePage(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = switch (currentIndex) {
      1 => L.of(context)!.map,
      2 => L.of(context)!.calendar,
      3 => L.of(context)!.profile,
      _ => ""
    };
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          onTap: (value) => {
            setState(() {
              currentIndex = value;
            }),
          },
        ),
        appBar: currentIndex != 0
            ? AppBar(
                titleSpacing: 20,
                title: Text(title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  currentIndex == 3
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: IconButton(
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SettingsPage()))
                                  },
                              icon: Icon(
                                Icons.settings_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                                weight: 300,
                              )))
                      : Container()
                ],
              )
            : null,
        body: SafeArea(child: _pages![currentIndex]));
  }
}
