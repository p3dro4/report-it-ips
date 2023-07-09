import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/main_feed.dart';
import 'package:report_it_ips/src/features/register/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/register/institutional_information/widgets/widgets.dart';

class InstitutionalInformationPage extends StatefulWidget {
  const InstitutionalInformationPage({super.key, required this.user});
  final AppUser user;

  @override
  State<InstitutionalInformationPage> createState() =>
      _InstitutionalInformationPageState();
}

class _InstitutionalInformationPageState
    extends State<InstitutionalInformationPage> {
  bool _submitting = false;
  bool _keyboardIsVisible = false;
  AppUser? user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  Future<void> _onSubmit(AppUser user) async {
    setState(() {
      _submitting = true;
    });
    user.profileCompleted = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toJson(), SetOptions(merge: true));
    List<String> splitName = user.name!.split(' ');
    FirebaseAuth.instance.currentUser!.updateDisplayName(
        "${splitName[0]} ${splitName[splitName.length - 1]}");
    setState(() {
      _submitting = false;
    });
  }

  MaterialPageRoute _mainScreen() {
    return MaterialPageRoute(
        builder: (context) => MainFeedPage(
              user: user!,
            ));
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom == 0
        ? _keyboardIsVisible = false
        : _keyboardIsVisible = true;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(children: [
          BackgroundImage(
              top: !_keyboardIsVisible, bottom: !_keyboardIsVisible),
          _submitting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SingleChildScrollView(
                      physics: MediaQuery.of(context).viewInsets.bottom == 0
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                                height: _keyboardIsVisible
                                    ? MediaQuery.of(context).size.height * 0.05
                                    : MediaQuery.of(context).size.height *
                                        0.15),
                            Text(
                              L.of(context)!.conclude_registration,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              L.of(context)!.fill_in_your_institution_details,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            switch (user!.userType) {
                              AccountTypes.student => StudentFormPage(
                                  user: user!,
                                  onSubmit: (value) => {
                                    _onSubmit(value).then((value) =>
                                        Navigator.push(context, _mainScreen()))
                                  },
                                ),
                              AccountTypes.teacher => TeacherFormPage(
                                  user: user!,
                                  onSubmit: (value) => {
                                    _onSubmit(value).then((value) =>
                                        Navigator.push(context, _mainScreen()))
                                  },
                                ),
                              AccountTypes.staff => StaffFormPage(
                                  user: user!,
                                  onSubmit: (value) => {
                                    _onSubmit(value).then((value) =>
                                        Navigator.push(context, _mainScreen()))
                                  },
                                ),
                              _ => Container(),
                            }
                          ]))),
          if (!_keyboardIsVisible)
            CustomBackButton(
              text: L.of(context)!.back,
              callback: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.primary,
            ),
        ])));
  }
}
