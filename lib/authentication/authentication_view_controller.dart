import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Controller for the authentication views.
class AuthenticationViewController extends StateNotifier<double> {
  /// Default constructor.
  AuthenticationViewController() : super(0);

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<AuthenticationViewController, double>(
    (ref) => AuthenticationViewController(),
  );

  /// Ticks the animation until cancelled.
  Timer? animationTimer;

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  /// Starts the animation.
  void startAnimation() {
    animationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        state += 0.05;

        if (state >= 1) {
          timer.cancel();
        }
      },
    );
  }

  /// Reverses the animation.
  void reverseAnimation() {
    state = 1;
    animationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        state -= 0.05;

        if (state <= 0) {
          timer.cancel();
        }
      },
    );
  }

  /// Tweens between two colors.
  Color colorTween(Color begin, Color end) {
    return ColorTween(
      begin: begin,
      end: end,
    ).transform(state)!;
  }
}
