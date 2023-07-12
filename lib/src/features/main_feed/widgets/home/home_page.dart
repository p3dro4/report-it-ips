import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/home/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/reports.dart';
import 'package:report_it_ips/src/utils/background_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO: Implement HomePage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _processing = false;
  int _currentFilterIndex = 0;
  int _currentHighlight = 0;
  late List<HighlightsBanner> _highlights;
  late List<Report> _reports;

  Future<void> _initBanner() async {
    setState(() {
      _processing = true;
    });
    _highlights = [];
    await FirebaseFirestore.instance
        .collection("highlights")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                if (element.data()["active"] as bool) {
                  setState(() {
                    _highlights
                        .add(HighlightsBanner.fromSnapshot(element.data()));
                  });
                }
              })
            });
    setState(() {
      _processing = false;
    });
  }

  Future<void> _loadReports() async {
    setState(() {
      _processing = true;
    });
    _reports = [];
    await FirebaseFirestore.instance
        .collection("reports")
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                setState(() {
                  _reports.add(Report.fromSnapshot(element.data()));
                });
              })
            });
    setState(() {
      _processing = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentFilterIndex = 0;
    });
    await _initBanner();
    await _loadReports();
  }

  @override
  void initState() {
    _initBanner();
    _loadReports();
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
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    SearchBar(
                      leading: const Icon(Icons.search),
                      hintText: L.of(context)!.search,
                      side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                          width: 2,
                          color: Theme.of(context).colorScheme.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white)),
                      trailing: const [
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.more_vert))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        CustomFilterButton(
                          onPressed: () {
                            setState(() {
                              _currentFilterIndex = 0;
                            });
                          },
                          text: L.of(context)!.all,
                          color: _currentFilterIndex == 0
                              ? Colors.white
                              : Colors.grey.shade400,
                          textColor: _currentFilterIndex == 0
                              ? Colors.black
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 10),
                        CustomFilterButton(
                            onPressed: () {
                              setState(() {
                                _currentFilterIndex = 1;
                              });
                            },
                            text: L.of(context)!.priority,
                            color: _currentFilterIndex == 1
                                ? Colors.white
                                : Colors.grey.shade400,
                            textColor: _currentFilterIndex == 1
                                ? Colors.black
                                : Colors.grey.shade700),
                        const SizedBox(width: 10),
                        CustomFilterButton(
                          onPressed: () {
                            setState(() {
                              _currentFilterIndex = 2;
                            });
                          },
                          text: L.of(context)!.warning,
                          color: _currentFilterIndex == 2
                              ? Colors.white
                              : Colors.grey.shade400,
                          textColor: _currentFilterIndex == 2
                              ? Colors.black
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 10),
                        CustomFilterButton(
                          onPressed: () {
                            setState(() {
                              _currentFilterIndex = 3;
                            });
                          },
                          text: L.of(context)!.info,
                          color: _currentFilterIndex == 3
                              ? Colors.white
                              : Colors.grey.shade400,
                          textColor: _currentFilterIndex == 3
                              ? Colors.black
                              : Colors.grey.shade700,
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        constraints: BoxConstraints.expand(
                            height: MediaQuery.of(context).size.height * 0.70),
                        child: RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                              itemCount: _reports.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                          .map((e) => Container(
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                width: 50,
                                                                height: 5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _highlights.indexOf(
                                                                              e) ==
                                                                          _currentHighlight
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .grey
                                                                          .shade400,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
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
                                                            _highlights.length -
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
                                return ListReportItem(
                                    report: _reports[index - 1]);
                              },
                            ))),
                  ],
                ))
      ],
    );
  }
}
