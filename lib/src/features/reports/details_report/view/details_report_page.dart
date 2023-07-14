import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsReportPage extends StatefulWidget {
  const DetailsReportPage({super.key, required this.report});

  final Report report;

  @override
  State<DetailsReportPage> createState() => _DetailsReportPageState();
}

class _DetailsReportPageState extends State<DetailsReportPage> {
  bool _submitting = false;
  late Report report;
  @override
  void initState() {
    report = widget.report;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        const Opacity(
            opacity: 0.5, child: BackgroundImage(top: true, bottom: true)),
        _submitting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                    bottom: MediaQuery.of(context).size.height * 0.14),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AutoSizeText(report.title ?? "",
                                style: Theme.of(context).textTheme.displayLarge,
                                maxLines: 1),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 30,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(children: [
                                        for (ReportTag tag in report.tags ?? [])
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(tag.color)),
                                              child: AutoSizeText(
                                                tag.getNameWithContext(context),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                      ]),
                                      Row(children: [
                                        VerticalDivider(
                                            thickness: 2,
                                            indent: 5,
                                            endIndent: 5,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withOpacity(0.4)),
                                        Text(
                                          DateFormat('dd/MM/yyyy, hh:mm')
                                              .format(report.timestamp ??
                                                  DateTime.now()),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.4)),
                                        )
                                      ])
                                    ])),
                            Container(
                                margin: const EdgeInsets.only(top: 40),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                        report.bannerPhotoURL ?? "",
                                        fit: BoxFit.fill))),
                            
                            
                          ])),
                ),
              ),
        CustomBackButton(
          text: L.of(context)!.back,
          callback: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    )));
  }
}
