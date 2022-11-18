import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/auth_store.dart';
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
import 'package:quick_reminders/routing/routes.dart';

/// Route controller.
class RouteController {
  /// Default constructor.
  RouteController(
    this.routeObserver,
    this._authStore,
    this._auth,
  );

  /// Firebase auth instance.
  final FirebaseAuth _auth;

  /// Route observer.
  final RouteObserver<ModalRoute> routeObserver;

  /// Auth store.
  final AuthStore _authStore;

  /// Provides the router.
  static final provider = Provider.autoDispose(
    (ref) => RouteController(
      RouteObserver<ModalRoute>(),
      ref.watch(AuthStore.provider.notifier),
      FirebaseAuth.instance,
    ),
  );

  /// GoRouter.
  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: routes,
    refreshListenable: ListenableFromStream(_auth.authStateChanges()),
    observers: [routeObserver],
    initialLocation: _authStore.user.match(
      () => Routes.authentication.path,
      (user) => user.emailVerified
          ? Routes.home.path
          : Routes.authentication.path + Routes.verify.path,
    ),
    redirect: (context, state) {
      Logger().d('Redirecting to ${state.location}');

      return _authStore.user.match(
        () => state.location.contains(Routes.authentication.path)
            ? null
            : Routes.authentication.path,
        (user) => user.emailVerified
            ? null
            : Routes.authentication.path + Routes.verify.path,
      );
    },
  );

  /// Routes.
  static final routes = <GoRoute>[
    ..._authRoutes,
    ..._homeRoutes,
  ];

  static final _authRoutes = {
    GoRoute(
      path: Routes.authentication.path,
      name: Routes.authentication.name,
      builder: (context, state) {
        return const AuthenticationView();
      },
      routes: [
        GoRoute(
          path: Routes.login.subPath,
          name: Routes.login.name,
          builder: (context, state) {
            return const LoginView();
          },
          routes: [
            GoRoute(
              path: Routes.sendResetPassword.subPath,
              name: Routes.sendResetPassword.name,
              builder: (context, state) {
                return const SendResetPasswordView();
              },
            ),
            GoRoute(
              path: Routes.sendResetPasswordSuccessful.subPath,
              name: Routes.sendResetPasswordSuccessful.name,
              builder: (context, state) {
                return const SendResetPasswordSuccessfulView();
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.signUp.subPath,
          name: Routes.signUp.name,
          builder: (context, state) {
            return const SignUpView();
          },
        ),
        GoRoute(
          path: Routes.verify.subPath,
          name: Routes.verify.name,
          builder: (context, state) {
            return const EmailVerificationView();
          },
        ),
        GoRoute(
          path: Routes.verified.subPath,
          name: Routes.verified.name,
          builder: (context, state) {
            return const EmailVerifiedView();
          },
        ),
        GoRoute(
          path: Routes.resetPassword.subPath,
          name: Routes.resetPassword.name,
          builder: (context, state) {
            return ResetPasswordView(
              oobCode: state.extra! as String,
            );
          },
        ),
        GoRoute(
          path: Routes.resetPasswordSuccessful.subPath,
          name: Routes.resetPasswordSuccessful.name,
          builder: (context, state) {
            return const ResetPasswordSuccessfulView();
          },
        ),
      ],
    ),
  };

  static final _homeRoutes = {
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      builder: (context, state) {
        return const HomeView();
      },
      routes: [
        GoRoute(
          path: Routes.profile.subPath,
          name: Routes.profile.name,
          builder: (context, state) {
            return const ProfileView();
          },
        ),
      ],
    ),
  };
}
