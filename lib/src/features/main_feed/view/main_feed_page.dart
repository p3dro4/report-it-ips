import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/models/profile.dart';
import 'package:report_it_ips/src/features/models/app_profile.dart';
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
  AppProfile? profile;
  int currentIndex = 0;

  Future<void> _getUser() async {
    setState(() {
      processing = true;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => {
              user = AppUser.fromSnapshot(value.data()!),
              processing = false,
            });
  }

  Future<void> initAll() async {
    await _getUser();

    await ProfileHandler.getProfile(FirebaseAuth.instance.currentUser!.uid)
        .then((value) => {
              setState(() {
                profile = value;
              })
            })
        .onError((error, stackTrace) => {
              ProfileHandler.createProfile(
                      FirebaseAuth.instance.currentUser!.uid)
                  .then((value) => {
                        setState(() {
                          profile = value;
                        })
                      })
            });
    setState(() {
      processing = false;
    });
  }

  @override
  void initState() {
    setState(() {
      processing = true;
    });
    initAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add_rounded, size: 50),
                    onPressed: () async {
                      bool? refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SelectReportTypePage()));
                      if (refresh ?? false) {
                        setState(() {});
                      }
                    },
                  )))
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: processing
            ? null
            : (value) => {
                  setState(() {
                    currentIndex = value;
                  }),
                },
      ),
      body: SafeArea(
        child: processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : switch (currentIndex) {
                0 => const HomePage(),
                1 => const MapPage(),
                2 => const CalendarPage(),
                3 => ProfilePage(
                    user: user!,
                    profile: profile!,
                  ),
                _ => const HomePage(),
              },
      ),
      appBar: switch (currentIndex) {
        1 || 2 => AppBar(
            titleSpacing: 20,
            title: Text(L.of(context)!.map,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        3 => AppBar(
            titleSpacing: 20,
            title: Text(L.of(context)!.profile,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: () async {
                        bool refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage(
                                      profile: profile,
                                    )));
                        if (refresh) {
                          setState(() {});
                        }
                      },
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.onPrimary,
                        weight: 300,
                      )))
            ],
          ),
        _ => null,
      },
    );
  }
}
