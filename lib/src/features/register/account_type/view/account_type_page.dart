import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/register/models/models.dart';
import 'package:report_it_ips/src/features/register/personal_information/view/personal_information_page.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  bool _submitting = false;
  AccountTypes? _accountType;

  Future<AppUser> _continueToNextPage() async {
    setState(() {
      _submitting = true;
    });
    final user = AppUser(userType: _accountType!.name);
    // ! Uncomment this code to save the user to the database
    /* final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toJson(), SetOptions(merge: true));
    setState(() {
      _submitting = false;
    }); */
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        const BackgroundImage(top: true, bottom: true),
        // ? Remove this CloseButton
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
                          height: MediaQuery.of(context).size.height * 0.15),
                      Text(
                        L.of(context)!.conclude_registration,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        L.of(context)!.select_account_type,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Center(
                        child: Column(children: [
                          CustomLargeButton(
                            callback: () => {
                              setState(() {
                                _accountType = AccountTypes.student;
                              })
                            },
                            isSelected: _accountType == AccountTypes.student,
                            icon: Icons.person,
                            text: L.of(context)!.student,
                          ),
                          const SizedBox(height: 25),
                          CustomLargeButton(
                              callback: () => {
                                    setState(() {
                                      _accountType = AccountTypes.teacher;
                                    })
                                  },
                              isSelected: _accountType == AccountTypes.teacher,
                              icon: Icons.school,
                              text: L.of(context)!.teacher),
                          const SizedBox(height: 25),
                          CustomLargeButton(
                              callback: () => {
                                    setState(() {
                                      _accountType = AccountTypes.staff;
                                    })
                                  },
                              isSelected: _accountType == AccountTypes.staff,
                              icon: Icons.man_4,
                              text: L.of(context)!.staff),
                          const SizedBox(height: 50),
                          CustomSubmitButton(
                            enabled: _accountType != null,
                            color: Theme.of(context).colorScheme.primary,
                            text: L.of(context)!.next,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            callback: _accountType != null
                                ? () => _continueToNextPage().then((value) => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  PersonalInformationPage(
                                                    user: value,
                                                  )))
                                    })
                                : null,
                          )
                        ]),
                      )
                    ]),
              ),
      ],
    )));
  }
}
