import 'dart:async';
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
    this._auth,
    this._db,
    this._authStore,
  );

  /// Provides the controller.
  static final provider = Provider.autoDispose<ProfileController>(
    (ref) => ProfileController(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
      ref.watch(AuthStore.provider.notifier),
    ),
  );

  /// Firebase auth.
  final FirebaseAuth _auth;

  /// Firestore database.
  final FirebaseFirestore _db;

  /// Auth store.
  final AuthStore _authStore;

  /// Provides the profile stream.
  static final profileStreamProvider = StreamProvider.autoDispose((ref) {
    final db = FirebaseFirestore.instance;

    return ref.watch(AuthStore.provider).match(
          none: () => Stream.value(Profile.empty()),
          some: (user) => db.collection('users').doc(user.uid).snapshots().map(
                Profile.fromSnapshot,
              ),
        );
  });

  /// Creates a new profile.
  Future<Either<Exception, Unit>> createProfileFromUserCredential(
    UserCredential userCredential,
  ) async =>
      Task.fromVoid(
        () => _db.collection('users').doc(userCredential.user!.uid).set(
          {
            'firstName': userCredential.user!.displayName!.split(' ')[0],
            'lastName': userCredential.user!.displayName!.split(' ')[1],
            'email': userCredential.user!.email,
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        ),
      ).attempt<Exception>().run().then(
            (either) => either.match(
              (exception) => tap(
                tapped: left(exception),
                effect: () => Logger().e(
                  'Error creating profile.',
                  exception,
                  StackTrace.current,
                ),
              ),
              (unit) => tap(
                tapped: right(unit),
                effect: () => Logger().i('Created profile.'),
              ),
            ),
          );

  /// Creates a user document in firestore.
  Future<Either<Exception, Unit>> createProfileFromMap(
    Map<String, dynamic> map,
  ) async =>
      Task.fromVoid(
        () => _db.collection('users').doc(map['uid']).set(
          {
            'firstName': map['firstName'],
            'lastName': map['lastName'],
            'email': map['email'],
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        ),
      ).attempt<Exception>().run().then(
            (either) => either.match(
              (exception) => tap(
                tapped: left(exception),
                effect: () => Logger().e(
                  'Error creating profile.',
                  exception,
                  StackTrace.current,
                ),
              ),
              (unit) => tap(
                tapped: right(unit),
                effect: () => Logger().i('Created profile.'),
              ),
            ),
          );

  /// Returns true if the user already has a profile.
  Future<bool> userHasProfile() async {
    return _authStore.user.match(
      none: () =>
          tap(tapped: false, effect: () => Logger().e('User is not logged in')),
      some: (user) => _db.collection('users').doc(user.uid).get().then(
            (value) => value.exists.match(
              ifFalse: () => tap(
                tapped: false,
                effect: () => Logger().i('User does not have a profile'),
              ),
              ifTrue: () => tap(
                tapped: true,
                effect: () => Logger().i('User has a profile'),
              ),
            ),
          ),
    );
  }

  /// Signs the user out.
  Future<void> signOut() async =>
      tap(tapped: _auth.signOut(), effect: () => Logger().i('Signed out'));
}
