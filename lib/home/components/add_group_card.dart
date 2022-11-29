import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Add group card.
class AddGroupCard extends StatelessWidget {
  /// Default constructor.
  const AddGroupCard({
    required this.onTap,
    super.key,
  });

  /// On tap.
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(
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
      ),
    );
  }
}
