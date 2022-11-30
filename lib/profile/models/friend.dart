import 'package:cloud_firestore/cloud_firestore.dart';

/// Friend model.
class Friend {
  /// Friend constructor.
  Friend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  /// Friend from json.
  factory Friend.fromFirestore(QueryDocumentSnapshot docsnap) {
    final data = docsnap.data()! as Map<String, dynamic>;
    return Friend(
      id: docsnap.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
    );
  }

  /// Friend id.
  final String id;

  /// Friend name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Friend email.
  final String email;
}
