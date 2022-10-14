import 'package:cloud_firestore/cloud_firestore.dart';

/// Reminders controller.
class RemindersController {
  /// Default constructor.
  const RemindersController({
    required this.db,
  });

  /// Firestore database.
  final FirebaseFirestore db;
}
