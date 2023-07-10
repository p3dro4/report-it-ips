import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  String? _email;

  Future<void> _submit() async {
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

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _email!)
        .then((value) => {
              showSnackbar(
                context: context,
                message: L.of(context)!.recover_email_sent,
                backgroundColor: Colors.green,
              ),
              Navigator.of(context).pop(),
            })
        .then((value) => {
              setState(() {
                _submitting = false;
              })
            })
        .catchError((error) => {
              showSnackbar(
                context: context,
                message: L.of(context)!.email_not_registered,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(children: [
            const BackgroundImage(top: true, bottom: true),
            _submitting
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.15),
                          Text(
                            L.of(context)!.recover_password,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            L.of(context)!.insert_email,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Form(
                              key: _formKey,
                              child: CustomFormInputField(
                                prefixIcon: Icons.email_outlined,
                                labelText: L.of(context)!.email,
                                keyboardType: TextInputType.emailAddress,
                                color: Theme.of(context).colorScheme.primary,
                                errorColor: Theme.of(context).colorScheme.error,
                                onSaved: (value) => {_email = value},
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
                          const SizedBox(height: 40),
                          CustomSubmitButton(
                              text: L.of(context)!.send_email,
                              callback: _submit,
                              color: Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary),
                        ])),
            CustomBackButton(
              text: L.of(context)!.back,
              callback: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ]),
        ));
  }
}
