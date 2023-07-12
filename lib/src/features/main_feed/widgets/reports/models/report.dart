import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:report_it_ips/src/features/main_feed/widgets/reports/models/models.dart';

class Report {
  Report({
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
  });

  String? title;
  ReportType? type;
  String? description;
  String? bannerPhotoURL;
  DateTime? timestamp;
  List<String>? tags;
  LatLng? location;
  bool resolved = false;
  int? upvotes;
  List<String>? upvoters = [];
  List<String>? downvoters = [];

  factory Report.fromSnapshot(Object? snapshot) {
    final report = snapshot as Map<Object?, Object?>;
    return Report(
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
      upvoters: report["upvoters"] as List<String>?,
      downvoters: report["downvoters"] as List<String>?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "description": description,
        "tags": tags,
        "location": location,
        "type": type?.name,
        "upvotes": upvotes,
        "timestamp": timestamp,
        "bannerPhotoURL": bannerPhotoURL,
        "upvoters": upvoters,
        "downvoters": downvoters,
      };

  @override
  String toString() {
    return "### Report ###\nTitle: $title\nDescription: $description\nTags: $tags\nLocation: $location\nType: $type\nUpvotes: $upvotes\nTimestamp: $timestamp\nBannerPhotoURL: $bannerPhotoURL\nUpvoters: $upvoters\nDownvoters: $downvoters\nResolved: $resolved\n";
  }
}
