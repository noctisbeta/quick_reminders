import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Reminders controller.
class RemindersController {
  /// Default constructor.
  const RemindersController({
    required this.auth,
    required this.db,
  });

  /// Firebase auth.
  final FirebaseAuth auth;

  /// Firestore.
  final FirebaseFirestore db;

  /// Stream of people groups.
  static final peopleGroupStream = StreamProvider.autoDispose(
    (ref) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection = db.collection('users').doc(auth.currentUser!.uid).collection('peopleGroups');

      return collection.snapshots();
    },
  );

  /// Stream of reminder groups.
  static final reminderGroupStream = StreamProvider.autoDispose(
    (ref) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection = db.collection('users').doc(auth.currentUser!.uid).collection('reminderGroups');

      return collection.snapshots();
    },
  );

  /// Stream of a single reminder group.
  static final reminderGroupContentStream = StreamProvider.autoDispose.family(
    (ref, String groupId) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection =
          db.collection('users').doc(auth.currentUser!.uid).collection('reminderGroups').doc(groupId).collection('reminders');

      return collection.snapshots();
    },
  );

  /// Stream of a single people group.
  static final peopleGroupContentStream = StreamProvider.autoDispose.family(
    (ref, String groupId) {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final collection = db.collection('users').doc(auth.currentUser!.uid).collection('peopleGroups').doc(groupId).collection('people');

      return collection.snapshots();
    },
  );

  /// Creates a new reminder group.
  Future<void> createReminderGroup(String name) async {
    final collection = db.collection('users').doc(auth.currentUser!.uid).collection('reminderGroups');

    await collection.add({
      'name': name,
    });
  }
}
