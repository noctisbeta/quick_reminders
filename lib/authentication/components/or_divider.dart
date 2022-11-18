import 'package:flutter/material.dart';

/// Divider with text in the middle.
class OrDivider extends StatelessWidget {
  /// Default constructor.
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Text(
              'OR',
              style: TextStyle(
                color: Colors.blue[500],
                fontSize: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
