import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Countdown hook.
int useCountdown({
  required Duration duration,
  required void Function() callback,
  required ValueNotifier<bool> active,
}) {
  final seconds = useState(duration.inSeconds);

  useEffect(
    () {
      Timer? timer;
      if (active.value) {
        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            if (seconds.value <= 0) {
              timer.cancel();
              seconds.value = 5;
              active.value = false;
              callback.call();
            } else {
              seconds.value--;
            }
          },
        );
      }

      return timer?.cancel;
    },
    [active.value],
  );

  return seconds.value;
}
