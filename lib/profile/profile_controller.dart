// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/profile/profile.dart';

/// Profile controller.
class ProfileController {
  /// Provides the controller.
  static final provider = Provider<ProfileController>(
    (ref) => ProfileController(),
  );

  /// Provides the profile stream.
  static final profileStreamProvider = StreamProvider(
    (ref) => _db.collection('users').doc(_auth.currentUser!.uid).snapshots().map(Profile.fromSnapshot),
  );

  static final _auth = FirebaseAuth.instance;

  static final _db = FirebaseFirestore.instance;

  /// Signs the user out.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
