import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/autentication/login/widgets/provider_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;
  bool _obscureText = true;
  String? _fieldEmail;
  String? _fieldPassword;

  Future<void> _firebaseSignIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      showSnackbar(
          context: context,
          message: AppLocalizations.of(context)!.login_success,
          backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(
            context: context,
            message: AppLocalizations.of(context)!.user_not_found,
            backgroundColor: Theme.of(context).colorScheme.error);
      } else if (e.code == 'wrong-password') {
        showSnackbar(
            context: context,
            message: AppLocalizations.of(context)!.wrong_password,
            backgroundColor: Theme.of(context).colorScheme.error);
      }
    }
  }

  void _onSubmit() async {
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
        message: AppLocalizations.of(context)!.correct_errors,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    await _firebaseSignIn(
      email: _fieldEmail!,
      password: _fieldPassword!,
    );

    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(children: [
          Align(
              alignment: Alignment.topRight,
              child: Image.asset("assets/images/backgrounds/background_top.png",
                  height: 120, width: 170, fit: BoxFit.fill)),
          SafeArea(
              minimum: const EdgeInsets.all(35),
              child: _submitting
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                style: Theme.of(context).textTheme.displayLarge,
                              )),
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  AppLocalizations.of(context)!.please_sign_in,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall)),
                          const SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  decoration:
                                      InputCustomDecorations.autenticationInput(
                                          Icons.email_outlined,
                                          AppLocalizations.of(context)!.email,
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.error,
                                          null,
                                          null),
                                  autofocus: false,
                                  initialValue: _fieldEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return AppLocalizations.of(context)!
                                          .email_required;
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!)) {
                                      return AppLocalizations.of(context)!
                                          .email_invalid;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _fieldEmail = value,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  decoration:
                                      InputCustomDecorations.autenticationInput(
                                    Icons.lock_outline,
                                    AppLocalizations.of(context)!.password,
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.error,
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    () => setState(() {
                                      _obscureText = !_obscureText;
                                    }),
                                  ).copyWith(),
                                  textAlignVertical: TextAlignVertical.center,
                                  initialValue: _fieldPassword,
                                  obscureText: _obscureText,
                                  autocorrect: false,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return AppLocalizations.of(context)!
                                          .password_required;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _fieldPassword = value,
                                  onFieldSubmitted: (_) => _onSubmit(),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                        onPressed: () => {},
                                        style: const ButtonStyle(
                                          padding: MaterialStatePropertyAll(
                                              EdgeInsets.zero),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .forgot_password,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 14,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w700)))),
                                const SizedBox(height: 15),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Center(
                                        child: ElevatedButton(
                                      onPressed: _onSubmit,
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 20)),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(double.infinity, 45)),
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
                                          AppLocalizations.of(context)!.login,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary)),
                                    ))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 80),
                          Text(AppLocalizations.of(context)!.or_sign_in_with,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.normal)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProviderButton(
                                onPressed: () => {},
                                imageLocation: "assets/images/icons/google.png",
                                height: 48,
                                width: 48,
                              ),
                              const SizedBox(width: 40),
                              ProviderButton(
                                onPressed: () => {},
                                imageLocation:
                                    "assets/images/icons/microsoft.png",
                                height: 36,
                                width: 36,
                              ),
                              const SizedBox(width: 40),
                              ProviderButton(
                                onPressed: () => {},
                                imageLocation:
                                    "assets/images/icons/twitter.png",
                                height: 38,
                                width: 38,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .dont_have_an_account,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.w500)),
                                      TextButton(
                                        onPressed: () => {},
                                        style: const ButtonStyle(
                                          padding: MaterialStatePropertyAll(
                                              EdgeInsets.only(left: 5)),
                                        ),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .sign_up,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                      )
                                    ])),
                          )
                        ])),
        ]));
  }
}
