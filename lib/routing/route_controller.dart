import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/views/authentication_view.dart';
import 'package:quick_reminders/authentication/views/email_verification_view.dart';
import 'package:quick_reminders/authentication/views/email_verified_view.dart';
import 'package:quick_reminders/authentication/views/login_view.dart';
import 'package:quick_reminders/authentication/views/reset_password_successful.dart';
import 'package:quick_reminders/authentication/views/reset_password_view.dart';
import 'package:quick_reminders/authentication/views/send_password_reset_successful_view.dart';
import 'package:quick_reminders/authentication/views/send_password_reset_view.dart';
import 'package:quick_reminders/authentication/views/sign_up_view.dart';
import 'package:quick_reminders/home/home_view.dart';
import 'package:quick_reminders/profile/views/profile_view.dart';
import 'package:quick_reminders/routing/listenable_from_stream.dart';

/// Route controller.
class RouteController {
  /// Default constructor.
  RouteController(
    this.auth,
    this.routeObserver,
  );

  /// Firebase auth instance.
  final FirebaseAuth auth;

  /// Route observer.
  final RouteObserver<ModalRoute> routeObserver;

  /// Provides the router.
  static final provider = Provider(
    (ref) => RouteController(
      FirebaseAuth.instance,
      RouteObserver<ModalRoute>(),
    ),
  );

  /// GoRouter.
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: routes,
    refreshListenable: ListenableFromStream(auth.authStateChanges()),
    observers: [routeObserver],
    initialLocation: auth.currentUser == null
        ? '/authentication'
        : auth.currentUser!.emailVerified
            ? '/home'
            : '/authentication/verify',
    redirect: (context, state) {
      log('redirecting');
      log('location ${state.location}');
      // TODO(Janez): Implement redirect for auth state changes.
      return null;
    },
  );

  /// Routes.
  static final routes = <GoRoute>[
    GoRoute(
      path: '/authentication',
      name: 'authentication',
      builder: (context, state) {
        return const AuthenticationView();
      },
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) {
            return const LoginView();
          },
          routes: [
            GoRoute(
              path: 'sendResetPassword',
              name: 'sendResetPassword',
              builder: (context, state) {
                return const SendResetPasswordView();
              },
            ),
            GoRoute(
              path: 'sendResetPasswordSuccessful',
              name: 'sendResetPasswordSuccessful',
              builder: (context, state) {
                return const SendResetPasswordSuccessfulView();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'signUp',
          name: 'signUp',
          builder: (context, state) {
            return const SignUpView();
          },
        ),
        GoRoute(
          path: 'verify',
          name: 'verify',
          builder: (context, state) {
            return const EmailVerificationView();
          },
        ),
        GoRoute(
          path: 'verified',
          name: 'verified',
          builder: (context, state) {
            return const EmailVerifiedView();
          },
        ),
        GoRoute(
          path: 'resetPassword',
          name: 'resetPassword',
          builder: (context, state) {
            return ResetPasswordView(
              oobCode: state.extra! as String,
            );
          },
        ),
        GoRoute(
          path: 'resetPasswordSuccessful',
          name: 'resetPasswordSuccessful',
          builder: (context, state) {
            return const ResetPasswordSuccessfulView();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        return const HomeView();
      },
      routes: [
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) {
            return const ProfileView();
          },
        ),
      ],
    ),
  ];
}
