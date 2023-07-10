//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/register/register.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});
  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  //Keys
  final _formKey = GlobalKey<FormState>();
  final _birthdateKey = GlobalKey<CustomDatePickerState>();
  //Fields
  String? _fieldName;
  DateTime? _fieldBirthdate;
  String? _fieldGender;
  //Constraints
  bool _keyboardIsVisible = false;
  bool _submitting = false;

  AppUser? user = AppUser();

  void _onSubmit() {
    setState(() {
      _submitting = true;
    });
    _formKey.currentState?.save();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _submitting = false;
      });
      showSnackbar(
          context: context,
          message: L.of(context)!.correct_errors,
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }
    user!.name = _fieldName!.trim();
    user!.birthdate = _fieldBirthdate;
    user!.gender = _fieldGender;
    setState(() {
      _submitting = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AccountTypePage(
              user: user!,
            )));
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom == 0
        ? _keyboardIsVisible = false
        : _keyboardIsVisible = true;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(
          children: [
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
                              L.of(context)!.fill_in_your_personal_details,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Center(
                              child: Column(children: [
                                Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      CustomFormInputField(
                                        labelText: L.of(context)!.name,
                                        prefixIcon: Icons.person_outline,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return L.of(context)!.name_required;
                                          }
                                          return null;
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        errorColor:
                                            Theme.of(context).colorScheme.error,
                                        onSaved: (value) => _fieldName = value,
                                        onFieldSubmitted: (value) => {
                                          _birthdateKey.currentState
                                              ?.pickDate(context),
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      CustomDatePicker(
                                          key: _birthdateKey,
                                          labelText: L.of(context)!.birthdate,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          errorColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return L
                                                  .of(context)!
                                                  .birthdate_required;
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => {
                                                _fieldBirthdate = value,
                                              }),
                                      const SizedBox(height: 40),
                                      CustomDropdownButton(
                                        label: L.of(context)!.gender,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        errorColor:
                                            Theme.of(context).colorScheme.error,
                                        items: {
                                          "MALE": L.of(context)!.male,
                                          "FEMALE": L.of(context)!.female,
                                          "OTHER": L.of(context)!.other
                                        },
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return L
                                                .of(context)!
                                                .gender_required;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => {
                                          _fieldGender = value,
                                        },
                                      )
                                    ])),
                                const SizedBox(height: 50),
                                CustomSubmitButton(
                                    text: L.of(context)!.next,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    textColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    callback: _onSubmit),
                              ]),
                            )
                          ],
                        ))),
            if (!_keyboardIsVisible)
              Padding(
                  padding: const EdgeInsets.all(25),
                  child: CloseButton(
                      color: Theme.of(context).colorScheme.primary,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      onPressed: () => {
                            FirebaseAuth.instance.signOut(),
                          })),
          ],
        )));
  }
}
