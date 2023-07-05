import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/authentication/authentication.dart';
import 'package:report_it_ips/src/features/authentication/login/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _fieldEmail;
  String? _fieldPassword;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _omitTopBackground = false;
  bool _submitting = false;

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
          message: L.of(context)!.login_success,
          backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(
            context: context,
            message: L.of(context)!.user_not_found,
            backgroundColor: Theme.of(context).colorScheme.error);
      } else if (e.code == 'wrong-password') {
        showSnackbar(
            context: context,
            message: L.of(context)!.wrong_password,
            backgroundColor: Theme.of(context).colorScheme.error);
      }
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
            child: Stack(
          children: [
            BackgroundImage(
                top: !_omitTopBackground,
                bottom: _submitting && !_omitTopBackground),
            _submitting
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      L.of(context)!.sign_in,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    )),
                                const SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      L.of(context)!.please_sign_in,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    )),
                                // * This SizedBox is used to push the form up when the keyboard is open
                                SizedBox(
                                    height: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 15
                                        : MediaQuery.of(context).size.height *
                                            0.05),
                                Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomWidgets.customFormInputField(
                                          prefixIcon: Icons.email_outlined,
                                          labelText: L.of(context)!.email,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          errorColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          suffixIcon: null,
                                          callbackSuffixIcon: null,
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
                                              return L
                                                  .of(context)!
                                                  .email_invalid;
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _fieldEmail = value,
                                        ),
                                        const SizedBox(height: 10),
                                        CustomWidgets.customFormInputField(
                                          prefixIcon:
                                              Icons.lock_outline_rounded,
                                          labelText: L.of(context)!.password,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          errorColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          suffixIcon: _obscureText
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          callbackSuffixIcon: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.done,
                                          obscureText: _obscureText,
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
                                          onFieldSubmitted: (_) => _onSubmit(),
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                                onPressed: () => {},
                                                style: const ButtonStyle(
                                                  padding:
                                                      MaterialStatePropertyAll(
                                                          EdgeInsets.zero),
                                                ),
                                                child: Text(
                                                    L
                                                        .of(context)!
                                                        .forgot_password,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 14,
                                                        fontFamily: "Roboto",
                                                        fontWeight:
                                                            FontWeight.w700)))),
                                        const SizedBox(height: 15),
                                        CustomWidgets.customSubmitButton(
                                          _onSubmit,
                                          L.of(context)!.sign_in,
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ],
                                    )),
                                // * This SizedBox is used to push the form up when the keyboard is open
                                SizedBox(
                                    height: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0
                                        ? 0
                                        : MediaQuery.of(context).size.height *
                                            0.1),
                              ],
                            )),
                        // * This SizedBox is used to push the form up when the keyboard is open
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ]),
            if (!_submitting)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(L.of(context)!.or_sign_in_with,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
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
                        imageLocation: "assets/images/icons/microsoft.png",
                        height: 36,
                        width: 36,
                      ),
                      const SizedBox(width: 40),
                      ProviderButton(
                        onPressed: () => {},
                        imageLocation: "assets/images/icons/twitter.png",
                        height: 38,
                        width: 38,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpPage(),
                                    ),
                                  ),
                                },
                                style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.only(left: 5)),
                                ),
                                child: Text(L.of(context)!.sign_up,
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
                ],
              ),
          ],
        )));
  }
}
