import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/initialization/authentication_state.dart';

/// Controller for app initialization.
class InitializationController {
  /// Default constructor.
  InitializationController(
    this.ref,
    this.auth,
  );

  /// Provides the controller.
  static final provider = Provider.autoDispose(
    (ref) => InitializationController(
      ref,
      FirebaseAuth.instance,
    ),
  );

  /// Riverpod ref.
  final Ref ref;

  /// Firebase auth instance.
  final FirebaseAuth auth;

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
}
