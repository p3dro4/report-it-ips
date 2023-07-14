import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectPhotosPage extends StatefulWidget {
  const SelectPhotosPage({super.key, required this.report});

  final Report report;

  @override
  State<SelectPhotosPage> createState() => _SelectPhotosPageState();
}

class _SelectPhotosPageState extends State<SelectPhotosPage> {
  late Report report;
  bool _submitting = false;

  @override
  void initState() {
    report = widget.report;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          const BackgroundImage(top: true, bottom: true),
          _submitting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: MediaQuery.of(context).viewInsets.bottom > 0
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(
                                40,
                                MediaQuery.of(context).viewInsets.bottom > 0
                                    ? MediaQuery.of(context).size.height * 0.05
                                    : MediaQuery.of(context).size.height * 0.15,
                                40,
                                10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        L.of(context)!.create_report,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      )),
                                  const SizedBox(height: 10),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        L.of(context)!.select_images,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )),
                                ])),
                      ])),
          Padding(
              padding: const EdgeInsets.all(0),
              child: CustomBackButton(
                color: Theme.of(context).colorScheme.primary,
                text: L.of(context)!.back,
                callback: () => Navigator.of(context).pop(),
              )),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: CloseButton(
                      color: Colors.black,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      onPressed: () => {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          }))),
        ])));
  }
}
