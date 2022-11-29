import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/views/reminder_group_view.dart';

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

  /// Card height.
  static double get cardHeight => 80;

  /// Card width.
  static double get cardWidth => 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReminderGroupView(),
        ),
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
      ),
    );
  }
}
