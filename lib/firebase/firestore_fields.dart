///
enum FirestoreFields {
  /// Array of user ids.
  userIds;

  /// Returns the field name as a string.
  String get name {
    switch (this) {
      case userIds:
        return 'userIds';
    }
  }
}
