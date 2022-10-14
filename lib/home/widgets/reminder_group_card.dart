import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Group card.
class ReminderGroupCard extends StatelessWidget {
  /// Default constructor.
  const ReminderGroupCard({
    required this.title,
    required this.numReminders,
    super.key,
  });

  /// Title.
  final String title;

  /// Number of reminders.
  final int numReminders;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            color: kTertiaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Text(
            title,
            style: const TextStyle(
              color: kQuaternaryColor,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            'Reminders: $numReminders',
            style: const TextStyle(
              color: kQuaternaryColor,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
