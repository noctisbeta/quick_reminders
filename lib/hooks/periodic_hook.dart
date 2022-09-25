import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Periodic hook.
void usePeriodic(Duration period, void Function() callback) {
  return use(
    _PeriodicHook(period, callback),
  );
}

class _PeriodicHook extends Hook<void> {
  const _PeriodicHook(
    this.period,
    this.callback,
  );

  final void Function() callback;

  final Duration period;

  @override
  __PeriodicHookState createState() => __PeriodicHookState();
}

class __PeriodicHookState extends HookState<void, _PeriodicHook> {
  late final Timer _timer;

  @override
  void initHook() {
    super.initHook();

    _timer = Timer.periodic(
      hook.period,
      (timer) {
        hook.callback.call();
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void build(BuildContext context) {}
}
