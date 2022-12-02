import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/components/friend_request_tile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/profile/models/quick_notification.dart';

/// Add people group modal.
class NotificationsModal extends HookConsumerWidget {
  /// Default constructor.
  const NotificationsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(
      ProfileController.notificationsStreamProvider,
    );

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.95,
            maxChildSize: 0.95,
            minChildSize: 0.95,
            builder: (context, controller) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: kQuaternaryColor,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  controller: controller,
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const Divider(
                          color: kSecondaryColor,
                        ),
                        notifications.when(
                          data: (notifications) => Column(
                            children: notifications.map(
                              (notification) {
                                switch (notification.runtimeType) {
                                  case FriendRequest:
                                    return FriendRequestTile(
                                      notification:
                                          notification as FriendRequest,
                                    );
                                }

                                throw StateError('Switch should be exhaustive');
                              },
                            ).toList(),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) => const Center(
                            child: Text('Error'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
