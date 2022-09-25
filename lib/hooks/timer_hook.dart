import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Timer hook.
void useTimer(Duration period, void Function() callback) {
  return use(
    _TimerHook(period, callback),
  );
}

class _TimerHook extends Hook<void> {
  const _TimerHook(
    this.period,
    this.callback,
  );

  final void Function() callback;

  final Duration period;

  @override
  __TimerHookState createState() => __TimerHookState();
}

class __TimerHookState extends HookState<void, _TimerHook> {
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
