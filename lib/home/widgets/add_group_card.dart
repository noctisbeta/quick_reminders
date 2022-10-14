import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Add group card.
class AddGroupCard extends StatelessWidget {
  /// Default constructor.
  const AddGroupCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            // color: kTertiaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kQuinaryColor),
          ),
          child: const Icon(
            Icons.add,
            color: kQuinaryColor,
            size: 40,
          ),
        ),
      ],
    );
  }
}
