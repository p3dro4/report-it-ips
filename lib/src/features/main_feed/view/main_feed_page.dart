import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Sign Out"),
          onPressed: () => {
            FirebaseAuth.instance.signOut(),
          },
        ),
      ),
    );
  }
}
