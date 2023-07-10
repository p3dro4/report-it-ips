//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:report_it_ips/src/features/models/app_user.dart';
import 'package:report_it_ips/src/utils/custom_widgets/custom_widgets.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key, this.user});

  final AppUser? user;
  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool processing = false;
  AppUser? user;

  @override
  void initState() {
    if (widget.user != null) {
      user = widget.user;
    } else {
      user = AppUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SafeArea(
            child: processing
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Main Feed Page",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text("Sign Out"),
                            onPressed: () => {
                              FirebaseAuth.instance.signOut(),
                            },
                          ),
                          // ! Uncomment this to test the fetch
                          /* ElevatedButton(
                              child: Text("Fetch"),
                              onPressed: () => {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .get()
                                        .then((value) => {
                                              print(AppUser.fromSnapshot(value.data()))
                                            })
                                  }), */
                        ]),
                  )));
  }
}
