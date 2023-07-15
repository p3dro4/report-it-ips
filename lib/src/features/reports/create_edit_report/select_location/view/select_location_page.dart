import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key, this.id, required this.report});

  final String? id;
  final Report report;

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  bool _submitting = false;
  late GoogleMapController _mapController;
  String? _mapStyle;
  MapType _currentMapType = MapType.hybrid;
  late LatLng _location;
  final List<LatLng> _points = [
    const LatLng(38.52387552982901, -8.843389254748917),
    const LatLng(38.523566847951344, -8.838540474172977),
    const LatLng(38.519470592638086, -8.834806839096391),
    const LatLng(38.5174876475026, -8.83881877041237),
  ];
  final Set<Polygon> _polygon = <Polygon>{};
  bool _showLocationOutside = false;
  late Report _report;

  @override
  void initState() {
    _requestPermission();
    rootBundle.loadString('assets/map_styles/map_style.json').then((string) {
      _mapStyle = string;
    });
    _polygon.add(Polygon(
      polygonId: const PolygonId('1'),
      points: _points,
      geodesic: true,
      fillColor: Colors.transparent,
      strokeColor: Colors.transparent,
    ));
    _location = MapPage.ipsCameraPosition.target;
    _report = widget.report;
    if (widget.id != null) {
      _location = widget.report.location ?? MapPage.ipsCameraPosition.target;
    }
    super.initState();
  }

  Future<void> _continueToNextPage() async {
    setState(() {
      _submitting = true;
    });
    _report.location = _location;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectPhotosPage(
                  id: widget.id,
                  report: _report,
                )));
  }

  bool _checkIfWithinBounds() {
    return mt.PolygonUtil.containsLocation(
        mt.LatLng(_location.latitude, _location.longitude),
        List<mt.LatLng>.from(
            _points.map((e) => mt.LatLng(e.latitude, e.longitude))),
        true);
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(_mapStyle!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          const BackgroundImage(top: true, bottom: true),
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
                                        L.of(context)!.fill_in_report_location,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )),
                                ])),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5))
                              ]),
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(9),
                                topRight: Radius.circular(9),
                                bottomLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                              ),
                              child: Stack(children: [
                                GoogleMap(
                                  mapType: _currentMapType,
                                  initialCameraPosition: CameraPosition(
                                      target: _location, zoom: 16),
                                  onMapCreated: _onMapCreated,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  onCameraMove: (position) => {
                                    setState(
                                      () => _location = position.target,
                                    )
                                  },
                                  polygons: _polygon,
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId("Report Location"),
                                      position: _location,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                              BitmapDescriptor.hueRed),
                                    )
                                  },
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: FloatingActionButton(
                                        heroTag: "center_camera",
                                        onPressed: () => {
                                          _mapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  MapPage.ipsCameraPosition))
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: const CircleBorder(),
                                        child: Icon(
                                          Icons.school,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    )),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 70, right: 7),
                                  alignment: Alignment.topRight,
                                  child: FloatingActionButton(
                                    heroTag: "change_map_type",
                                    onPressed: _changeMapType,
                                    elevation: 5,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.75),
                                    shape: const CircleBorder(),
                                    mini: true,
                                    child: Icon(Icons.layers,
                                        color: Colors.grey.shade600),
                                  ),
                                ),
                              ])),
                        ),
                        if (_showLocationOutside)
                          Text(
                            L.of(context)!.location_outside_campus,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: CustomSubmitButton(
                              color: Theme.of(context).colorScheme.primary,
                              text: L.of(context)!.next,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              callback: () async {
                                setState(() {
                                  setState(() {
                                    _showLocationOutside =
                                        !_checkIfWithinBounds();
                                  });
                                  if (!_showLocationOutside) {
                                    setState(() {
                                      _submitting = true;
                                    });
                                    _continueToNextPage().then((value) => {
                                          setState(() {
                                            _submitting = false;
                                          })
                                        });
                                  }
                                });
                              }),
                        )
                      ])),
          Padding(
              padding: const EdgeInsets.all(0),
              child: CustomBackButton(
                color: Theme.of(context).colorScheme.primary,
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
        ])));
  }
}
