import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/models/surface_reminder_group.dart';
import 'package:quick_reminders/routing/routes.dart';

/// Group card.
class ReminderGroupCard extends StatelessWidget {
  /// Default constructor.
  const ReminderGroupCard({
    required this.group,
    super.key,
  });

  /// Surface reminder group.
  final SurfaceReminderGroup group;

  /// Card height.
  static double get cardHeight => 80;

  /// Card width.
  static double get cardWidth => 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed(
        Routes.reminderGroups.name,
        extra: group,
        params: {'slug': group.title.replaceAll(' ', '-')},
      ),
      child: Stack(
        children: [
          Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: kTertiaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              group.title,
              style: const TextStyle(
                color: kQuaternaryColor,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              'Reminders: ${group.activeReminders}',
              style: const TextStyle(
                color: kQuaternaryColor,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
