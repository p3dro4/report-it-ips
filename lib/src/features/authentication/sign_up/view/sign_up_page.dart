import 'package:flutter/material.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? _fieldConfirmPassword;
  String? _fieldEmail;
  String? _fieldPassword;
  final _formKey = GlobalKey<FormState>();
  bool _omitTopBackground = false;
  bool _submitting = false;

  Future<void> _firebaseSignUp(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mostrar mensagem de sucesso
      if (!mounted) return;
      showSnackbar(
        context: context,
        message: L.of(context)!.account_created_successfully,
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(
          context: context,
          message: L.of(context)!.weak_password,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(
          context: context,
          message: L.of(context)!.email_already_in_use,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (e) {
      showSnackbar(
        context: context,
        message: L.of(context)!.unknown_error,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  void _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
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
    if (_fieldPassword != _fieldConfirmPassword) {
      setState(() {
        _submitting = false;
      });
      showSnackbar(
          context: context,
          message: L.of(context)!.passwords_mismatch,
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }

    await _firebaseSignUp(
      email: _fieldEmail!,
      password: _fieldPassword!,
    );

    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      setState(() {
        _omitTopBackground = true;
      });
    } else {
      setState(() {
        _omitTopBackground = false;
      });
    }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          BackgroundImage(
              top: !_omitTopBackground,
              bottom: _submitting && !_omitTopBackground),
          _submitting
              ? const Center(child: CircularProgressIndicator())
              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  L.of(context)!.create_account,
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                )),
                            const SizedBox(height: 10),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  L.of(context)!.fill_in_your_details,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )),
                            // * This SizedBox is used to push the form up when the keyboard is open
                            SizedBox(
                                height:
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                        ? 15
                                        : MediaQuery.of(context).size.height *
                                            0.08),
                            Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        decoration: InputCustomDecorations
                                            .textFieldInput(
                                                Icons.email_outlined,
                                                L.of(context)!.email,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                null,
                                                null),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
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
                                        onSaved: (value) => _fieldEmail = value,
                                      ),
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        decoration: InputCustomDecorations
                                            .textFieldInput(
                                                Icons.lock_outline_rounded,
                                                L.of(context)!.password,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                null,
                                                null),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.next,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return L
                                                .of(context)!
                                                .password_required;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            _fieldPassword = value,
                                      ),
                                      const SizedBox(height: 15),
                                      TextFormField(
                                        decoration: InputCustomDecorations
                                            .textFieldInput(
                                                Icons.lock_outline_rounded,
                                                L.of(context)!.confirm_password,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                null,
                                                null),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        textInputAction: TextInputAction.done,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return L
                                                .of(context)!
                                                .password_required;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) =>
                                            _fieldConfirmPassword = value,
                                        onFieldSubmitted: (value) =>
                                            _onSubmit(),
                                      ),
                                      const SizedBox(height: 50),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Center(
                                              child: ElevatedButton(
                                            onPressed: _onSubmit,
                                            style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(5),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20)),
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      const Size(
                                                          double.infinity, 45)),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            ),
                                            child: Text(
                                                L.of(context)!.create_account,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Roboto",
                                                    fontWeight: FontWeight.w400,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary)),
                                          ))),
                                    ])),
                            // * This SizedBox is used to push the form up when the keyboard is open
                            SizedBox(
                                height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom >
                                        0
                                    ? MediaQuery.of(context).viewInsets.bottom
                                    : MediaQuery.of(context).size.height * 0.1),
                          ]))
                ]),
          if (!_submitting && !_omitTopBackground)
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(35),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: CustomBackButton(
                              color: Theme.of(context).colorScheme.primary))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(L.of(context)!.dont_have_an_account,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500)),
                              TextButton(
                                onPressed: () => {
                                  Navigator.of(context).pop(),
                                },
                                style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(left: 5)),
                                ),
                                child: Text(L.of(context)!.login,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w900)),
                              )
                            ])),
                  )
                ])
        ])));
  }
}
