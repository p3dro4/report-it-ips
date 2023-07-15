import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/reports.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.reports});

  final Map<String, Report> reports;

  static AppBar appBar(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      title: Text(L.of(context)!.calendar,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Report>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  ReportType? _currentFilter;
  late String _searchText;
  late LinkedHashMap<DateTime, List<Report>> _reportsEvents;
  late Map<String, Report> _reports;

  @override
  void initState() {
    super.initState();
    _searchText = "";
    _selectedDay = _focusedDay;
    _reports = widget.reports;
    _reportsEvents = LinkedHashMap<DateTime, List<Report>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_organizeByDate());
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  Map<DateTime, List<Report>> _organizeByDate() {
    final Map<DateTime, List<Report>> reportsByDate = {};
    _reports.forEach((key, value) {
      DateTime dateTime = DateFormat("dd-MM-yyyy").parse(
          DateFormat("dd-MM-yyyy").format(value.timestamp ?? DateTime.now()));
      if (!reportsByDate.containsKey(dateTime)) {
        reportsByDate[dateTime] = [];
        reportsByDate[dateTime]!.add(value);
      } else {
        reportsByDate[dateTime]!.add(value);
      }
    });
    return reportsByDate;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Report> _getEventsForDay(DateTime day) {
    return _reportsEvents[day]?.where(
          (element) {
            if (_currentFilter == null) return true;
            return element.type == _currentFilter;
          },
        ).where(
          (element) {
            return element.title!
                .toLowerCase()
                .contains(_searchText.toLowerCase());
          },
        ).toList() ??
        [];
  }

  List<Report> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
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
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TableCalendar<Report>(
            firstDay: DateTime(2020),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: true,
            ),
            headerStyle: const HeaderStyle(
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, events) {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: day.weekday == DateTime.sunday
                          ? Colors.red
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                );
              },
              outsideBuilder: (context, day, events) {
                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: day.weekday == DateTime.sunday
                          ? Colors.red.withOpacity(0.5)
                          : Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                    ),
                  ),
                );
              },
              dowBuilder: (context, day) {
                final text = DateFormat.E(L.of(context)!.localeName.toString())
                    .format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                      color: day.weekday == DateTime.sunday
                          ? Colors.red
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                );
              },
              headerTitleBuilder: (context, day) {
                final text =
                    DateFormat.MMMM(L.of(context)!.localeName.toString())
                        .format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) {
                if (events.isEmpty) {
                  return Container();
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 35),
                    width: 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < events.length && i < 3; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: switch (events[i].type) {
                                ReportType.priority => Colors.red,
                                ReportType.warning => Colors.orange,
                                _ => Colors.blue,
                              },
                            ),
                            height: 2,
                          ),
                      ],
                    ),
                  );
                }
              },
              todayBuilder: (context, day, events) {
                return Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, events) {
                return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: !isSameDay(day, DateTime.now())
                        ? Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          ));
              },
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Report>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsReportPage(
                                id: _reports.keys.firstWhere((element) =>
                                    _reports[element] == value[index]),
                                report: value[index],
                              ),
                            ),
                          );
                        },
                        title: Text('${value[index].title}'),
                        subtitle: SizedBox(
                            height: 30,
                            child: Row(children: [
                              for (ReportTag tag in value[index].tags!)
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color(tag.color),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    tag.shortName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const VerticalDivider(
                                color: Colors.black,
                                thickness: 2,
                                width: 20,
                                indent: 5,
                                endIndent: 5,
                              ),
                              Text(
                                DateFormat("Hm").format(
                                    value[index].timestamp ?? DateTime.now()),
                              ),
                            ])),
                        leading: switch (value[index].type) {
                          ReportType.priority => const Icon(
                              Icons.priority_high,
                              size: 40,
                            ),
                          ReportType.warning => const Icon(
                              Icons.warning,
                              size: 40,
                            ),
                          _ => const Icon(
                              Icons.info,
                              size: 40,
                            ),
                        }),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
