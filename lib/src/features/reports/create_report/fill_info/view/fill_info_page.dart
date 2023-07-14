import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/create_report/create_report.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FillInfoPage extends StatefulWidget {
  const FillInfoPage({super.key, required this.report});

  final Report report;

  @override
  State<FillInfoPage> createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
  late Report report;
  bool _submitting = false;
  final _formKey = GlobalKey<FormState>();
  bool _omitBackground = false;
  bool _showTagsOverlay = false;

  String? _fieldTitle;
  String? _fieldDescription = "";
  final Set<ReportTag> _tags = {};

  @override
  void initState() {
    report = widget.report;
    super.initState();
  }

  Future<void> _continueToNextPage() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _submitting = true;
      });
      report.title = _fieldTitle!;
      report.description = _fieldDescription!;
      report.tags = _tags.toList();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectLocationPage(
                    report: report,
                  )));
    }
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
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              textInputAction:
                                                  TextInputAction.done,
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
                                              onChanged: (value) {
                                                setState(() {
                                                  _fieldTitle = value;
                                                });
                                              },
                                              counterText:
                                                  "${_fieldTitle?.length ?? 0}/40",
                                              counterStyle: TextStyle(
                                                  color: (_fieldTitle?.length ??
                                                              0) >
                                                          40
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .error
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  L.of(context)!.tags,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium,
                                                )),
                                            Row(
                                              children: [
                                                for (var tag in _tags)
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 5),
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                tag.color),
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Text(
                                                            tag.getNameWithContext(
                                                                context),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ))),
                                                if (_tags.isNotEmpty)
                                                  IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        setState(() {
                                                          _tags.remove(
                                                              _tags.last);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                        weight: 1000,
                                                      )),
                                                if (_tags.length < 3)
                                                  IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        setState(() {
                                                          _showTagsOverlay =
                                                              true;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        weight: 1000,
                                                      )),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
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
                                            const SizedBox(height: 30),
                                            CustomSubmitButton(
                                              text: L.of(context)!.next,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              textColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              callback: () {
                                                _continueToNextPage().then(
                                                    (value) => setState(() {
                                                          _submitting = false;
                                                        }));
                                              },
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
          if (_showTagsOverlay)
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.27),
                child: TapRegion(
                    onTapOutside: (value) => setState(() {
                          _showTagsOverlay = false;
                        }),
                    child: SelectTag(
                        onTap: (value) => {
                              _tags.add(value),
                              setState(() {
                                _showTagsOverlay = false;
                              }),
                            }))),
        ])));
  }
}
