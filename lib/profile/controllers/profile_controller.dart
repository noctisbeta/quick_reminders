import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/firebase/firestore_fields.dart';
import 'package:quick_reminders/firebase/firestore_paths.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/models/friend.dart';
import 'package:quick_reminders/profile/models/profile.dart';
import 'package:quick_reminders/profile/models/quick_notification.dart';
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

  /// Returns a user profile of userId.
  static final userProfileStreamProvider =
      StreamProvider.autoDispose.family<Profile, String>(
    (ref, userId) => FirebaseFirestore.instance
        .collection(FirestorePaths.users.path)
        .doc(userId)
        .snapshots()
        .map(Profile.fromFirestore),
  );

  /// Provides the profile stream.
  static final profileStreamProvider = StreamProvider.autoDispose((ref) {
    final db = FirebaseFirestore.instance;

    return ref.watch(AuthStore.provider).match(
          none: () => Stream.value(Profile.empty()),
          some: (user) => db.collection('users').doc(user.uid).snapshots().map(
                Profile.fromFirestore,
              ),
        );
  });

  /// Provides the friends stream.
  static final friendStream = StreamProvider.autoDispose<List<Friend>>(
    (ref) => ref.watch(AuthStore.provider).match(
          none: () => Stream.value([]),
          some: (user) => FirebaseFirestore.instance
              .collection(FirestorePaths.users.path)
              .doc(user.uid)
              .collection(FirestorePaths.friends.path)
              .snapshots()
              .map((event) => event.docs.map(Friend.fromFirestore).toList()),
        ),
  );

  /// Provides the notifications stream.
  static final notificationsStreamProvider =
      StreamProvider.autoDispose<List<QuickNotification>>(
    (ref) => FirebaseFirestore.instance
        .collection(FirestorePaths.users.path)
        // TODO(Janez): Cannot unwrap here, authStore can be not initialized.
        .doc(ref.watch(AuthStore.provider).unwrap().uid)
        .collection(FirestorePaths.notifications.path)
        .snapshots()
        .map(
          (event) => event.docs.map(QuickNotification.fromFirestore).toList(),
        ),
  );

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

  /// Returns true if the logged in user has a profile.
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

  /// Sends a friend request to the user with [email].
  AsyncResult<Exception, DocumentReference> sendFriendRequest(String email) =>
      Task(
        () => _db
            .collection(FirestorePaths.users.path)
            .where(FirestoreFields.email, isEqualTo: email)
            .get(),
      )
          .attempt<Exception>()
          .bindEither(_checkEmptySnapshot)
          .bindEither(_createFriendRequestNotification);

  AsyncResult<Exception, DocumentReference> _checkEmptySnapshot(
    QuerySnapshot snapshot,
  ) =>
      snapshot.docs.isEmpty
          ? AsyncResult.value(Left(Exception('The snapshot is empty.')))
          : AsyncResult.value(Right(snapshot.docs.single.reference));

  AsyncResult<Exception, DocumentReference> _createFriendRequestNotification(
    DocumentReference reference,
  ) =>
      Task(
        () => reference.collection(FirestorePaths.notifications.path).add(
              FriendRequest.forCreation(_authStore.user.unwrap().uid),
            ),
      ).attempt<Exception>();

  /// Accepts a friend request from the user with [friendId].
  AsyncResult<Exception, Unit> acceptFriendRequest(
    String friendId,
  ) =>
      Task.fromVoid(
        () => _db
            .collection(FirestorePaths.users.path)
            .doc(_authStore.user.unwrap().uid)
            .collection(FirestorePaths.friends.path)
            .doc(friendId)
            // TODO(Janez): What to put in the friend document body?
            .set({
          'friendsSince': FieldValue.serverTimestamp(),
        }),
      ).attempt<Exception>();

  /// Deletes a friend request from the user with [notificationId].
  AsyncResult<Exception, Unit> deleteFriendRequest(
    String notificationId,
  ) =>
      Task.fromVoid(
        () => _db
            .collection(FirestorePaths.users.path)
            .doc(_authStore.user.unwrap().uid)
            .collection(FirestorePaths.notifications.path)
            .doc(notificationId)
            .delete(),
      ).attempt<Exception>();
}
