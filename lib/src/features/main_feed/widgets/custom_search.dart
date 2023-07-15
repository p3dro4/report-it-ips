import 'package:flutter/material.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'custom_filter_button.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({super.key, this.onChanged, this.onFilterChanged});

  final void Function(String)? onChanged;
  final void Function(ReportType?)? onFilterChanged;

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  ReportType? _currentFilter;
  late Function(String) _onChanged;
  late Function(ReportType?) _onFilterChanged;

  @override
  void initState() {
    _onChanged = widget.onChanged!;
    _onFilterChanged = widget.onFilterChanged!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.07,
          child: SearchBar(
            onChanged: (value) {
              if (widget.onChanged != null) _onChanged(value);
            },
            leading: const Icon(Icons.search),
            hintText: L.of(context)!.search,
            side: MaterialStatePropertyAll<BorderSide>(BorderSide(
                width: 2,
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white)),
            trailing: const [
              Padding(padding: EdgeInsets.all(5), child: Icon(Icons.more_vert))
            ],
          )),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              CustomFilterButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = null;
                  });
                  _onFilterChanged(null);
                },
                text: L.of(context)!.all,
                color: _currentFilter == null
                    ? Colors.white
                    : Colors.grey.shade400,
                textColor: _currentFilter == null
                    ? Colors.black
                    : Colors.grey.shade700,
              ),
              const SizedBox(width: 10),
              CustomFilterButton(
                  onPressed: () {
                    setState(() {
                      _currentFilter = ReportType.priority;
                    });
                    _onFilterChanged(ReportType.priority);
                  },
                  text: L.of(context)!.priority,
                  color: _currentFilter == ReportType.priority
                      ? Colors.white
                      : Colors.grey.shade400,
                  textColor: _currentFilter == ReportType.priority
                      ? Colors.black
                      : Colors.grey.shade700),
              const SizedBox(width: 10),
              CustomFilterButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = ReportType.warning;
                  });
                  _onFilterChanged(ReportType.warning);
                },
                text: L.of(context)!.warning,
                color: _currentFilter == ReportType.warning
                    ? Colors.white
                    : Colors.grey.shade400,
                textColor: _currentFilter == ReportType.warning
                    ? Colors.black
                    : Colors.grey.shade700,
              ),
              const SizedBox(width: 10),
              CustomFilterButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = ReportType.info;
                  });
                  _onFilterChanged(ReportType.info);
                },
                text: L.of(context)!.info,
                color: _currentFilter == ReportType.info
                    ? Colors.white
                    : Colors.grey.shade400,
                textColor: _currentFilter == ReportType.info
                    ? Colors.black
                    : Colors.grey.shade700,
              ),
            ]),
          ))
    ]);
  }
}
