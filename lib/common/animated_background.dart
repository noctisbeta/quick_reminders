import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quick_reminders/utilities/extensions/iterable_extension.dart';

/// Animated background.
class AnimatedBackground extends HookWidget {
  /// Default constructor.
  const AnimatedBackground({
    required this.initialColors,
    required this.finalColors,
    this.controller,
    this.stops,
    super.key,
  });

  /// The colors of the background before the animation.
  final List<Color> initialColors;

  /// The colors of the background after the animation.
  final List<Color> finalColors;

  /// Animation controller. If null, a default one is provided and plays the
  /// animation on rebuilds.
  final AnimationController? controller;

  /// Gradient stops.
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    final animationController = controller ??
        useAnimationController(
          duration: const Duration(milliseconds: 300),
        );

    useEffect(() {
      if (controller == null) {
        animationController.forward();
      }

      return;
    });

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: stops,
                colors: [
                  for (int i = 0; i < initialColors.length; i++)
                    ColorTween(
                      begin: initialColors.at(i),
                      end: finalColors.at(i),
                    ),
                ].mapToList(
                  (e) => e.transform(animationController.value)!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
