import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/register/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InstitutionalInformationPage extends StatefulWidget {
  const InstitutionalInformationPage({super.key, required this.user});
  final AppUser user;

  @override
  State<InstitutionalInformationPage> createState() =>
      _InstitutionalInformationPageState();
}

class _InstitutionalInformationPageState
    extends State<InstitutionalInformationPage> {
  bool _submitting = false;
  bool _keyboardIsVisible = false;
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom == 0
        ? _keyboardIsVisible = false
        : _keyboardIsVisible = true;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(children: [
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
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: []))),
          if (!_keyboardIsVisible)
            CustomBackButton(
              text: L.of(context)!.back,
              callback: () => Navigator.of(context).pop(),
              color: Theme.of(context).colorScheme.primary,
            ),
        ])));
  }
}
