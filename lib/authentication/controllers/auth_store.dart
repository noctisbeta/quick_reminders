import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Auth store.
class AuthStore extends StateNotifier<Option<User>> {
  /// Default constructor.
  AuthStore(
    this.ref,
    this.auth,
  ) : super(const None()) {
    auth.authStateChanges().listen(
          (user) => Option.of(user).match(
            () => state = const None(),
            (user) => state = Some(user),
          ),
        );
  }

  /// Riverpod reference.
  final Ref ref;

  /// Auth.
  FirebaseAuth auth;

  /// Provider.
  static final provider = StateNotifierProvider.autoDispose<AuthStore, Option<User>>(
    (ref) => AuthStore(
      ref,
      FirebaseAuth.instance,
    ),
  );

  /// Is logged in.
  bool get isLoggedIn => state.match(() => false, (some) => true);
}
