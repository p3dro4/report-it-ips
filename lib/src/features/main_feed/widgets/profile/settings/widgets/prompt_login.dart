import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class LoginPrompt extends StatefulWidget {
  const LoginPrompt({super.key, this.onCancel, this.onLogin});

  final Function()? onCancel;
  final Function(String)? onLogin;

  @override
  State<LoginPrompt> createState() => _LoginPromptState();
}

class _LoginPromptState extends State<LoginPrompt> {
  late Function()? onCancel;
  late Function(String)? onLogin;
  String? password;
  bool isPasswordVisible = false;

  @override
  void initState() {
    onCancel = widget.onCancel;
    onLogin = widget.onLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TapRegion(
          onTapOutside: (event) {
            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
            child: TapRegion(
                onTapOutside: (event) {
                  if (onCancel != null) {
                    onCancel!();
                  }
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        L.of(context)!.login_to_continue,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomFormInputField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            obscureText: !isPasswordVisible,
                            suffixIcon: isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            callbackSuffixIcon: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            prefixIcon: Icons.lock_outline,
                            labelText: L.of(context)!.password),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomSubmitButton(
                            text: L.of(context)!.login,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            callback: () {
                              if (onLogin != null) {
                                onLogin!(password!);
                              }
                            }),
                      )
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }
}
