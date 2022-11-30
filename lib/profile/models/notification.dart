import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification model.
class Notification {
  /// Friend request for creation.
  static Map<String, dynamic> friendRequestCreation(
    String senderId,
  ) {
    return {
      'type': 'friendRequest',
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
