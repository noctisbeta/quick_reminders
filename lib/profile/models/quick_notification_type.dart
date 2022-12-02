/// Quick notification type
enum QuickNotificationType {
  /// Friend request
  friendRequest,

  /// Friend request accepted
  friendRequestAccepted;

  /// Creates a [QuickNotificationType] from a [String].
  static QuickNotificationType fromString(String s) {
    return QuickNotificationType.values.firstWhere((e) => e.name == s);
  }
}
