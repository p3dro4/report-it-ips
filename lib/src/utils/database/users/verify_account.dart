import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils.dart';

class VerifyAccount {
  static Future<bool> isProfileComplete() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc[UserFields.profileCompleted.name] as bool;
    }
    return false;
  }
}
