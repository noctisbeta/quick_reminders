///
enum FirestoreFields {
  /// Array of user ids.
  userIds,

  /// Timestamp of creation.
  createdAt;

  /// Returns the field name as a string.
  String get name {
    switch (this) {
      case userIds:
        return 'userIds';
      case createdAt:
        return 'createdAt';
    }
  }
}
