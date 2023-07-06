import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        ]),
                  )));
  }
}
