import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/models/profile.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key, this.user});

  final AppUser? user;

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool _processing = false;
  AppUser? user;
  AppProfile? profile;
  int currentIndex = 0;
  late Map<String, Report> _reports;

  Future<void> _getUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => {
              user = AppUser.fromSnapshot(value.data()!),
            });
  }

  Future<Map<String, Report>> _loadReports() async {
    _reports = {};
    await FirebaseFirestore.instance
        .collection("reports")
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                setState(() {
                  _reports[element.id] = Report.fromSnapshot(element.data());
                });
              })
            });
    return _reports;
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
    await _loadReports();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _processing = true;
    });
    initAll().then((value) => {
          setState(() {
            _processing = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: currentIndex == 0 && !_processing
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add_rounded, size: 50),
                    onPressed: () async {
                      await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectReportTypePage()))
                          .then((value) => setState(() {
                                _processing = true;
                                _loadReports().then((value) => {
                                      setState(() {
                                        _processing = false;
                                      })
                                    });
                              }));
                    },
                  )))
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: _processing
            ? null
            : (index) => setState(() {
                  currentIndex = index;
                }),
      ),
      body: SafeArea(
        child: _processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : switch (currentIndex) {
                1 => MapPage(
                    reports: _reports,
                    onRefresh: () async {
                      return await _loadReports();
                    }),
                2 => const CalendarPage(),
                3 => ProfilePage(
                    user: user!,
                    profile: profile!,
                    onRefresh: () async {
                      return await _loadReports();
                    },
                    reports: _reports),
                _ => HomePage(
                    reports: _reports,
                    onRefresh: () async {
                      return await _loadReports();
                    }),
              },
      ),
      appBar: switch (currentIndex) {
        1 => MapPage.appBar(context),
        2 => CalendarPage.appBar(context),
        3 => ProfilePage.appBar(context, profile!, () => setState(() {})),
        _ => null,
      },
    );
  }
}
