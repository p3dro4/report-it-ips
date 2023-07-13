import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/models/models.dart';

class Report {
  Report({
    this.uid,
    this.title,
    this.description,
    this.tags,
    this.location,
    this.type,
    this.upvotes,
    this.timestamp,
    this.bannerPhotoURL,
    this.upvoters,
    this.downvoters,
    this.resolved = false,
  });

  String? uid;
  String? title;
  ReportType? type;
  String? description;
  String? bannerPhotoURL;
  DateTime? timestamp;
  List<String>? tags;
  LatLng? location;
  bool resolved;
  int? upvotes;
  List<String>? upvoters = [];
  List<String>? downvoters = [];

  factory Report.fromSnapshot(Object? snapshot) {
    final report = snapshot as Map<Object?, Object?>;
    return Report(
      uid: report["uid"] as String?,
      title: report["title"] as String?,
      description: report["description"] as String?,
      tags: report["tags"] as List<String>?,
      location: report["location"] as LatLng?,
      type: report["type"] != null
          ? ReportType.values
              .firstWhere((e) => e.name == report["type"] as String)
          : null,
      upvotes: report["upvotes"] as int?,
      timestamp: (report["timestamp"] as Timestamp).toDate(),
      bannerPhotoURL: report["bannerPhotoURL"] as String?,
      upvoters: List<String>.from(report["upvoters"] as List<dynamic>? ?? []),
      downvoters:
          List<String>.from(report["downvoters"] as List<dynamic>? ?? []),
      resolved: report["resolved"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (uid != null) "uid": uid,
        if (title != null) "title": title,
        if (description != null) "description": description,
        if (tags != null) "tags": tags,
        if (location != null) "location": location,
        if (type != null) "type": type?.name,
        if (upvotes != null) "upvotes": upvotes,
        if (timestamp != null) "timestamp": timestamp,
        if (bannerPhotoURL != null) "bannerPhotoURL": bannerPhotoURL,
        if (upvoters != null) "upvoters": upvoters,
        if (downvoters != null) "downvoters": downvoters,
        "resolved": resolved,
      };

  @override
  String toString() {
    return "### Report ###\nTitle: $title\nDescription: $description\nTags: $tags\nLocation: $location\nType: $type\nUpvotes: $upvotes\nTimestamp: $timestamp\nBannerPhotoURL: $bannerPhotoURL\nUpvoters: $upvoters\nDownvoters: $downvoters\nResolved: $resolved\n";
  }
}
