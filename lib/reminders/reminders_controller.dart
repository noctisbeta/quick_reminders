import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/auth_store.dart';

/// Reminders controller.
class RemindersController {
  /// Default constructor.
  const RemindersController(
    this._db,
    this._authStore,
  );

  /// Firestore.
  final FirebaseFirestore _db;

  /// Auth store.
  final AuthStore _authStore;

  /// Provides the controller.
  static final provider = Provider.autoDispose<RemindersController>(
    (ref) => RemindersController(
      FirebaseFirestore.instance,
      ref.watch(AuthStore.provider.notifier),
    ),
  );

  /// Stream of people groups.
  static final peopleGroupStream = StreamProvider.autoDispose<List>(
    (ref) => ref.watch(AuthStore.provider).match(
          () => Stream<List>.value([]),
          (user) => FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('peopleGroups')
              .snapshots()
              .map(
                (snapshot) => snapshot.docs
                    .map(
                      (doc) => doc.data(),
                    )
                    .toList(),
              ),
        ),
  );

  /// Stream of reminder groups.
  static final reminderGroupStream = StreamProvider.autoDispose(
    (ref) => ref.watch(AuthStore.provider).match(
          () => Stream.value([]),
          (user) => FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('reminderGroups')
              .snapshots()
              .map(
                (snapshot) => snapshot.docs
                    .map(
                      (doc) => doc.data(),
                    )
                    .toList(),
              ),
        ),
  );

  /// Stream of a single reminder group.
  static final reminderGroupContentStream = StreamProvider.autoDispose.family(
    (ref, String groupId) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection = db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('reminderGroups')
          .doc(groupId)
          .collection('reminders');

      return collection.snapshots();
    },
  );

  /// Stream of a single people group.
  static final peopleGroupContentStream = StreamProvider.autoDispose.family(
    (ref, String groupId) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection = db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('peopleGroups')
          .doc(groupId)
          .collection('people');

      return collection.snapshots();
    },
  );

  /// Creates a new reminder group.
  Future<bool> createReminderGroup(String name) async => _authStore.user.match(
        () => withEffect(false, () => Logger().e('User not logged in')),
        (user) => Task(
          () => _db
              .collection('users')
              .doc(user.uid)
              .collection('reminderGroups')
              .add({
            'name': name,
          }),
        ).attemptAll().run().then(
              (either) => either.match(
                (failure) => withEffect(
                  false,
                  () => Logger().e('Failed to create reminder group: $failure'),
                ),
                (success) => withEffect(
                  true,
                  () => Logger().d('Created reminder group: $success'),
                ),
              ),
            ),
      );
}
