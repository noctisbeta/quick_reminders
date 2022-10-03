import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';
import 'package:quick_reminders/authentication/views/email_verification_view.dart';
import 'package:quick_reminders/home/home_view.dart';
import 'package:quick_reminders/initialization/authentication_state.dart';
import 'package:quick_reminders/initialization/initialization_controller.dart';

/// This widget is used to initialize the app.
class InitWidget extends HookConsumerWidget {
  /// Default constructor.
  const InitWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationController = ref.read(
      InitializationController.provider,
    );

    useEffect(
      () {
        initializationController.setupLinkStream();
        initializationController.getInitialDynamicLink();
        return;
      },
      const [],
    );

    switch (initializationController.authenticationState) {
      case AuthenticationState.loggedInAndVerified:
        log('loggedInAndVerified');
        return const HomeView();
      case AuthenticationState.loggedIn:
        log('loggedIn');
        return const EmailVerificationView(
          fromLogin: true,
        );
      case AuthenticationState.loggedOut:
        log('loggedOut');
        return const AuthenticationView();
    }
  }
}
