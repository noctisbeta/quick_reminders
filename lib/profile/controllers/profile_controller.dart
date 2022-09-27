import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/login_controller.dart';
import 'package:quick_reminders/firebase/firebase_providers.dart';
import 'package:quick_reminders/profile/models/profile.dart';

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

  /// Creates a new profile.
  Future<bool> createProfile(UserCredential userCredential) async {
    final user = {
      'firstName': userCredential.user!.displayName!.split(' ')[0],
      'lastName': userCredential.user!.displayName!.split(' ')[1],
      'email': userCredential.user!.email,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('users').doc(userCredential.user!.uid).set(
            user,
            SetOptions(merge: true),
          );

      log('Profile created: $user');
      return true;
    } on FirebaseException catch (e) {
      log('Error creating profile: ${e.message}');
      return false;
    }
  }

  /// Returns true if the user already has a profile.
  Future<bool> userHasProfile() async {
    if (!ref.read(LoginController.provider.notifier).isUserLoggedIn()) {
      log('User is not logged in');
      return false;
    }

    return _db.collection('users').doc(_auth.currentUser!.uid).get().then(
      (value) {
        log('User has profile: ${value.exists}');
        return value.exists;
      },
    );
  }

  /// Signs the user out.
  Future<void> signOut() async {
    // Stop the database reads when the user is signed out, to prevent errors caused by rules.
    await _db.terminate();

    await _auth.signOut();
    log('Signed out the user.');
  }
}
