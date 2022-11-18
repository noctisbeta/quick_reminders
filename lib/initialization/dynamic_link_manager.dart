import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/routing/route_controller.dart';

/// Controller for app initialization.
class DynamicLinkManager {
  /// Default constructor.
  DynamicLinkManager(
    this._links,
    this._routeController,
  ) {
    _initDynamicLinks();
  }

  /// Provides the controller.
  static final provider = Provider.autoDispose(
    (ref) => DynamicLinkManager(
      FirebaseDynamicLinks.instance,
      ref.watch(RouteController.provider),
    ),
  );

  /// Firebase dynamic links instance.
  final FirebaseDynamicLinks _links;

  /// Router.
  final RouteController _routeController;

  /// Initializes dynamic links.
  void _initDynamicLinks() {
    Logger().d('Initializing dynamic links');
    _getInitialDynamicLink();
    _setupLinkStream();
  }

  /// Gets the initial dynamic link.
  Future<Unit> _getInitialDynamicLink() async => Task.fromNullable(
        _links.getInitialLink,
      ).run().then(
            (option) => option.match(
              () => unit,
              (data) => handleRouting(data.link),
            ),
          );

  /// Setup linkStream listeners.
  Unit _setupLinkStream() => withEffect(
        unit,
        () => _links.onLink.listen(
          (event) => handleRouting(event.link),
        ),
      );

  /// Handles app routing based on the dynamic link url path.
  Unit handleRouting(Uri deepLink) {
    final continueUrl = deepLink.queryParameters['continueUrl']!;
    final path = Uri.parse(continueUrl).path;

    Logger().d('Handling dynamic link: $path');

    final router = _routeController.router;

    switch (path) {
      case '/resetPassword':
        router.goNamed(
          'resetPassword',
          extra: deepLink.queryParameters['oobCode'],
        );
        break;

      case '/verifyEmail':
        router.goNamed(
          'verified',
        );
        break;
    }

    return unit;
  }
}
