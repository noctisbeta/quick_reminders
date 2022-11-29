import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_reminders/logging/log_profile.dart';

/// Reminder group.
class SurfaceReminderGroup {
  /// Default constructor
  SurfaceReminderGroup({
    required this.id,
    required this.title,
    required this.userIds,
  });

  /// Creates a surface reminder group from a [QueryDocumentSnapshot].
  factory SurfaceReminderGroup.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    myLog.d('SurfaceReminderGroup.fromFirestore: data: $data');
    myLog.d(doc.id);
    myLog.d(data['title']);

    return SurfaceReminderGroup(
      id: doc.id,
      title: data['title'],
      userIds: List<String>.from(data['userIds']),
    );
  }

  /// Group id.
  final String id;

  /// The title of the group.
  final String title;

  /// The users in the group.
  final List<String> userIds;
}
