import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:quick_reminders/routing/routes.dart';

/// Profile avata.
class ProfileAvatar extends ConsumerWidget {
  /// Default constructor.
  const ProfileAvatar({
    this.expanded = false,
    super.key,
  });

  /// The size of the avatar.
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStream = ref.watch(
      ProfileController.profileStreamProvider,
    );

    return Hero(
      tag: 'profileAvatar',
      child: AbsorbPointer(
        absorbing: expanded,
        child: GestureDetector(
          onTap: () => context.goNamed(Routes.profile.name),
          child: profileStream.when(
            data: (profile) => CircleAvatar(
              backgroundColor: kQuinaryColor,
              radius: expanded ? 40 : 20,
              child: Text(
                profile.initials,
                style: TextStyle(
                  fontSize: expanded ? 36 : 18,
                ),
              ),
            ),
            error: (error, stackTrace) {
              myLog.e(
                'Error in profile stream: $error \n stackTrace: $stackTrace',
                error,
                stackTrace,
              );
              return const Text('');
            },
            loading: () => const SizedBox(
              height: 37,
              width: 37,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
