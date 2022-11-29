import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_reminders/reminders/models/reminder.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';

/// Reminder group.
class ReminderGroup extends SurfaceReminderGroup {
  /// Default constructor
  ReminderGroup({
    required super.id,
    required super.title,
    required this.reminders,
  });

  /// The reminders in the group.
  final List<Reminder> reminders;

  ReminderGroup.fromFirestore(QueryDocumentSnapshot doc)
      : reminders = (doc.data()! as Map<String, dynamic>)['title'],
        super(
          id: doc.id,
          title: (doc.data()! as Map<String, dynamic>)['title'],
        );
}
