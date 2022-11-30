import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';
import 'package:quick_reminders/reminders/models/people_group.dart';

/// Group card.
class PeopleGroupCard extends StatelessWidget {
  /// Default constructor.
  const PeopleGroupCard({
    required this.group,
    super.key,
  });

  /// People group.
  final PeopleGroup group;

  /// Card height.
  static double get cardHeight => 80;

  /// Card width.
  static double get cardWidth => 100;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
      ],
    );
  }
}
