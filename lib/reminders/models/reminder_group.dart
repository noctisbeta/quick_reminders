import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/reminders/models/reminder.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';

/// Reminder group.
class ReminderGroup extends SurfaceReminderGroup {
  /// Default constructor
  ReminderGroup({
    required super.id,
    required super.title,
    required super.userIds,
    required this.reminders,
  });

  /// Creates a reminder group from a [QueryDocumentSnapshot].
  factory ReminderGroup.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    myLog.d('ReminderGroup.fromFirestore: data: $data');
    return ReminderGroup(
      id: doc.id,
      title: data['title'],
      userIds: List<String>.from(data['userIds']),
      reminders: data['reminders']?.map(Reminder.fromMap).toList() ?? [],
    );
  }

  /// The reminders in the group.
  final List<Reminder> reminders;
}
