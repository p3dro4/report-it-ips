import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user, required this.profile});

  final AppUser user;
  final AppProfile profile;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  AppProfile? profile;
  AppUser? user;

  String _getSubText() {
    return switch (user!.userType) {
      AccountTypes.student =>
        "${user!.school!.fullName}, ${user!.course!} - ${user!.schoolYear}º ${L.of(context)!.year}",
      _ => "",
    };
  }

  @override
  void initState() {
    user = widget.user;
    profile = widget.profile;
    super.initState();
  }

  String _getLeague(int? nPoints) {
    if (nPoints == null) return L.of(context)!.bronze;
    return switch (nPoints) {
      > 100 && < 200 => L.of(context)!.silver,
      > 200 && < 300 => L.of(context)!.gold,
      > 300 && < 400 => L.of(context)!.platinum,
      > 400 && < 500 => L.of(context)!.diamond,
      > 500 => L.of(context)!.reporter,
      _ => "Bronze",
    };
  }

  Color _getColor(int? nPoints) {
    if (nPoints == null) return const Color(0xFFAA745C);
    return switch (nPoints) {
      > 100 && < 200 => const Color(0xFF7b89a2),
      > 200 && < 300 => const Color(0xFFffaf50),
      > 300 && < 400 => const Color(0xFF3d615b),
      > 400 && < 500 => const Color(0xFF51cbe1),
      > 500 => const Color(0xFFb04025),
      _ => const Color(0xFFAA745C),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
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
                          child: FirebaseAuth.instance.currentUser!.photoURL !=
                                  null
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
                    profile?.displayName ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(_getSubText(),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  profile!.bio != null && profile!.bio!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(profile!.bio!,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )))
                      : TextButton(
                          onPressed: () async {
                            bool refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                          profile: profile,
                                        )));
                            if (refresh) {
                              setState(() {});
                            }
                          },
                          child:
                              Text("+ ${L.of(context)!.add_bio.toUpperCase()}",
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
                          BannerProfile(
                            icon: Icons.timeline,
                            label: L.of(context)!.number_of_points,
                            value: profile?.nPoints == null
                                ? profile?.nPoints.toString()
                                : "0",
                          ),
                          BannerProfile(
                            icon: Icons.local_police,
                            label: L.of(context)!.league,
                            value: _getLeague(profile?.nPoints),
                            iconColor: _getColor(profile?.nPoints),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(L.of(context)!.reports,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ],
              ))),
        )));
  }
}
