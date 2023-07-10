import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(L.of(context)!.settings,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
                color: Theme.of(context).colorScheme.onPrimary,
              ))),
      body: SafeArea(
          child: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).primaryColorDark,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => {FirebaseAuth.instance.signOut()},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        side: MaterialStateProperty.all(BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            width: 4)),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(15))
                      ),
                      child: Text(L.of(context)!.sign_out,
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                ))
          ],
        ),
      )),
    );
  }
}
