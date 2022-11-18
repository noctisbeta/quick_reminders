import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/auth_store.dart';

/// Reminders controller.
class RemindersController {
  /// Default constructor.
  const RemindersController(
    this._auth,
    this._db,
  );

  /// Firebase auth.
  final FirebaseAuth _auth;

  /// Firestore.
  final FirebaseFirestore _db;

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
  Future<void> createReminderGroup(String name) async {
    final collection = _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('reminderGroups');

    await collection.add({
      'name': name,
    });
  }
}
