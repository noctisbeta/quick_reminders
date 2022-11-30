import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/firebase/firestore_fields.dart';
import 'package:quick_reminders/firebase/firestore_paths.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/reminders/models/reminder.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';
import 'package:riverpod_firebase_authentication/riverpod_firebase_authentication.dart';

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
          none: () => Stream<List>.value([]),
          some: (user) => FirebaseFirestore.instance
              .collection(FirestorePaths.peopleGroups.path)
              .where(FirestoreFields.userIds.name, arrayContains: user.uid)
              .snapshots()
              .map(
                (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
              ),
        ),
  );

  /// Stream of reminder groups.
  static final reminderGroupStream =
      StreamProvider.autoDispose<List<SurfaceReminderGroup>>(
    (ref) => ref.watch(AuthStore.provider).match(
          none: () => Stream.value([]),
          some: (user) => FirebaseFirestore.instance
              .collection(FirestorePaths.reminderGroups.path)
              .where(FirestoreFields.userIds.name, arrayContains: user.uid)
              .snapshots()
              .map(
                (snapshot) => snapshot.docs
                    .map(SurfaceReminderGroup.fromFirestore)
                    .toList(),
              ),
        ),
  );

  /// Stream of a single reminder group.
  static final reminderGroupContentStream = StreamProvider.autoDispose.family(
    (ref, SurfaceReminderGroup surface) => FirebaseFirestore.instance
        .collection(FirestorePaths.reminderGroups.path)
        .doc(surface.id)
        .collection(FirestorePaths.reminders.path)
        .orderBy(FirestoreFields.createdAt.name)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(Reminder.fromFirestore).toList(),
        ),
  );

  /// Creates a new reminder group with the given [title].
  AsyncResult<Exception, DocumentReference> createReminderGroup(String title) =>
      tap(
        tapped: _authStore.user.match(
          none: () => tap(
            tapped: Task.value(Left(Exception('No user signed in'))),
            effect: () =>
                myLog.e('No user signed in while creating a reminder group.'),
          ),
          some: (user) => _createReminderGroupRaw(title, user.uid),
        ),
        effect: () => myLog.i('Created reminder group $title'),
      );

  AsyncResult<Exception, DocumentReference> _createReminderGroupRaw(
    String title,
    String uid,
  ) =>
      Task(
        () => _db.collection('reminderGroups').add(
              SurfaceReminderGroup.forCreation(
                title: title,
                userIds: [uid],
                createdAt: FieldValue.serverTimestamp(),
              ),
            ),
      ).attempt<Exception>();

  /// Creates a new reminder group with the given [title].
  AsyncResult<Exception, DocumentReference> createReminder(
    String groupId,
    String title,
  ) =>
      Task(
        () => _db
            .collection(FirestorePaths.reminderGroups.path)
            .doc(groupId)
            .collection(FirestorePaths.reminders.path)
            .add(
              Reminder.forCreation(
                title: title,
                createdAt: FieldValue.serverTimestamp(),
              ),
            ),
      ).attempt<Exception>();

  /// Deletes the reminder with [reminderId] from the group with [groupId].
  AsyncResult<Exception, Unit> deleteReminder(
    String groupId,
    String reminderId,
  ) =>
      Task.fromVoid(
        () => _db
            .collection(FirestorePaths.reminderGroups.path)
            .doc(groupId)
            .collection(FirestorePaths.reminders.path)
            .doc(reminderId)
            .delete(),
      ).attempt<Exception>();
}
