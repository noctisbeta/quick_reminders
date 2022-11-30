/// Firestore collection paths.
enum FirestorePaths {
  /// top level path
  peopleGroups,

  /// top level path
  reminderGroups,

  /// sub path of reminderGroups
  reminders,

  /// users
  users,

  /// sub path of users
  friends,

  /// sub path of users
  notifications;

  /// Returns the path to the collection.
  String get path {
    switch (this) {
      case peopleGroups:
        return 'peopleGroups';
      case reminderGroups:
        return 'reminderGroups';
      case reminders:
        return 'reminders';

      case users:
        return 'users';
      case friends:
        return 'friends';
      case notifications:
        return 'notifications';
    }
  }
}
