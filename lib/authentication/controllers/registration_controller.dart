import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/controllers/google_controller.dart';
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
    this.auth,
    this.db,
  ) : super(
          RegistrationState.empty(),
        );

  /// Riverpod reference.
  final Ref ref;

  /// Firebase auth
  final FirebaseAuth auth;

  /// Firestore db.
  final FirebaseFirestore db;

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<RegistrationController, RegistrationState>(
    (ref) => RegistrationController(
      ref,
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    ),
  );

  /// Registers the user with email and password, then creates a user document in Firestore.
  Future<bool> completeRegistration(RegistrationData registrationData) async {
    state = state.copyWith(
      registrationData: registrationData,
      registrationDataErrors: RegistrationDataErrors.empty(),
      processingState: ProcessingState.loading,
    );

    final result = await _createUser(state.registrationData);

    return await result.fold(
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

  /// Creates a user with email and password.
  Future<Either<Exception, UserCredential>> _createUser(RegistrationData data) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
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
    if (auth.currentUser == null) {
      log('No user is signed in.');
      return false;
    }
    await auth.currentUser!.reload();
    return auth.currentUser!.emailVerified;
  }

  /// Sends a verification email to the current user.
  Future<bool> resendEmailVerification() async {
    if (auth.currentUser == null) {
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
      await auth.currentUser!.sendEmailVerification(
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
