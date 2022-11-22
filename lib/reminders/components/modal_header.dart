import 'package:flutter/material.dart';
import 'package:quick_reminders/constants/colors.dart';

/// ModalHeader.
class ModalHeader extends StatelessWidget {
  /// Default constructor.
  const ModalHeader({
    required this.disabled,
    required this.title,
    super.key,
  });

  /// Disabled.
  final bool disabled;

  /// Title.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.close,
            color: kSecondaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: kSecondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.check,
            color: disabled ? kQuinaryColor : kSecondaryColor,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
