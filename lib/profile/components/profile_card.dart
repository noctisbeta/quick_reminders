import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/components/profile_avatar.dart';
import 'package:quick_reminders/profile/models/profile.dart';

/// Profile card.
class ProfileCard extends StatelessWidget {
  /// Default constructor.
  const ProfileCard({
    required this.profileStream,
    super.key,
  });

  /// Profile stream.
  final AsyncValue<Profile> profileStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kQuaternaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const ProfileAvatar(
            expanded: true,
          ),
          const SizedBox(
            height: 12,
          ),
          profileStream.when(
            data: (profile) {
              return Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: kSecondaryColor,
                ),
              );
            },
            error: (error, stackTrace) {
              myLog.e(
                'Error in profile stream: $error \n stackTrace: $stackTrace',
                stackTrace,
              );
              return const Text(
                '',
                style: TextStyle(
                  fontSize: 16,
                ),
              );
            },
            loading: () {
              return const Text(
                '',
                style: TextStyle(
                  fontSize: 16,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
