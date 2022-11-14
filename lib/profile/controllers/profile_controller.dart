import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/auth_store.dart';
import 'package:quick_reminders/profile/models/profile.dart';

/// Profile controller.
class ProfileController {
  /// Default constructor.
  const ProfileController(
    this.ref,
    this.auth,
    this.db,
    this._authStore,
  );

  /// Provides the controller.
  static final provider = Provider.autoDispose<ProfileController>(
    (ref) => ProfileController(
      ref,
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
      ref.watch(AuthStore.provider.notifier),
    ),
  );

  /// Riverpod reference.
  final Ref ref;

  /// Firebase auth.
  final FirebaseAuth auth;

  /// Firestore database.
  final FirebaseFirestore db;

  /// Auth store.
  final AuthStore _authStore;

  /// Provides the profile stream.
  static final profileStreamProvider = StreamProvider.autoDispose((ref) {
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    return db.collection('users').doc(auth.currentUser!.uid).snapshots().map(Profile.fromSnapshot);
  });

  /// Creates a new profile.
  Future<Either<Exception, Unit>> createProfileFromUserCredential(UserCredential userCredential) async => Task.fromVoid(
        () => db.collection('users').doc(userCredential.user!.uid).set(
          {
            'firstName': userCredential.user!.displayName!.split(' ')[0],
            'lastName': userCredential.user!.displayName!.split(' ')[1],
            'email': userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        ),
      ).attemptEither<Exception>().run().then(
            (either) => either.match(
              (exception) => withEffect(
                left(exception),
                () => Logger().e('Error creating profile.', exception, StackTrace.current),
              ),
              (unit) => withEffect(
                right(unit),
                () => Logger().i('Created profile.'),
              ),
            ),
          );

  /// Creates a user document in firestore.
  Future<Either<Exception, Unit>> createProfileFromMap(Map<String, dynamic> map) async => Task.fromVoid(
        () => db.collection('users').doc(map['uid']).set(
          {
            'firstName': map['firstName'],
            'lastName': map['lastName'],
            'email': map['email'],
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        ),
      ).attemptEither<Exception>().run().then(
            (either) => either.match(
              (exception) => withEffect(
                left(exception),
                () => Logger().e('Error creating profile.', exception, StackTrace.current),
              ),
              (unit) => withEffect(
                right(unit),
                () => Logger().i('Created profile.'),
              ),
            ),
          );

  /// Returns true if the user already has a profile.
  Future<bool> userHasProfile() async {
    return _authStore.isLoggedIn.match(
      () => withEffect(false, () => Logger().e('User is not logged in')),
      () => db.collection('users').doc(auth.currentUser!.uid).get().then(
            (value) => value.exists.match(
              () => withEffect(true, () => Logger().i('User has a profile')),
              () => withEffect(false, () => Logger().i('User does not have a profile')),
            ),
          ),
    );
  }

  /// Signs the user out.
  Future<void> signOut() async {
    // Stop the database reads when the user is signed out, to prevent errors caused by rules.
    await db.terminate();

    await auth.signOut();
    log('Signed out the user.');
  }
}
