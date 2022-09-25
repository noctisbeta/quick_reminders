import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/authentication/models/registration_data.dart';
import 'package:quick_reminders/authentication/models/registration_data_errors.dart';
import 'package:quick_reminders/authentication/models/registration_state.dart';

/// Firebase authentication controller.
class AuthenticationController extends StateNotifier<RegistrationState> {
  /// Default constructor.
  AuthenticationController()
      : super(
          RegistrationState.empty(),
        );

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<AuthenticationController, RegistrationState>(
    (ref) => AuthenticationController(),
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

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
        final List results = await Future.wait([
          userCredential.user!.sendEmailVerification(),
          _createProfile(userCredential),
        ]);

        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );

        return results[1];
      },
    );
  }

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

  /// Creates a user document in firestore.
  Future<bool> _createProfile(UserCredential userCredential) async {
    final user = {
      'firstName': state.registrationData.firstName,
      'lastName': state.registrationData.lastName,
      'email': state.registrationData.email,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('users').doc(userCredential.user!.uid).set(
            user,
            SetOptions(merge: true),
          );

      log('Profile created: $user');
      return true;
    } on FirebaseException catch (e) {
      log('Error creating profile: ${e.message}');
      return false;
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
}
