import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/initialization/initialization_controller.dart';
import 'package:quick_reminders/routing/route_controller.dart';

/// This widget is used to initialize the app.
class InitWidget extends HookConsumerWidget {
  /// Default constructor.
  const InitWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        ref.read(InitializationController.provider).initDynamicLinks();
        return;
      },
      const [],
    );

    return MaterialApp.router(
      title: 'Quick Reminders',
      routerConfig: ref.read(RouteController.provider).router,
      debugShowCheckedModeBanner: false,
    );
  }
}
