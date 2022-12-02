import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/models/quick_notification.dart';

/// Friend request tile.
class FriendRequestTile extends HookConsumerWidget {
  /// Default constructor.
  const FriendRequestTile({
    required this.notification,
    super.key,
  });

  /// Notification.
  final FriendRequest notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.userProfileStreamProvider(notification.senderId),
    );

    final profileCtl = ref.watch(ProfileController.provider);

    final accLoading = useState(false);
    final decLoading = useState(false);

    void acceptFriendRequest() => profileCtl
        .acceptFriendRequest(notification.senderId)
        .bindEither((succ) => profileCtl.deleteFriendRequest(notification.id))
        .then(
          (either) => either.peekLeft(
            (exception) {
              accLoading.value = false;

              myLog.e(
                'Failed to accept or delete friend request: $exception',
                exception,
                StackTrace.current,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exception.toString()),
                ),
              );
            },
          ),
        );

    void declineFriendRequest() =>
        profileCtl.deleteFriendRequest(notification.senderId).then(
              (either) => either.peekLeft(
                (exception) {
                  decLoading.value = false;

                  myLog.e(
                    'Failed to decline friend request: $exception',
                    exception,
                    StackTrace.current,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(exception.toString()),
                    ),
                  );
                },
              ),
            );

    return profileStream.when(
      data: (profile) => ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text('${profile.firstName} ${profile.lastName}'),
        subtitle: Text(notification.body),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (accLoading.value)
              const CircularProgressIndicator()
            else
              IconButton(
                onPressed: () {
                  accLoading.value = true;
                  acceptFriendRequest();
                },
                icon: const Icon(
                  Icons.check,
                  color: kPrimaryColor,
                ),
              ),
            if (decLoading.value)
              const CircularProgressIndicator()
            else
              IconButton(
                onPressed: () {
                  decLoading.value = true;
                  declineFriendRequest();
                },
                icon: const Icon(
                  Icons.close,
                  color: kSecondaryColor,
                ),
              ),
          ],
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        myLog.e('Error in friend request tile', error, stackTrace);
        return const Text('Error');
      },
    );
  }
}
