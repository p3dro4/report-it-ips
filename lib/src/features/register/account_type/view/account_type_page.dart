import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/utils/background_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        const BackgroundImage(top: true, bottom: true),
        // ! back button used for debugging remove later
        Padding(
            padding: const EdgeInsets.all(30),
            child: CloseButton(
                color: Theme.of(context).colorScheme.primary,
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                ),
                onPressed: () => {
                      FirebaseAuth.instance.signOut(),
                    })),
        _submitting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.17),
                      Text(
                        L.of(context)!.conclude_registration,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        L.of(context)!.select_account_type,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ]),
              ),
      ],
    )));
  }
}
