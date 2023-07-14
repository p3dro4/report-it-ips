import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/home/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.reports});

  final Map<String, Report> reports;

  static const CameraPosition ipsCameraPosition = CameraPosition(
    target: LatLng(38.5219554772082, -8.839772343635559),
    zoom: 16.75,
  );

  static AppBar appBar(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      title: Text(L.of(context)!.map,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500)),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.hybrid;
  ReportType? _currentFilter;
  String? _searchText;
  String? _mapStyle;
  late Map<String, Report> _reports;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(_mapStyle!);
  }

  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Future<void> _requestPermission() async {
    await Permission.location.request();
  }

  Future<void> _initMarkers() async {
    _markers.clear();
    _reports.forEach((key, value) {
      final color = value.resolved
          ? BitmapDescriptor.hueGreen
          : switch (value.type) {
              ReportType.priority => BitmapDescriptor.hueRed,
              ReportType.warning => BitmapDescriptor.hueYellow,
              _ => BitmapDescriptor.hueAzure
            };
      _markers.add(
        Marker(
          markerId: MarkerId(key),
          position: value.location!,
          icon: BitmapDescriptor.defaultMarkerWithHue(color),
          infoWindow: InfoWindow(
            title: value.title,
            snippet: value.description,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsReportPage(
                            report: value,
                          )));
            },
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _requestPermission();
    rootBundle.loadString('assets/map_styles/map_style.json').then((string) {
      _mapStyle = string;
    });
    _reports = widget.reports;
    _initMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: _currentMapType,
          initialCameraPosition: MapPage.ipsCameraPosition,
          onMapCreated: _onMapCreated,
          markers: _markers
              .where((element) =>
                  _currentFilter == null ||
                  (_reports[element.markerId.value]!.type == _currentFilter &&
                      !_reports[element.markerId.value]!.resolved))
              .where((element) =>
                  _searchText == null ||
                  element.infoWindow.title!
                      .toLowerCase()
                      .contains(_searchText!.toLowerCase()))
              .toSet(),
        ),
        Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
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
                      padding: EdgeInsets.all(5), child: Icon(Icons.more_vert))
                ],
              )),
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 10),
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              CustomFilterButton(
                onPressed: () {
                  setState(() {
                    _currentFilter = null;
                  });
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
          ),
        ]),
        Container(
          margin: const EdgeInsets.only(top: 125, right: 10),
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            heroTag: "map_type",
            onPressed: _changeMapType,
            elevation: 5,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            mini: true,
            child: const Icon(Icons.layers),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            heroTag: "center_map",
            onPressed: () {
              mapController.animateCamera(
                  CameraUpdate.newCameraPosition(MapPage.ipsCameraPosition));
            },
            elevation: 5,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.school_rounded,
              size: 30,
            ),
          ),
        )
      ],
    );
  }
}
