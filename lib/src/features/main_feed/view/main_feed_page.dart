import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:report_it_ips/src/features/register/register.dart';

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  bool processing = false;

  @override
  void initState() {
    isRegistered()
        .then((registered) => {
              if (!registered)
                {
                  Navigator.popUntil(context, (route) => route.isFirst),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  )
                }
            })
        .then((value) => {
              setState(() => processing = false)
            });
    super.initState();
  }

  Future<bool> isRegistered() async {
    setState(() {
      processing = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where("userId", isEqualTo: user.uid)
          .get();
      for (final doc in userDoc.docs) {
        final data = doc.data();
        return data["profileCompleted"] as bool;
      }
    }
    return false;
  }

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
