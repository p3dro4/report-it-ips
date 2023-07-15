import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/models/profile.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/profile/settings/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _showImagePicker = false;
  File? _imageFile;
  bool _showLoginPrompt = false;

  @override
  void initState() {
    profile = widget.profile;
    super.initState();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _imageFile = File(image.path);
      });
    } on PlatformException catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falhou a selecionar a imagem!'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  Future<void> _localAuthenticate() async {
    try {

      setState(() {});
    } on PlatformException catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(L.of(context)!.authentication_error),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _submitting = true;
    });

    _formKey.currentState!.save();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _submitting = false;
      });
      showSnackbar(
        context: context,
        message: L.of(context)!.correct_errors,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }
    _localAuthenticate().then((value) async {
      profile!.displayName = _fieldName!.trim();
      profile!.bio = _fieldBio!.trim();
      FirebaseAuth.instance.currentUser!.updateEmail(_fieldEmail!.trim());
      FirebaseAuth.instance.currentUser!.updateDisplayName(_fieldName!.trim());
      if (_imageFile != null) {
        await FirebaseStorage.instance
            .ref("profile/${FirebaseAuth.instance.currentUser!.uid}")
            .putFile(_imageFile!)
            .then((file) => file.ref.getDownloadURL().then((value) {
                  profile!.photoURL = value;
                  FirebaseAuth.instance.currentUser!.updatePhotoURL(value);
                }));
      }
      await ProfileHandler.updateProfile(
              profile!, FirebaseAuth.instance.currentUser!.uid)
          .then((value) => {
                setState(() {
                  _submitting = false;
                }),
                Navigator.of(context).pop(true),
                showSnackbar(
                  context: context,
                  message: L.of(context)!.profile_updated_successfully,
                  backgroundColor: Colors.green,
                )
              });
    }).onError((error, stackTrace) {
      setState(() {
        _submitting = false;
      });
      showSnackbar(
        context: context,
        message: L.of(context)!.authentication_error,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    });
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
                child: Stack(
                children: [
                  Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).primaryColorDark,
                      width: double.infinity,
                      height: double.infinity,
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: _imageFile != null
                                              ? Image.file(
                                                  _imageFile!,
                                                  fit: BoxFit.cover,
                                                )
                                              : FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .photoURL !=
                                                      null
                                                  ? Image.network(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .photoURL!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/profile/default_profile.png",
                                                      fit: BoxFit.cover,
                                                    ))),
                                  // TODO Add functionality to edit profile picture
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
                                              onPressed: () => {
                                                    setState(() {
                                                      _showImagePicker = true;
                                                    })
                                                  },
                                              padding: const EdgeInsets.all(0),
                                              visualDensity:
                                                  VisualDensity.compact,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
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
                                if (FirebaseAuth.instance.currentUser!.email !=
                                    null)
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: CustomSettingsInputField(
                                        label: L.of(context)!.email,
                                        hintText: L.of(context)!.email,
                                        currentValue: FirebaseAuth
                                            .instance.currentUser!.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        onSaved: (value) =>
                                            {_fieldEmail = value},
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return L
                                                .of(context)!
                                                .email_required;
                                          }
                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value!)) {
                                            return L.of(context)!.email_invalid;
                                          }
                                          return null;
                                        },
                                      )),
                                if (FirebaseAuth.instance.currentUser!.email !=
                                    null)
                                  const SizedBox(
                                    height: 30,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 5, bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      L.of(context)!.account,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  padding: const EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  child: TextButton(
                                    onPressed: () async {},
                                    child: Row(children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.lock_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(L.of(context)!.change_password,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))
                                    ]),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryColorDark,
                                  thickness: 2,
                                  height: 0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _submitting = true;
                                      });
                                      FirebaseAuth.instance.currentUser!
                                          .delete()
                                          .then((value) => showSnackbar(
                                              context: context,
                                              message: L
                                                  .of(context)!
                                                  .account_deleted_successfully,
                                              backgroundColor: Colors.green))
                                          .catchError((error) {
                                        setState(() {
                                          _submitting = false;
                                        });
                                        showSnackbar(
                                            context: context,
                                            message: L
                                                .of(context)!
                                                .account_deletion_error,
                                            backgroundColor: Colors.red);
                                      });
                                    },
                                    child: Row(children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(L.of(context)!.delete_account,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))
                                    ]),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                          onPressed: () =>
                                              {FirebaseAuth.instance.signOut()},
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.black
                                                          : Colors.white,
                                                      width: 4)),
                                              padding: MaterialStateProperty.all(const EdgeInsets.all(15))),
                                          child: Text(L.of(context)!.sign_out, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
                                    )),
                                SizedBox(
                                    height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        30)
                              ],
                            )),
                      )),
                  if (_showLoginPrompt)
                    LoginPrompt(
                      onCancel: () {
                        setState(() {
                          _showLoginPrompt = false;
                        });
                      },
                      onLogin: (value) async {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email:
                                FirebaseAuth.instance.currentUser!.email ?? "",
                            password: value);
                      },
                    ),
                  if (_showImagePicker)
                    PromptSelectImage(onCancel: () {
                      setState(() {
                        _showImagePicker = false;
                      });
                    }, onSelect: (value) {
                      setState(() {
                        _showImagePicker = false;
                      });
                      pickImage(value);
                    }),
                ],
              )));
  }
}
