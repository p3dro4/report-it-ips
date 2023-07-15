import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/home/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/reports.dart';
import 'package:report_it_ips/src/utils/background_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.reports, required this.onRefresh});

  final Map<String, Report> reports;
  final Future<Map<String, Report>> Function() onRefresh;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _processing = false;
  int _currentHighlight = 0;
  ReportType? _currentFilter;
  String _searchText = "";
  late Future<Map<String, Report>> Function() _onRefresh;
  late List<HighlightsBanner> _highlights;
  late Map<String, Report> _reports;
  late Map<DateTime, Map<String, Report>> _reportsByDate;

  Future<void> _initBanner() async {
    _highlights = [];
    await FirebaseFirestore.instance
        .collection("highlights")
        .get()
        .then((value) => {
              for (var doc in value.docs)
                {
                  if (doc.data()["active"] as bool)
                    {
                      setState(() {
                        _highlights
                            .add(HighlightsBanner.fromSnapshot(doc.data()));
                      })
                    }
                }
            });
  }

  void _organizeByDate() {
    _reportsByDate = {};
    _reports.forEach((key, value) {
      DateTime dateTime = DateFormat("dd-MM-yyyy").parse(
          DateFormat("dd-MM-yyyy").format(value.timestamp ?? DateTime.now()));
      if (_reportsByDate.containsKey(dateTime)) {
        _reportsByDate[dateTime]!.addAll({key: value});
      } else {
        _reportsByDate.addAll({
          dateTime: {key: value}
        });
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _processing = true;
    });
    await _initBanner();
    await _onRefresh().then((value) {
      _reports = value;
      _organizeByDate();
      _currentFilter = null;
    }).then((value) => {
          setState(() {
            _processing = false;
          })
        });
  }

  @override
  void initState() {
    setState(() {
      _processing = true;
    });
    _initBanner();
    _reports = widget.reports;
    _onRefresh = widget.onRefresh;
    _organizeByDate();
    setState(() {
      _processing = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(
          top: true,
          bottom: true,
          opacity: 0.5,
        ),
        _processing
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CustomSearch(
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      onFilterChanged: (value) {
                        setState(() {
                          _currentFilter = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        constraints: BoxConstraints.expand(
                            height: MediaQuery.of(context).size.height * 0.70),
                        child: RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            onRefresh: _refresh,
                            child: ListView.builder(
                              itemCount: _reportsByDate.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      if (_highlights.isNotEmpty)
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.20,
                                          child: GestureDetector(
                                            child: _highlights.isNotEmpty
                                                ? Column(children: [
                                                    _highlights[
                                                        _currentHighlight],
                                                    if (_highlights.length > 1)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: _highlights
                                                            .map(
                                                                (e) =>
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      width: 50,
                                                                      height: 5,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: _highlights.indexOf(e) ==
                                                                                _currentHighlight
                                                                            ? Colors.grey
                                                                            : Colors.grey.shade400,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                      )
                                                  ])
                                                : null,
                                            onHorizontalDragStart: (details) {
                                              details.globalPosition.dx > 0
                                                  ? _currentHighlight == 0
                                                      ? setState(() {
                                                          _currentHighlight =
                                                              _highlights
                                                                      .length -
                                                                  1;
                                                        })
                                                      : setState(() {
                                                          _currentHighlight--;
                                                        })
                                                  : _currentHighlight ==
                                                          _highlights.length - 1
                                                      ? setState(() {
                                                          _currentHighlight = 0;
                                                        })
                                                      : setState(() {
                                                          _currentHighlight++;
                                                        });
                                            },
                                          ),
                                        ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            L.of(context)!.recent_reports,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ],
                                  );
                                }
                                List<ListReportItem> shownReports =
                                    _reportsByDate.values
                                        .toList()[index - 1]
                                        .entries
                                        .map((e) => ListReportItem(
                                              key: UniqueKey(),
                                              id: e.key,
                                              report: e.value,
                                              onTap: () async {
                                                await Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return DetailsReportPage(
                                                      id: e.key,
                                                      report: e.value,
                                                    );
                                                  },
                                                )).then((value) => {
                                                      _refresh(),
                                                    });
                                              },
                                            ))
                                        .where((element) {
                                  if (_currentFilter != null) {
                                    return element.report.type ==
                                            _currentFilter &&
                                        !element.report.resolved;
                                  } else {
                                    return true;
                                  }
                                }).where((element) {
                                  if (_searchText.isNotEmpty) {
                                    return element.report.title!
                                        .toLowerCase()
                                        .contains(_searchText.toLowerCase());
                                  } else {
                                    return true;
                                  }
                                }).toList();
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    if (shownReports.isNotEmpty)
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            DateFormat("MMM dd").format(
                                                _reportsByDate.keys
                                                    .toList()[index - 1]),
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    Column(
                                      children: shownReports,
                                    )
                                  ],
                                );
                              },
                            ))),
                  ),
                ],
              )
      ],
    );
  }
}
