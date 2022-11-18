import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/google/google_sign_in_controller.dart';
import 'package:quick_reminders/authentication/controllers/google/google_sign_in_controller_web.dart';
import 'package:quick_reminders/authentication/controllers/google/google_sign_in_protocol.dart';
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
  static final provider =
      StateNotifierProvider.autoDispose<LoginController, LoginState>(
    (ref) => LoginController(
      FirebaseAuth.instance,
      kIsWeb.match(
        ifFalse: () => ref.watch(GoogleSignInController.provider),
        ifTrue: () => ref.watch(GoogleSignInControllerWeb.provider),
      ),
      ref.watch(ProfileController.provider),
    ),
  );

  /// Sign in with google.
  Future<bool> signInWithGoogle() async => withEffect(
        _googleController.signInWithGoogle().then(
              (googleEither) => googleEither.match(
                (exception) => withEffect(
                  false,
                  () => state =
                      state.copyWith(processingState: ProcessingState.idle),
                ),
                (userCredential) => Task(
                  _profileController.userHasProfile,
                ).run().then(
                      (value) => value.match(
                        ifFalse: () => _profileController
                            .createProfileFromUserCredential(
                              userCredential,
                            )
                            .then(
                              (either) => either.match(
                                (exception) => withEffect(
                                  false,
                                  () => state = state.copyWith(
                                    processingState: ProcessingState.idle,
                                  ),
                                ),
                                (success) => withEffect(
                                  true,
                                  () => state = state.copyWith(
                                    processingState: ProcessingState.idle,
                                  ),
                                ),
                              ),
                            ),
                        ifTrue: () => withEffect(
                          true,
                          () => state = state.copyWith(
                            processingState: ProcessingState.idle,
                          ),
                        ),
                      ),
                    ),
              ),
            ),
        () => state = state.copyWith(
          processingState: ProcessingState.googleLoading,
        ),
      );

  /// Logs in the user with email and password.
  Future<bool> login(LoginData loginData) async => withEffect(
        Task(
          () => _loginUser(loginData),
        ).run().then(
              (either) => withEffect(
                either.match(
                  (left) => false,
                  (right) => true,
                ),
                () => state = state.copyWith(
                  processingState: ProcessingState.idle,
                ),
              ),
            ),
        () => state = state.copyWith(
          loginData: loginData,
          loginDataErrors: LoginDataErrors.empty(),
          processingState: ProcessingState.loginLoading,
        ),
      );

  /// Logs in the user with email and password.
  Future<Either<Exception, UserCredential>> _loginUser(
    LoginData loginData,
  ) async {
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
    } on FirebaseAuthException catch (e, s) {
      Logger().e('Error loging in user: ${e.message}', e, s);

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
      processingState: ProcessingState.loginLoading,
    );

    if (email.isEmpty) {
      state = state.copyWith(
        loginDataErrors: state.loginDataErrors.copyWith(
          email: 'Email is required',
        ),
        processingState: ProcessingState.idle,
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

      Logger().i('Password reset email sent to $email');

      state = state.copyWith(
        processingState: ProcessingState.idle,
      );

      return true;
    } on FirebaseAuthException catch (e, s) {
      Logger().e('Error resetting password: ${e.message}', e, s);

      late final String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email.';
          state = state.copyWith(
            processingState: ProcessingState.idle,
            loginDataErrors: state.loginDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'user-not-found':
          message = 'User not found.';
          state = state.copyWith(
            processingState: ProcessingState.idle,
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
  Future<bool> resetPassword(String password, String oobCode) async =>
      Task.fromVoid(
        () => _auth.confirmPasswordReset(
          code: oobCode,
          newPassword: password,
        ),
      ).attemptEither<FirebaseAuthException>().run().then(
            (either) => either.match(
              (exception) => withEffect(
                false,
                () => Logger()
                    .e('Error resetting password: ${exception.message}'),
              ),
              (unit) => true,
            ),
          );

  /// Returns true if a user is logged in.
  bool isUserLoggedIn() => _auth.currentUser != null;

  /// Call only if user is logged in.
  bool isEmailVerified() => _auth.currentUser!.emailVerified;
}
