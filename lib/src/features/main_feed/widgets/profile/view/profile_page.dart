import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.user,
      required this.profile,
      required this.onRefresh,
      required this.reports});

  final AppUser user;
  final AppProfile profile;
  final Future<Map<String, Report>> Function() onRefresh;
  final Map<String, Report> reports;

  static AppBar appBar(
      BuildContext context, AppProfile profile, void Function() onRefresh) {
    return AppBar(
      titleSpacing: 20,
      title: Text(L.of(context)!.profile,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
                onPressed: () async {
                  bool refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsPage(
                                profile: profile,
                              )));
                  if (refresh) {
                    onRefresh();
                  }
                },
                icon: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                  weight: 300,
                )))
      ],
    );
  }

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  AppProfile? profile;
  AppUser? user;
  Map<String, Report> _reports = {};
  Map<DateTime, Map<String, Report>> _userReportsByDate = {};
  late List<Widget> _userReportsByDateWidgets;
  final upvoteValue = 10;
  bool _processing = false;
  late Future<Map<String, Report>> Function() _onRefresh;

  String _getSubText() {
    return switch (user!.userType) {
      AccountTypes.student =>
        "${user!.school!.fullName}, ${user!.course!} - ${user!.schoolYear}º ${L.of(context)!.year}",
      _ => "",
    };
  }

  @override
  void initState() {
    _processing = true;
    user = widget.user;
    profile = widget.profile;
    _reports = widget.reports;
    _onRefresh = widget.onRefresh;
    _userReportsByDate = _getUserReports(_organizeByDate());
    _userReportsByDateWidgets = _getUserReportsItems();
    _updateProfile().then((value) => {
          setState(() {
            _processing = false;
          })
        });
    super.initState();
  }

  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      AppProfile profile = AppProfile.fromSnapshot(value.data()!);
      profile.nReports = _userReportsByDate.length;
      profile.nPoints = _reports.values
          .where((element) =>
              element.uid == FirebaseAuth.instance.currentUser!.uid)
          .map((e) => e.upvotes! * upvoteValue)
          .reduce((value, element) => value + element);

      return profile;
    }).then((value) => {
              FirebaseFirestore.instance
                  .collection("profiles")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set(value.toJson(), SetOptions(merge: true)),
              setState(() {
                profile = value;
              })
            });
  }

  Map<DateTime, Map<String, Report>> _organizeByDate() {
    Map<DateTime, Map<String, Report>> reportsByDate = {};
    _reports.forEach((key, value) {
      DateTime dateTime = DateFormat("dd-MM-yyyy").parse(
          DateFormat("dd-MM-yyyy").format(value.timestamp ?? DateTime.now()));
      if (reportsByDate.containsKey(dateTime)) {
        reportsByDate[dateTime]!.addAll({key: value});
      } else {
        reportsByDate.addAll({
          dateTime: {key: value}
        });
      }
    });
    return reportsByDate;
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

  List<Widget> _getUserReportsItems() {
    List<Widget> reportsList = [];

    for (int index = 0; index < _userReportsByDate.length; index++) {
      reportsList.add(Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("MMM dd")
                    .format(_userReportsByDate.keys.toList()[index]),
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              )),
          Column(
            children: _userReportsByDate.values
                .toList()[index]
                .entries
                .map((e) => ListReportItem(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsReportPage(
                                      report: e.value,
                                    ))).then((value) => setState(() {}));
                      },
                      report: e.value,
                      id: e.key,
                    ))
                .toList(),
          )
        ],
      ));
    }
    return reportsList;
  }

  Map<DateTime, Map<String, Report>> _getUserReports(
      Map<DateTime, Map<String, Report>> reportsByDate) {
    Map<DateTime, Map<String, Report>> userReports = {};
    reportsByDate.forEach((key, value) {
      value.entries.forEach((element) {
        if (element.value.uid != FirebaseAuth.instance.currentUser!.uid) return;
        userReports.addAll({
          key: {element.key: element.value}
        });
      });
    });
    return userReports;
  }

  Future<void> _onRefreshed() async {
    setState(() {
      _processing = true;
    });
    await _onRefresh().then((value) {
      setState(() {
        _reports = value;
        _userReportsByDateWidgets = _getUserReportsItems();
      });
    });
    await _updateProfile().then((value) => {
          setState(() {
            _processing = false;
          })
        });
  }

  // TODO Add functionality to view leaderboard
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).primaryColorDark,
      child: _processing
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RefreshIndicator(
                  onRefresh: _onRefreshed,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                  child: FirebaseAuth
                                              .instance.currentUser!.photoURL !=
                                          null
                                      ? Image.network(
                                          FirebaseAuth
                                              .instance.currentUser!.photoURL!,
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                  child: Text(
                                      "+ ${L.of(context)!.add_bio.toUpperCase()}",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  BannerProfile(
                                      icon: Icons.flag_circle,
                                      label: L.of(context)!.number_of_reports,
                                      value:
                                          profile?.nReports.toString() ?? "0"),
                                  BannerProfile(
                                    icon: Icons.timeline,
                                    label: L.of(context)!.number_of_points,
                                    value: profile?.nPoints.toString() ?? "0",
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                          if (_userReportsByDateWidgets.isEmpty)
                            const SizedBox(
                              height: 100,
                            ),
                          _userReportsByDateWidgets.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child:
                                      Text("${L.of(context)!.no_reports_yet}!",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          )))
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: _userReportsByDateWidgets,
                                  )),
                        ],
                      )))),
    );
  }
}
