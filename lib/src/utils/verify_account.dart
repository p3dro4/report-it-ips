import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyAccount {
  static Future<bool> isProfileComplete() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where("userId", isEqualTo: user.uid)
          .get();
      for (final doc in userDoc.docs) {
        final data = doc.data();
        return data["profileCompleted"] as bool;
      }
    }
    return false;
  }
}
