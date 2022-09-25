import 'package:flutter/material.dart';

/// Hero widget with rotation.
class RotationHero extends StatelessWidget {
  /// Default constructor.
  const RotationHero({
    required this.tag,
    required this.child,
    super.key,
  });

  /// Hero tag.
  final String tag;

  /// The child widget.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        final Widget toHero = toHeroContext.widget;
        return RotationTransition(
          turns: animation.drive(
            Tween(begin: 0, end: 1),
          ),
          child: toHero,
        );
      },
      child: child,
    );
  }
}
