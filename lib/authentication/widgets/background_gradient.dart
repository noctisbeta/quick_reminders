import 'package:flutter/material.dart';

/// Background gradient.
class BackgroundGradient extends StatelessWidget {
  /// Default constructor.
  const BackgroundGradient({
    required this.gradient,
    super.key,
  });

  /// The gradient.
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      ),
    );
  }
}
