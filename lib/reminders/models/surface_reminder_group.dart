import 'package:cloud_firestore/cloud_firestore.dart';

/// Reminder group.
class SurfaceReminderGroup {
  /// Default constructor
  SurfaceReminderGroup({
    required this.id,
    required this.title,
    required this.userIds,
    required this.activeReminders,
  });

  /// Creates a surface reminder group from a [QueryDocumentSnapshot].
  factory SurfaceReminderGroup.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return SurfaceReminderGroup(
      id: doc.id,
      title: data['title'],
      userIds: List<String>.from(data['userIds']),
      activeReminders: data['activeReminders'] ?? 0,
    );
  }

  /// Group id.
  final String id;

  /// The title of the group.
  final String title;

  /// The users in the group.
  final List<String> userIds;

  /// Number of uncompleted reminders in this group.
  final int activeReminders;
}
