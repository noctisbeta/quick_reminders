import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/initialization/authentication_state.dart';
import 'package:quick_reminders/routing/route_controller.dart';

/// Controller for app initialization.
class InitializationController {
  /// Default constructor.
  InitializationController(
    this.ref,
    this.auth,
    this.links,
  ) {
    _initDynamicLinks();
  }

  /// Provides the controller.
  static final provider = Provider.autoDispose(
    (ref) => InitializationController(
      ref,
      FirebaseAuth.instance,
      FirebaseDynamicLinks.instance,
    ),
  );

  /// Riverpod ref.
  final Ref ref;

  /// Firebase auth instance.
  final FirebaseAuth auth;

  /// Firebase dynamic links instance.
  final FirebaseDynamicLinks links;

  /// Returns the current authentication state.
  AuthenticationState get authenticationState {
    final user = auth.currentUser;

    if (user == null) {
      return AuthenticationState.loggedOut;
    } else if (user.emailVerified) {
      return AuthenticationState.loggedInAndVerified;
    } else {
      return AuthenticationState.loggedIn;
    }
  }

  /// Initializes dynamic links.
  void _initDynamicLinks() {
    log('init dynamic links');
    getInitialDynamicLink();
    setupLinkStream();
  }

  /// Gets the initial dynamic link.
  Future<void> getInitialDynamicLink() async {
    final PendingDynamicLinkData? data = await links.getInitialLink();

    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      log('deepLink: $deepLink');
      log('deepLink.path: ${deepLink.path}');
      log('deepLink.queryParameters: ${deepLink.queryParameters}');

      handleRouting(deepLink);
    }
  }

  /// Setup linkStream listeners.
  void setupLinkStream() {
    links.onLink.listen(
      (event) {
        final Uri deepLink = event.link;

        log('deepLink: $deepLink');
        log('deepLink.path: ${deepLink.path}');
        log('deepLink.queryParameters: ${deepLink.queryParameters}');
        log('deepLink.queryParametersAll: ${deepLink.queryParametersAll}');

        handleRouting(deepLink);
      },
    );
  }

  /// Handles app routing based on the dynamic link url path.
  void handleRouting(Uri deepLink) {
    final continueUrl = deepLink.queryParameters['continueUrl']!;
    final path = Uri.parse(continueUrl).path;

    log('handleRouting: $path');

    final router = ref.read(RouteController.provider).router;

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
  }
}
