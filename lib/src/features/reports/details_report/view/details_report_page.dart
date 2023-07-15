import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/features/reports/details_report/widgets/widgets.dart';
import 'package:report_it_ips/src/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsReportPage extends StatefulWidget {
  const DetailsReportPage({super.key, required this.id, required this.report});
  final String id;

  final Report report;

  @override
  State<DetailsReportPage> createState() => _DetailsReportPageState();
}

class _DetailsReportPageState extends State<DetailsReportPage> {
  late Report report;
  late String id;
  bool upvoted = false;
  bool downvoted = false;
  int upvotes = 0;

  bool _showConfimrPrompt = false;

  @override
  void initState() {
    report = widget.report;
    id = widget.id;
    report.upvoters?.forEach((element) {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        upvoted = true;
      }
    });
    report.downvoters?.forEach((element) {
      if (element == FirebaseAuth.instance.currentUser!.uid) {
        downvoted = true;
      }
    });
    upvotes = report.upvotes ?? 0;
    super.initState();
  }

  Future<void> _updateOnFirebase() async {
    final doc = await FirebaseFirestore.instance
        .collection("reports")
        .doc(widget.id)
        .get();
    int upvotes = doc.data()!["upvotes"] as int? ?? 0;
    List<String> upvoters = List<String>.from(doc.data()!["upvoters"] ?? []);
    List<String> downvoters =
        List<String>.from(doc.data()!["downvoters"] ?? []);

    if (upvoted) {
      upvoters.add(FirebaseAuth.instance.currentUser!.uid);
    } else {
      upvoters.remove(FirebaseAuth.instance.currentUser!.uid);
    }

    if (downvoted) {
      downvoters.add(FirebaseAuth.instance.currentUser!.uid);
    } else {
      downvoters.remove(FirebaseAuth.instance.currentUser!.uid);
    }
    upvotes = upvoters.length - downvoters.length;
    await FirebaseFirestore.instance.collection("reports").doc(widget.id).set({
      "upvotes": upvotes,
      "upvoters": upvoters,
      "downvoters": downvoters,
    }, SetOptions(merge: true));
  }

  void _updateUpvotes() {
    setState(() {
      report.upvotes = upvotes;
    });
  }

  void _upvote() {
    if (downvoted) {
      setState(() {
        downvoted = false;
        upvotes++;
      });
      report.downvoters?.remove(FirebaseAuth.instance.currentUser!.uid);
    }
    if (upvoted) {
      setState(() {
        upvoted = false;
        upvotes--;
      });
      report.upvoters?.remove(FirebaseAuth.instance.currentUser!.uid);
    } else {
      setState(() {
        upvoted = true;
        upvotes++;
      });
      report.upvoters?.add(FirebaseAuth.instance.currentUser!.uid);
    }
    _updateUpvotes();
  }

  void _downvote() {
    if (upvoted) {
      setState(() {
        upvoted = false;
        upvotes--;
      });
      report.upvoters?.remove(FirebaseAuth.instance.currentUser!.uid);
    }
    if (downvoted) {
      setState(() {
        downvoted = false;
        upvotes++;
      });
      report.downvoters?.remove(FirebaseAuth.instance.currentUser!.uid);
    } else {
      setState(() {
        downvoted = true;
        upvotes--;
      });
      report.downvoters?.add(FirebaseAuth.instance.currentUser!.uid);
    }
    _updateUpvotes();
  }

  Future<void> _updateResolvedStatus() async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(id)
        .set({"resolved": report.resolved}, SetOptions(merge: true));
  }

  Future<void> _deleteReport() async {
    await FirebaseFirestore.instance
        .collection("reports")
        .doc(id)
        .delete()
        .then((value) {
      showSnackbar(
        context: context,
        message: L.of(context)!.report_deleted_successfully,
        backgroundColor: Colors.green,
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        const Opacity(
            opacity: 0.5, child: BackgroundImage(top: true, bottom: false)),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.15,
            bottom: MediaQuery.of(context).size.height * 0.05,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(children: [
                                  for (ReportTag tag in report.tags ?? [])
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
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
                                              fontWeight: FontWeight.w400),
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
                                    DateFormat('dd/MM/yyyy, hh:mm').format(
                                        report.timestamp ?? DateTime.now()),
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
                      if (report.resolved)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green),
                              const SizedBox(width: 5),
                              Text(
                                L.of(context)!.resolved,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      Container(
                          margin: EdgeInsets.only(
                              top: report.resolved ? 20 : 40, bottom: 40),
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(report.bannerPhotoURL ?? "",
                                  fit: BoxFit.fill))),
                      if (report.description != null &&
                          report.description!.isNotEmpty)
                        Column(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                L.of(context)!.description,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                          const SizedBox(height: 10),
                          Text(
                            report.description ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                          const SizedBox(height: 20),
                        ]),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            L.of(context)!.location,
                            style: Theme.of(context).textTheme.displayMedium,
                          )),
                      const SizedBox(height: 10),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withAlpha(150),
                                strokeAlign: BorderSide.strokeAlignCenter,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      0, 4), // changes position of shadow
                                ),
                              ]),
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(9),
                                topRight: Radius.circular(9),
                                bottomLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                              ),
                              child: GoogleMap(
                                scrollGesturesEnabled: false,
                                zoomGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                mapType: MapType.hybrid,
                                initialCameraPosition: report.location != null
                                    ? CameraPosition(
                                        target: LatLng(
                                            report.location!.latitude,
                                            report.location!.longitude),
                                        zoom: 16.75,
                                      )
                                    : MapPage.ipsCameraPosition,
                                markers: report.location != null
                                    ? {
                                        Marker(
                                          markerId:
                                              const MarkerId("report_location"),
                                          position: LatLng(
                                              report.location!.latitude,
                                              report.location!.longitude),
                                        )
                                      }
                                    : {},
                              ))),
                      const SizedBox(height: 40),
                      if (report.addicionalPhotosURL != null &&
                          report.addicionalPhotosURL!.isNotEmpty)
                        Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  L.of(context)!.additional_photos,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                )),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 30,
                                  crossAxisSpacing: 15,
                                  children: report.addicionalPhotosURL
                                          ?.map((e) => ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(e,
                                                    fit: BoxFit.fill),
                                              ))
                                          .toList() ??
                                      [],
                                ))
                          ],
                        ),
                    ])),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9),
                  )),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 8),
                      icon: Transform.rotate(
                          angle: -90 * pi / 180,
                          child: Icon(upvoted
                              ? Icons.forward
                              : Icons.forward_outlined)),
                      alignment: Alignment.center,
                      color: upvoted ? Colors.black : Colors.grey.shade700,
                      iconSize: 40,
                      onPressed: () async => {
                        _upvote(),
                        await _updateOnFirebase(),
                      },
                    ),
                    SizedBox(
                        width: 50,
                        child: Text("$upvotes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))),
                    IconButton(
                        padding: const EdgeInsets.only(left: 8),
                        icon: Transform.rotate(
                            angle: 90 * pi / 180,
                            child: Icon(downvoted
                                ? Icons.forward
                                : Icons.forward_outlined)),
                        alignment: Alignment.center,
                        iconSize: 40,
                        color: downvoted ? Colors.black : Colors.grey.shade700,
                        onPressed: () async => {
                              _downvote(),
                              await _updateOnFirebase(),
                            }),
                  ])),
        ),
        CustomBackButton(
          text: L.of(context)!.back,
          callback: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.primary,
        ),
        if (report.uid == FirebaseAuth.instance.currentUser!.uid)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "resolved",
                        onTap: () {
                          setState(() {
                            report.resolved = !report.resolved;
                          });
                          _updateResolvedStatus();
                        },
                        child: Row(children: [
                          Icon(
                            report.resolved
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            report.resolved
                                ? L.of(context)!.unmark_as_resolved
                                : L.of(context)!.mark_as_resolved,
                            style: const TextStyle(color: Colors.black),
                          )
                        ]),
                      ),
                      PopupMenuItem(
                          value: "delete",
                          onTap: () {
                            setState(() {
                              _showConfimrPrompt = true;
                            });
                          },
                          child: Row(children: [
                            const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              L.of(context)!.delete_report,
                              style: const TextStyle(color: Colors.red),
                            )
                          ])),
                    ];
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  )),
            ),
          ),
        if (_showConfimrPrompt)
          ConfirmDeletePrompt(
            onCancel: () {
              setState(() {
                _showConfimrPrompt = false;
              });
            },
            onConfirm: () {
              _deleteReport();
            },
          )
      ],
    )));
  }
}
