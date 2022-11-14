import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_controller.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_controller_web.dart';
import 'package:quick_reminders/authentication/controllers/google_sign_in_protocol.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data_errors.dart';
import 'package:quick_reminders/authentication/models/registration/registration_state.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';

/// Firebase authentication controller.
class RegistrationController extends StateNotifier<RegistrationState> {
  /// Default constructor.
  RegistrationController(
    this.ref,
    this._auth,
    this._googleController,
    this._profileController,
  ) : super(
          RegistrationState.empty(),
        );

  /// Riverpod reference.
  final Ref ref;

  /// Firebase auth
  final FirebaseAuth _auth;

  /// Google sign in controller.
  final GoogleSignInProtocol _googleController;

  final ProfileController _profileController;

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<RegistrationController, RegistrationState>(
    (ref) {
      return RegistrationController(
        ref,
        FirebaseAuth.instance,
        kIsWeb.match(
          () => ref.watch(GoogleSignInController.provider),
          () => ref.watch(GoogleSignInControllerWeb.provider),
        ),
        ref.watch(ProfileController.provider),
      );
    },
  );

  /// Registers the user with email and password, then creates a user document in Firestore.
  Future<bool> completeRegistration(RegistrationData registrationData) async {
    state = state.copyWith(
      registrationData: registrationData,
      registrationDataErrors: RegistrationDataErrors.empty(),
      processingState: ProcessingState.loading,
    );

    final result = await _createUser(state.registrationData);

    return await result.match(
      (exception) {
        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );
        return false;
      },
      (userCredential) async {
        log('User created: ${userCredential.user!.uid}');

        final profileData = {
          'firstName': state.registrationData.firstName,
          'lastName': state.registrationData.lastName,
          'email': state.registrationData.email,
          'uid': userCredential.user!.uid,
        };

        final settings = ActionCodeSettings(
          url: 'https://quickreminders.page.link/verifyEmail',
          handleCodeInApp: true,
          androidPackageName: 'com.example.quick_reminders',
          androidInstallApp: true,
          dynamicLinkDomain: 'quickreminders.page.link',
        );

        final List results = await Future.wait([
          userCredential.user!.sendEmailVerification(
            settings,
          ),
          ref.read(ProfileController.provider).createProfileFromMap(profileData),
        ]);

        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );

        /// createProfile result
        return results[1];
      },
    );
  }

  /// Sign in with google.
  Future<bool> signInWithGoogle() async => withEffect(
        _googleController.signInWithGoogle().then(
              (either) => either.match(
                (exception) => withEffect(
                  false,
                  () {
                    state = state.copyWith(
                      googleInProgress: false,
                    );
                  },
                ),
                (userCredential) => _profileController.userHasProfile().then(
                      (value) => value.match(
                        () => _profileController.createProfileFromUserCredential(userCredential).then(
                              (either) => either.match(
                                (exception) => withEffect(
                                  false,
                                  () {
                                    state = state.copyWith(
                                      googleInProgress: false,
                                    );
                                  },
                                ),
                                (value) => withEffect(
                                  true,
                                  () {
                                    state = state.copyWith(
                                      googleInProgress: false,
                                    );
                                  },
                                ),
                              ),
                            ),
                        () => true,
                      ),
                    ),
              ),
            ),
        () => state = state.copyWith(
          googleInProgress: true,
        ),
      );

  /// Creates a user with email and password.
  Future<Either<Exception, UserCredential>> _createUser(RegistrationData data) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.email.trim(),
        password: data.password.trim(),
      );

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      log('Error creating user: ${e.message}');

      late final String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email already in use.';
          state = state.copyWith(
            registrationDataErrors: state.registrationDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'invalid-email':
          message = 'Invalid email.';
          state = state.copyWith(
            registrationDataErrors: state.registrationDataErrors.copyWith(
              email: message,
            ),
          );
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed.';
          state = state.copyWith(
            registrationDataErrors: state.registrationDataErrors.copyWith(
              email: message,
              firstName: message,
              lastName: message,
              password: message,
            ),
          );
          break;
        case 'weak-password':
          message = 'Weak password.';
          state = state.copyWith(
            registrationDataErrors: state.registrationDataErrors.copyWith(
              password: message,
            ),
          );
          break;
      }
      return Left(e);
    }
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

  /// Sends a verification email to the current user.
  Future<bool> resendEmailVerification() async {
    if (_auth.currentUser == null) {
      log('No user is signed in.');
      return false;
    }
    state = state.copyWith(
      processingState: ProcessingState.loading,
    );

    final settings = ActionCodeSettings(
      url: 'https://quickreminders.page.link/verifyEmail',
      handleCodeInApp: true,
      androidPackageName: 'com.example.quick_reminders',
      androidInstallApp: true,
      dynamicLinkDomain: 'quickreminders.page.link',
    );

    try {
      await _auth.currentUser!.sendEmailVerification(
        settings,
      );
      state = state.copyWith(
        processingState: ProcessingState.loaded,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log('Error sending verification email: ${e.message}');
      state = state.copyWith(
        processingState: ProcessingState.loaded,
      );
      return false;
    }
  }
}
