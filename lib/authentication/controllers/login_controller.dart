import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_controller.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_controller_web.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_protocol.dart';
import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/authentication/models/login/login_data_errors.dart';
import 'package:quick_reminders/authentication/models/login/login_state.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';

/// Login controller.
class LoginController extends StateNotifier<LoginState> {
  /// Default constructor.
  LoginController(
    this._auth,
    this._googleController,
    this._profileController,
  ) : super(
          LoginState.empty(),
        );

  /// Firebase auth.
  final FirebaseAuth _auth;

  /// Google sign in controller.
  final GoogleSignInProtocol _googleController;

  /// Profile controller.
  final ProfileController _profileController;

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<LoginController, LoginState>(
    (ref) {
      late final GoogleSignInProtocol googleController;

      if (kIsWeb) {
        googleController = ref.watch(GoogleSignInControllerWeb.provider);
      } else {
        googleController = ref.watch(GoogleSignInController.provider);
      }

      return LoginController(
        FirebaseAuth.instance,
        googleController,
        ref.watch(ProfileController.provider),
      );
    },
  );

  /// Sign in with google.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      googleInProgress: true,
    );

    return _googleController.signInWithGoogle().then(
          (googleEither) => googleEither.match(
            (exception) {
              state = state.copyWith(
                googleInProgress: false,
              );
              return false;
            },
            (userCredential) => Task(
              _profileController.userHasProfile,
            ).run().then(
                  (value) => value.match(
                    () => _profileController
                        .createProfileFromUserCredential(
                          userCredential,
                        )
                        .then(
                          (either) => either.match(
                            (e) {
                              state = state.copyWith(
                                googleInProgress: false,
                              );
                              return false;
                            },
                            (value) {
                              state = state.copyWith(
                                googleInProgress: false,
                              );
                              return true;
                            },
                          ),
                        ),
                    () => true,
                  ),
                ),
          ),
        );
  }

  /// Logs in the user with email and password.
  Future<bool> login(LoginData loginData) async {
    state = state.copyWith(
      loginData: loginData,
      loginDataErrors: LoginDataErrors.empty(),
      processingState: ProcessingState.loading,
    );

    final result = await _loginUser(state.loginData);

    return await result.match(
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
      await _auth.signOut();

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

      final userCredential = await _auth.signInWithEmailAndPassword(
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

  /// Resets the password for [email].
  Future<bool> sendResetPassword(String email) async {
    state = state.copyWith(
      loginDataErrors: state.loginDataErrors.copyWith(
        email: '',
      ),
      processingState: ProcessingState.loading,
    );

    if (email.isEmpty) {
      state = state.copyWith(
        loginDataErrors: state.loginDataErrors.copyWith(
          email: 'Email is required',
        ),
        processingState: ProcessingState.loaded,
      );
      return false;
    }

    try {
      final settings = ActionCodeSettings(
        url: 'https://quickreminders.page.link/resetPassword',
        handleCodeInApp: true,
        androidPackageName: 'com.example.quick_reminders',
        androidInstallApp: true,
        dynamicLinkDomain: 'quickreminders.page.link',
      );

      await _auth.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: settings,
      );

      log('Password reset email sent to $email');

      state = state.copyWith(
        processingState: ProcessingState.loaded,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      log('e.code: ${e.code}');
      log('Error resetting password: ${e.message}');

      late final String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email.';
          state = state.copyWith(
            processingState: ProcessingState.loaded,
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'user-not-found':
          message = 'User not found.';
          state = state.copyWith(
            processingState: ProcessingState.loaded,
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
      }

      return false;
    }
  }

  /// Completes the password reset.
  Future<bool> resetPassword(String password, String oobCode) async {
    try {
      await _auth.confirmPasswordReset(code: oobCode, newPassword: password);
      return true;
    } on FirebaseAuthException catch (e) {
      log('Error resetting password: ${e.message}');
      return false;
    }
  }

  /// Returns true if a user is logged in.
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Checks if the current user has their email verified.
  Future<bool> isEmailVerified() async {
    if (_auth.currentUser == null) {
      log('No user is signed in.');
      return false;
    }
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }

  /// Call only if user is logged in.
  bool isEmailVerifiedSync() {
    return _auth.currentUser!.emailVerified;
  }
}
