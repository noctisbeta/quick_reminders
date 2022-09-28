import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/google_controller.dart';
import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/authentication/models/login/login_data_errors.dart';
import 'package:quick_reminders/authentication/models/login/login_state.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';

/// Login controller.
class LoginController extends StateNotifier<LoginState> {
  /// Default constructor.
  LoginController(
    this.ref,
    this.auth,
  ) : super(
          LoginState.empty(),
        );

  /// Riverpod reference.
  final Ref ref;

  /// Firebase auth.
  final FirebaseAuth auth;

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<LoginController, LoginState>(
    (ref) => LoginController(
      ref,
      FirebaseAuth.instance,
    ),
  );

  /// Sign in with google.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      googleInProgress: true,
    );

    await auth.signOut();

    final account = await ref.read(GoogleController.provider).signInWithGoogle();

    if (account == null) {
      state = state.copyWith(
        googleInProgress: false,
      );
      return false;
    }

    log('User signed in to google: ${account.email}');

    final googleAuth = await account.authentication;

    final userCredential = await auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      ),
    );

    final profileController = ref.read(ProfileController.provider);

    final hasProfile = await profileController.userHasProfile();

    late final bool result;
    if (!hasProfile) {
      result = await profileController.createProfileFromUserCredential(userCredential);
    } else {
      result = true;
    }

    state = state.copyWith(
      googleInProgress: false,
    );
    return result;
  }

  /// Logs in the user with email and password.
  Future<bool> login(LoginData loginData) async {
    state = state.copyWith(
      loginData: loginData,
      loginDataErrors: LoginDataErrors.empty(),
      processingState: ProcessingState.loading,
    );

    final result = await _loginUser(state.loginData);

    return await result.fold(
      (exception) {
        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );
        return false;
      },
      (userCredential) async {
        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );
        return true;
      },
    );
  }

  /// Logs in the user with email and password.
  Future<Either<Exception, UserCredential>> _loginUser(LoginData loginData) async {
    try {
      await auth.signOut();

      if (loginData.email.isEmpty) {
        state = state.copyWith(
          loginDataErrors: state.loginDataErrors.copyWith(
            email: 'Email is required',
          ),
        );
        return Left(Exception('Email is empty'));
      }

      if (loginData.password.isEmpty) {
        state = state.copyWith(
          loginDataErrors: state.loginDataErrors.copyWith(
            password: 'Password is required',
          ),
        );
        return Left(Exception('Password is empty'));
      }

      final userCredential = await auth.signInWithEmailAndPassword(
        email: loginData.email.trim(),
        password: loginData.password.trim(),
      );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      log('Error loging in user: ${e.message}');

      late final String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email.';
          state = state.copyWith(
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'user-disabled':
          message = 'User disabled.';
          state = state.copyWith(
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'user-not-found':
          message = 'User not found.';
          state = state.copyWith(
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'wrong-password':
          message = 'Wrong password.';
          state = state.copyWith(
            loginDataErrors: state.loginDataErrors.copyWith(
              password: message,
            ),
          );
          break;
      }

      return Left(e);
    }
  }

  /// Returns true if a user is logged in.
  bool isUserLoggedIn() {
    return auth.currentUser != null;
  }

  /// Checks if the current user has their email verified.
  Future<bool> isEmailVerified() async {
    if (auth.currentUser == null) {
      log('No user is signed in.');
      return false;
    }
    await auth.currentUser!.reload();
    return auth.currentUser!.emailVerified;
  }

  /// Call only if user is logged in.
  bool isEmailVerifiedSync() {
    return auth.currentUser!.emailVerified;
  }
}
