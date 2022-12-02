import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_reminders/profile/models/quick_notification_type.dart';

/// Notification model.
abstract class QuickNotification {
  /// Default constructor.
  const QuickNotification();

  /// Title of the notification.
  String get title;

  /// Body of the notification.
  String get body;

  /// Constructs a [QuickNotification] from a [QueryDocumentSnapshot] based on
  /// the [QuickNotificationType].
  static QuickNotification fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    final type = QuickNotificationType.fromString(data['type'] as String);

    switch (type) {
      case QuickNotificationType.friendRequest:
        return FriendRequest.fromFirestore(snapshot);
      case QuickNotificationType.friendRequestAccepted:
        return FriendRequestAccepted.fromFirestore(snapshot);
    }
  }
}

/// Friend request model.
class FriendRequest extends QuickNotification {
  /// Default constructor.
  const FriendRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
  });

  /// Constructs a [FriendRequest] from a [QueryDocumentSnapshot].
  factory FriendRequest.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return FriendRequest(
      id: snapshot.id,
      title: 'Friend request',
      body: 'You have a new friend request',
      senderId: data['senderId'] as String,
    );
  }

  /// id
  final String id;

  /// Title of the notification.
  @override
  final String title;

  /// Body of the notification.
  @override
  final String body;

  /// Sender of the notification.
  final String senderId;

  /// Friend request for creation.
  static Map<String, dynamic> forCreation(
    String senderId,
  ) {
    return {
      'type': QuickNotificationType.friendRequest.name,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

/// Friend request accepted model.
class FriendRequestAccepted extends QuickNotification {
  /// Default constructor.
  const FriendRequestAccepted({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
  });

  /// Constructs a [FriendRequestAccepted] from a [QueryDocumentSnapshot].
  factory FriendRequestAccepted.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return FriendRequestAccepted(
      id: snapshot.id,
      title: 'Friend request accepted',
      body: 'Your friend request has been accepted',
      senderId: data['senderId'] as String,
    );
  }

  /// id
  final String id;

  /// Title of the notification.
  @override
  final String title;

  /// Body of the notification.
  @override
  final String body;

  /// Sender of the notification.
  final String senderId;

  /// Friend request accepted for creation.
  static Map<String, dynamic> forCreation(
    String senderId,
  ) {
    return {
      'type': QuickNotificationType.friendRequestAccepted.name,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
