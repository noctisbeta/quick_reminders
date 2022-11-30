import 'package:cloud_firestore/cloud_firestore.dart';

/// People group.
class PeopleGroup {
  /// Default constructor.
  const PeopleGroup({
    required this.id,
    required this.title,
    required this.userIds,
  });

  /// Creates a people group from a [QueryDocumentSnapshot].
  factory PeopleGroup.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return PeopleGroup(
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

  /// Returns a map of the group used for creation on the backend while
  /// requiring the needed parameters.
  static Map<String, dynamic> forCreation({
    required String title,
    required List<String> userIds,
    required FieldValue createdAt,
  }) =>
      {'title': title, 'userIds': userIds, 'createdAt': createdAt};
}
