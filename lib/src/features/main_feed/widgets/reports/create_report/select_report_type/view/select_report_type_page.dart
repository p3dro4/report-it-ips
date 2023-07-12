import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/create_report/fill_info/view/fill_info_page.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/models/models.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/reports.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectReportTypePage extends StatefulWidget {
  const SelectReportTypePage({super.key});

  @override
  State<SelectReportTypePage> createState() => _SelectReportTypePageState();
}

class _SelectReportTypePageState extends State<SelectReportTypePage> {
  bool _submitting = false;
  ReportType? _reportType;
  late Report _report;

  @override
  void initState() {
    _report = Report();
    super.initState();
  }

  Future<void> _continueToNextPage() async {
    setState(() {
      _submitting = true;
    });
    _report.type = _reportType!;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FillInfoPage(
                  report: _report,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        const BackgroundImage(top: true, bottom: true),
        Padding(
            padding: const EdgeInsets.all(30),
            child: CustomBackButton(
              color: Theme.of(context).colorScheme.onPrimary,
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
        _submitting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      Text(
                        L.of(context)!.create_report,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        L.of(context)!.select_report_type,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Center(
                        child: Column(children: [
                          CustomLargeButton(
                            callback: () => {
                              setState(() {
                                _reportType = ReportType.info;
                              })
                            },
                            isSelected: _reportType == ReportType.info,
                            icon: Icons.info,
                            text: L.of(context)!.info,
                          ),
                          const SizedBox(height: 25),
                          CustomLargeButton(
                              callback: () => {
                                    setState(() {
                                      _reportType = ReportType.warning;
                                    })
                                  },
                              isSelected: _reportType == ReportType.warning,
                              icon: Icons.warning,
                              text: L.of(context)!.warning),
                          const SizedBox(height: 25),
                          CustomLargeButton(
                              callback: () => {
                                    setState(() {
                                      _reportType = ReportType.priority;
                                    })
                                  },
                              isSelected: _reportType == ReportType.priority,
                              icon: Icons.priority_high,
                              text: L.of(context)!.priority),
                          const SizedBox(height: 50),
                          CustomSubmitButton(
                            enabled: _reportType != null,
                            color: Theme.of(context).colorScheme.primary,
                            text: L.of(context)!.next,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            callback: _reportType != null
                                ? () => _continueToNextPage().then((value) {
                                      setState(() {
                                        _submitting = false;
                                      });
                                    })
                                : null,
                          )
                        ]),
                      )
                    ]),
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
