import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/models/profile.dart';
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
  String? _fieldName;
  String? _fieldBio;
  String? _fieldEmail;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  @override
  void initState() {
    profile = widget.profile;
    super.initState();
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _submitting = true;
    });

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      profile!.displayName = _fieldName!.trim();
      profile!.bio = _fieldBio!.trim();
      FirebaseAuth.instance.currentUser!.updateEmail(_fieldEmail!.trim());
      FirebaseAuth.instance.currentUser!.updateDisplayName(_fieldName!.trim());

      await ProfileHandler.updateProfile(
              profile!, FirebaseAuth.instance.currentUser!.uid)
          .then((value) => {
                setState(() {
                  _submitting = false;
                }),
                Navigator.of(context).pop(true)
              });
      setState(() {
        _submitting = false;
      });
    }
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
              fontWeight: FontWeight.w500,
            )),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () => {_onSubmit()},
                  icon: Icon(
                    Icons.save,
                    color: Theme.of(context).colorScheme.onPrimary,
                    weight: 300,
                  )))
        ],
      ),
      body: _submitting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).primaryColorDark,
              width: double.infinity,
              height: double.infinity,
              child: Form(
                  key: _formKey,
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
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                              .colorScheme
                                              .brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                  border: Border.all(
                                    color: Theme.of(context)
                                                .colorScheme
                                                .brightness ==
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
                                      color: Theme.of(context)
                                                  .colorScheme
                                                  .brightness ==
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
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomSettingsInputField(
                            label: L.of(context)!.name,
                            hintText: L.of(context)!.name,
                            currentValue: profile!.displayName,
                            onSaved: (value) => {_fieldName = value},
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            capitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return L.of(context)!.name_required;
                              }
                              return null;
                            },
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: CustomSettingsInputField(
                            label: L.of(context)!.bio,
                            hintText: L.of(context)!.bio_text,
                            currentValue: profile!.bio,
                            onSaved: (value) => {_fieldBio = value},
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      if (FirebaseAuth.instance.currentUser!.email != null)
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: CustomSettingsInputField(
                              label: L.of(context)!.email,
                              hintText: L.of(context)!.email,
                              currentValue:
                                  FirebaseAuth.instance.currentUser!.email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onSaved: (value) => {_fieldEmail = value},
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return L.of(context)!.email_required;
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)) {
                                  return L.of(context)!.email_invalid;
                                }
                                return null;
                              },
                            )),
                      if (FirebaseAuth.instance.currentUser!.email != null)
                        const SizedBox(
                          height: 30,
                        ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () =>
                                    {FirebaseAuth.instance.signOut()},
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    side: MaterialStateProperty.all(BorderSide(
                                        color:
                                            Theme.of(context).brightness == Brightness.light
                                                ? Colors.black
                                                : Colors.white,
                                        width: 4)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(15))),
                                child: Text(L.of(context)!.sign_out,
                                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
                          )),
                    ],
                  )),
            )),
    );
  }
}
