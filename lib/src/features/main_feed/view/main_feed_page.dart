import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/app_user.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';

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

  @override
  void initState() {
    setState(() {
      processing = true;
    });
    if (user == null) {
      _getUser().then((value) => {
            setState(() {
              processing = false;
            })
          });
    } else {
      setState(() {
        processing = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        appBar: switch (currentIndex) {
          1 => MapPage.appBar(context),
          2 => CalendarPage.appBar(context),
          3 => ProfilePage.appBar(context),
          _ => null,
        },
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
                    ),
                  _ => const HomePage(),
                },
        ));
  }
}
