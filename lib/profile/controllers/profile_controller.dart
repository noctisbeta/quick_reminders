import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/models/profile.dart';
import 'package:riverpod_firebase_authentication/riverpod_firebase_authentication.dart';

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
  AsyncResult<Exception, Unit> createProfileFromUserCredential(
    UserCredential userCredential,
  ) =>
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
      ).attempt<Exception>().peekEither(
            (exception) => myLog.e(
              'Error creating profile.',
              exception,
              StackTrace.current,
            ),
            (_) => myLog.i('Created profile.'),
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
                effect: () => myLog.e(
                  'Error creating profile.',
                  exception,
                  StackTrace.current,
                ),
              ),
              (unit) => tap(
                tapped: right(unit),
                effect: () => myLog.i('Created profile.'),
              ),
            ),
          );

  AsyncResult<Exception, bool> userHasProfile() => _authStore.user.match(
        none: () => tap(
          tapped: AsyncResult.value(Left(Exception('No user logged in.'))),
          effect: () => myLog.e('No user logged in.'),
        ),
        some: (user) => _userHasProfileRaw(user.uid),
      );

  AsyncResult<Exception, bool> _userHasProfileRaw(String uid) => Task(
        () => _db.collection('users').doc(uid).get(),
      ).attempt<Exception>().mapEitherRight((docsnap) => docsnap.exists);

  /// Signs the user out.
  Future<void> signOut() async =>
      tap(tapped: _auth.signOut(), effect: () => myLog.i('Signed out'));
}
