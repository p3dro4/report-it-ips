import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListReportItem extends StatefulWidget {
  const ListReportItem(
      {super.key, required this.report, this.color, this.onTap});

  final Color? color;
  final Function()? onTap;

  final Report report;

  @override
  State<ListReportItem> createState() => _ListReportItemState();
}

class _ListReportItemState extends State<ListReportItem> {
  bool upvoted = false;
  bool downvoted = false;
  late Report report;
  late int upvotes;
  

  @override
  void initState() {
    report = widget.report;
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      constraints: const BoxConstraints.expand(height: 160),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 2,
        ),
      ),
      //clipBehavior: Clip.antiAlias,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: InkWell(
                    onTap: widget.onTap,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  switch (report.type) {
                                    ReportType.info => Icons.info,
                                    ReportType.warning => Icons.warning,
                                    ReportType.priority => Icons.priority_high,
                                    _ => Icons.report
                                  },
                                  color: widget.color ?? Colors.grey.shade700,
                                  size: 60,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    DateFormat("Hm").format(
                                        report.timestamp ?? DateTime(2001)),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: widget.color ??
                                            Colors.grey.shade700,
                                        fontWeight: FontWeight.bold)),
                              ])),
                      VerticalDivider(
                        color: switch (report.type) {
                          ReportType.info => Colors.blue.shade700,
                          ReportType.warning => Colors.orange.shade700,
                          ReportType.priority => Colors.red.shade700,
                          _ => Colors.grey.shade700,
                        },
                        thickness: 5,
                        width: 5,
                      ),
                      Expanded(
                          child: Stack(fit: StackFit.expand, children: [
                        report.bannerPhotoURL?.isEmpty ?? true
                            ? Container()
                            : Opacity(
                                opacity: 0.2,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12)),
                                    child: Image.network(
                                      report.bannerPhotoURL!,
                                      fit: BoxFit.fill,
                                    ))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(report.title ?? "",
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))),
                        if (report.resolved)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(L.of(context)!.resolved,
                                        style: TextStyle(
                                            color: Colors.green.shade600,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      weight: 1000,
                                      size: 18,
                                      color: Colors.green.shade600,
                                    ),
                                  ],
                                )),
                          )
                      ]))
                    ]))),
            const Divider(
              color: Colors.black,
              thickness: 3,
              height: 2.5,
              endIndent: 0,
              indent: 0,
            ),
            Flexible(
                fit: FlexFit.tight,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.only(right: 8),
                          icon: Transform.rotate(
                              angle: -90 * pi / 180,
                              child: Icon(upvoted
                                  ? Icons.forward
                                  : Icons.forward_outlined)),
                          alignment: Alignment.center,
                          color: upvoted
                              ? Colors.black
                              : widget.color ?? Colors.grey.shade700,
                          iconSize: 30,
                          onPressed: _upvote,
                        ),
                        SizedBox(
                            width: 50,
                            child: Text("$upvotes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: widget.color ?? Colors.grey.shade700,
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
                          iconSize: 30,
                          color: downvoted
                              ? Colors.black
                              : widget.color ?? Colors.grey.shade700,
                          onPressed: _downvote,
                        ),
                      ],
                    )))
          ]),
    );
  }
}
