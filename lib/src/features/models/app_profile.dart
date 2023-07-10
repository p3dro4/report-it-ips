import 'package:report_it_ips/src/features/models/models.dart';
import 'package:report_it_ips/src/utils/utils.dart';

class AppProfile {
  AppProfile(
      {
      this.displayName,
      this.photoURL,
      this.bio,
      this.nPoints,
      this.nReports,
      this.leagueType});

  String? displayName;
  String? photoURL;
  String? bio;
  int? nPoints;
  int? nReports;
  LeagueType? leagueType;

  factory AppProfile.fromSnapshot(Map<String, dynamic> snapshot) {
    return AppProfile(
      displayName: snapshot[ProfileFields.displayName.name] as String?,
      photoURL: snapshot[ProfileFields.photoURL.name] as String?,
      bio: snapshot[ProfileFields.bio.name] as String? ?? '',
      nPoints: snapshot[ProfileFields.nPoints.name] as int? ?? 0,
      nReports: snapshot[ProfileFields.nReports.name] as int? ?? 0,
      leagueType: snapshot[ProfileFields.leagueType.name] != null
          ? LeagueType.values.firstWhere(
              (e) => e.name == snapshot[ProfileFields.leagueType.name])
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (displayName != null) ProfileFields.displayName.name: displayName,
        if (photoURL != null) ProfileFields.photoURL.name: photoURL,
        if (bio != null) ProfileFields.bio.name: bio,
        if (nPoints != null) ProfileFields.nPoints.name: nPoints,
        if (nReports != null) ProfileFields.nReports.name: nReports,
        if (leagueType != null) ProfileFields.leagueType.name: leagueType?.name,
      };

  @override
  String toString() {
    return "### Profile ###\nDisplayName: $displayName\nPhotoURL: $photoURL\nBio: $bio\nPoints: $nPoints\nReports: $nReports\nLeagueType: $leagueType\n";
  }
}
