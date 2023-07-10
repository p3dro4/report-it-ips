import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppProfile? profile;

  Future<void> _createProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    AppProfile profile = AppProfile(
      displayName: FirebaseAuth.instance.currentUser!.displayName!,
      photoURL: FirebaseAuth.instance.currentUser!.photoURL,
    );
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .set(profile.toJson())
        .then((value) => {
              setState(() {
                this.profile = profile;
              })
            });
  }

  Future<void> _getProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((value) => {
              setState(() {
                profile = AppProfile.fromSnapshot(value.data()!);
              })
            })
        .onError((error, stackTrace) => {_createProfile()});
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).primaryColorDark,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              const SizedBox(
                height: 15,
              ),
              AutoSizeText(
                FirebaseAuth.instance.currentUser!.displayName!,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsPage())),
                      },
                  child: Text("+ ${L.of(context)!.add_bio}",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ))),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BannerProfile(
                          icon: Icons.flag_circle,
                          label: L.of(context)!.number_of_reports,
                          value: profile?.nReports == null
                              ? profile?.nReports.toString()
                              : "0"),
                      BannerProfile(),
                      BannerProfile()
                    ],
                  )),
            ],
          ))),
    );
  }
}
