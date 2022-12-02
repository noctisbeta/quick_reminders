import 'package:flutter/material.dart';
import 'package:quick_reminders/home/components/notification_button.dart';
import 'package:quick_reminders/profile/components/profile_avatar.dart';

/// Header row for the home screen.
class HomeHeader extends StatelessWidget {
  /// Default constructor.
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        ProfileAvatar(),
        Spacer(),
        NotificationButton(),
      ],
    );
  }
}
