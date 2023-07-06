import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Register", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text("Sign Out"),
          onPressed: () => {
            FirebaseAuth.instance.signOut(),
          },
        ),
      ]),
    ));
  }
}