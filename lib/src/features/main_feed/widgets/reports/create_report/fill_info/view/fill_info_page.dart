import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FillInfoPage extends StatefulWidget {
  const FillInfoPage({super.key, required this.report});

  final Report? report;

  @override
  State<FillInfoPage> createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
  Report? report;
  bool _submitting = false;
  final _formKey = GlobalKey<FormState>();
  bool _omitBackground = false;

  String? _fieldTitle;
  String? _fieldDescription = "";
  @override
  void initState() {
    report = widget.report;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom > 0
        ? _omitBackground = true
        : _omitBackground = false;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          BackgroundImage(top: !_omitBackground, bottom: !_omitBackground),
          _submitting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: MediaQuery.of(context).viewInsets.bottom > 0
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                                        L.of(context)!.fill_in_report_details,
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
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  L.of(context)!.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium,
                                                )),
                                            const SizedBox(height: 10),
                                            CustomFormInputField(
                                              prefixIcon: Icons.title,
                                              labelText: L.of(context)!.title,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              errorColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return L
                                                      .of(context)!
                                                      .title_required;
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _fieldTitle = value;
                                              },
                                            ),
                                            const SizedBox(height: 30),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  L.of(context)!.description,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium,
                                                )),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              minLines: 3,
                                              maxLines: 3,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                setState(() {
                                                  _fieldDescription = value;
                                                });
                                              },
                                              validator: (value) {
                                                if ((value?.length ?? 0) > 90) {
                                                  return L
                                                      .of(context)!
                                                      .exceeded_max_characters;
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary)),
                                                labelText:
                                                    "${L.of(context)!.description} (${L.of(context)!.optional.toLowerCase()})",
                                                alignLabelWithHint: true,
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                counterText:
                                                    " ${_fieldDescription?.length ?? 0}/90",
                                                counterStyle: TextStyle(
                                                    color: (_fieldDescription
                                                                    ?.length ??
                                                                0) >
                                                            90
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .error
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                              ),
                                            ),
                                            const SizedBox(height: 40),
                                            CustomSubmitButton(
                                              text: L.of(context)!.next,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              textColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              callback: () {},
                                            ),
                                          ])),
                                  // * This SizedBox is used to push the form up when the keyboard is open
                                  SizedBox(
                                      height: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom >
                                              0
                                          ? MediaQuery.of(context)
                                              .viewInsets
                                              .bottom
                                          : MediaQuery.of(context).size.height *
                                              0.1),
                                ]))
                      ]),
                ),
          if (!_omitBackground)
            Padding(
                padding: const EdgeInsets.all(0),
                child: CustomBackButton(
                  color: Theme.of(context).colorScheme.primary,
                  text: L.of(context)!.back,
                  callback: () => Navigator.of(context).pop(),
                )),
          if (!_omitBackground)
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
