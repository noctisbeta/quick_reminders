/// Reminder.
class Reminder {
  /// Default constructor
  const Reminder({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Creates a reminder from [map].
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  /// Reminder id.
  final String id;

  /// The title of the reminder.
  final String title;

  /// The description of the reminder.
  final String description;
}
