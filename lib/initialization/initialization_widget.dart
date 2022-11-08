import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/routing/route_controller.dart';

/// This widget is used to initialize the app.
class InitWidget extends HookConsumerWidget {
  /// Default constructor.
  const InitWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useEffect(
    //   () {
    //     if (!kIsWeb) {
    //       ref.read(InitializationController.provider)._initDynamicLinks();
    //     }
    //     return;
    //   },
    //   const [],
    // );

    return MaterialApp.router(
      title: 'Quick Reminders',
      routerConfig: ref.read(RouteController.provider).router,
      debugShowCheckedModeBanner: false,
    );
  }
}
