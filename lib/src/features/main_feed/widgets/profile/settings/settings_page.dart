import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/settings/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.profile});

  final AppProfile? profile;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppProfile? profile;

  @override
  void initState() {
    profile = widget.profile;
    print(profile);
    super.initState();
  }

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
              height: 25,
            ),
            Stack(children: [
              Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 5,
                    ),
                  ),
                  height: 125,
                  width: 125,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: FirebaseAuth.instance.currentUser!.photoURL != null
                          ? Image.network(
                              FirebaseAuth.instance.currentUser!.photoURL!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/profile/default_profile.png",
                              fit: BoxFit.cover,
                            ))),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Colors.black,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                          onPressed: () => {},
                          padding: const EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                            size: 25,
                          ))))
            ]),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: CustomSettingsInputField(
                  label: L.of(context)!.name,
                  hintText: FirebaseAuth.instance.currentUser!.displayName,
                  currentValue: profile!.displayName,
                )),
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => {FirebaseAuth.instance.signOut()},
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          side: MaterialStateProperty.all(BorderSide(
                              color:
                                  Theme.of(context).brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                              width: 4)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15))),
                      child: Text(L.of(context)!.sign_out,
                          style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                )),
          ],
        ),
      )),
    );
  }
}
