import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/home/components/notifications_modal.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';

/// Notification button.
class NotificationButton extends ConsumerWidget {
  /// Default constructor.
  const NotificationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(
      ProfileController.notificationsStreamProvider,
    );

    return notifications.when(
      data: (notifications) {
        return Stack(
          children: [
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const NotificationsModal(),
              ),
              icon: Icon(
                Icons.notifications,
                color: notifications.isEmpty ? kSecondaryColor : kTertiaryColor,
              ),
            ),
            if (notifications.isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Center(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: kQuinaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        notifications.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        myLog.e('Error with notifications', error, stackTrace);
        return const SizedBox.shrink();
      },
    );
  }
}
