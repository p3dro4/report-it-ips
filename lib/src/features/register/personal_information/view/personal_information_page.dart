import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/register/models/models.dart';
import 'package:report_it_ips/src/utils/custom_widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key, required this.user});
  final AppUser user;
  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(35),
            child: Align(
                alignment: Alignment.topLeft,
                child: CustomBackButton(
                    callback: () => {
                          Navigator.of(context).pop(),
                        },
                    text: L.of(context)!.back,
                    color: Theme.of(context).colorScheme.primary))),
        const Text("Main Feed Page", style: TextStyle(fontSize: 20)),
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
