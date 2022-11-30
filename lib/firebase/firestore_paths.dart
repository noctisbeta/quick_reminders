/// Firestore collection paths.
enum FirestorePaths {
  /// top level path
  peopleGroups,

  /// top level path
  reminderGroups,

  /// sub path of reminderGroups
  reminders;

  /// Returns the path to the collection.
  String get path {
    switch (this) {
      case peopleGroups:
        return 'peopleGroups';
      case reminderGroups:
        return 'reminderGroups';
      case reminders:
        return 'reminders';
    }
  }
}
