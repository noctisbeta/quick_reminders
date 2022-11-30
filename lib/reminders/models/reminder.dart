import 'package:cloud_firestore/cloud_firestore.dart';

/// Reminder.
class Reminder {
  /// Default constructor
  const Reminder({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Creates a reminder from [docsnap].
  factory Reminder.fromFirestore(QueryDocumentSnapshot docsnap) {
    final map = docsnap.data()! as Map<String, dynamic>;

    return Reminder(
      id: docsnap.id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  /// For creation.
  static Map<String, dynamic> forCreation({
    required String title,
    required FieldValue createdAt,
  }) =>
      {'title': title, 'createdAt': createdAt};

  /// Reminder id.
  final String id;

  /// The title of the reminder.
  final String title;

  /// The description of the reminder.
  final String description;
}
