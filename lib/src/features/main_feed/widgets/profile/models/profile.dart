import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:report_it_ips/src/features/models/models.dart';

class ProfileHandler {
  static Future<AppProfile> createProfile(String uid) async {
    AppProfile profile = AppProfile(
      displayName: FirebaseAuth.instance.currentUser!.displayName!,
      photoURL: FirebaseAuth.instance.currentUser!.photoURL,
    );
    profile.nPoints = 0;
    profile.nReports = 0;
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .set(profile.toJson());
    return profile;
  }

  static Future<AppProfile> getProfile(String uid) async {
    AppProfile profile = AppProfile();
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((value) => {profile = AppProfile.fromSnapshot(value.data()!)});
    return profile;
  }

  static updateProfile(AppProfile appProfile, String uid) async {
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .set(appProfile.toJson(), SetOptions(merge: true));
  }
}
