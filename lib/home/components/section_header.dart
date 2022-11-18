import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// Home screen section header.
class SectionHeader extends StatelessWidget {
  /// Default constructor.
  const SectionHeader({
    required this.title,
    super.key,
  });

  /// Section header title.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: kSecondaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
        ),
        const Expanded(
          flex: 20,
          child: Divider(
            color: kSecondaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              // color: kPrimaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: kQuinaryColor),
            ),
            child: const Icon(
              Icons.add,
              color: kQuinaryColor,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: kSecondaryColor,
          ),
        ),
      ],
    );
  }
}
