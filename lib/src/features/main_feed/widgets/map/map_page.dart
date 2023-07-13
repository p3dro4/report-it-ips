import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/home/widgets/widgets.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/reports.dart';

//TODO: Implement MapPage
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static const CameraPosition _ipsCameraPosition = CameraPosition(
    target: LatLng(38.52214493318472, -8.83882342859453),
    zoom: 16,
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
  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(38.521792, -8.839307),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    )
  };

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

  @override
  void initState() {
    _requestPermission();
    rootBundle.loadString('assets/map_styles/map_style.json').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: _currentMapType,
          initialCameraPosition: MapPage._ipsCameraPosition,
          onMapCreated: _onMapCreated,
          markers: _markers,
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
            onPressed: () {
              mapController.animateCamera(
                  CameraUpdate.newCameraPosition(MapPage._ipsCameraPosition));
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
