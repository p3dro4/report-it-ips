import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/reports.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.reports, required this.onRefresh});

  final Map<String, Report> reports;
  final Future<Map<String, Report>> Function()? onRefresh;

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
            onTap: () async {
              await widget.onRefresh!()
                  .then((value) => _reports = value)
                  .then((report) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsReportPage(
                                id: key,
                                report: report[key]!,
                              ))));
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
        Container(
            margin: const EdgeInsets.only(top: 20),
            child: CustomSearch(onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            }, onFilterChanged: (value) {
              setState(() {
                _currentFilter = value;
              });
            })),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.17,
            right: 10,
          ),
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
