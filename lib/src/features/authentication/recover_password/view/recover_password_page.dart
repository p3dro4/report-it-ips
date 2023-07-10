import 'package:flutter/material.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  bool _submitting = false;
  bool _keyboardIsVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom == 0
        ? _keyboardIsVisible = false
        : _keyboardIsVisible = true;
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
                              height: _keyboardIsVisible
                                  ? MediaQuery.of(context).size.height * 0.05
                                  : MediaQuery.of(context).size.height * 0.15),
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
