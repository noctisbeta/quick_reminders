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
}
