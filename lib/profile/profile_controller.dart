import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/firebase/firebase_providers.dart';
import 'package:quick_reminders/profile/profile.dart';

/// Profile controller.
class ProfileController {
  /// Default constructor.
  const ProfileController(this.ref);

  /// Provides the controller.
  static final provider = Provider.autoDispose<ProfileController>(
    ProfileController.new,
  );

  /// Riverpod reference.
  final Ref ref;

  /// Provides the profile stream.
  static final profileStreamProvider = StreamProvider.autoDispose((ref) {
    final db = ref.watch(storeProvider);
    final auth = ref.watch(authProvider);

    return db.collection('users').doc(auth.currentUser!.uid).snapshots().map(Profile.fromSnapshot);
  });

  FirebaseAuth get _auth => ref.read(authProvider);
  FirebaseFirestore get _db => ref.read(storeProvider);

  /// Signs the user out.
  Future<void> signOut() async {
    // Stop the database reads when the user is signed out, to prevent errors caused by rules.
    await _db.terminate();

    await _auth.signOut();
    log('Signed out the user.');
  }
}
