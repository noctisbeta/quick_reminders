import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/authentication/models/login/login_data_errors.dart';
import 'package:quick_reminders/authentication/models/login/login_state.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';

/// Login controller.
class LoginController extends StateNotifier<LoginState> {
  /// Default constructor.
  LoginController(this.ref)
      : super(
          LoginState.empty(),
        );

  /// Riverpod reference.
  final Ref ref;

  /// Provides the controller.
  static final provider = StateNotifierProvider<LoginController, LoginState>(
    LoginController.new,
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Sign in with google.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      loginData: LoginData.empty(),
      loginDataErrors: LoginDataErrors.empty(),
      processingState: ProcessingState.loading,
    );

    final result = await _signInWithGoogle();

    return await result.fold(
      (exception) {
        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );
        return false;
      },
      (account) async {
        log('User signed in to google: ${account.email}');

        final googleAuth = await account.authentication;

        final userCredential = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );

        final bool result = await _createProfile(userCredential);

        state = state.copyWith(
          processingState: ProcessingState.loaded,
        );

        return result;
      },
    );
  }

  /// Sign in with google private
  Future<Either<Exception, GoogleSignInAccount>> _signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      await _auth.signOut();

      final account = await googleSignIn.signIn();

      // sign in was aborted
      if (account == null) {
        return Left(Exception('Sign in aborted'));
      }

      return Right(account);
    } on FirebaseAuthException catch (e) {
      log('Error signing in with Google: ${e.message}');
      return Left(e);
    }
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

  Future<bool> _createProfile(UserCredential userCredential) async {
    final user = {
      'firstName': userCredential.user!.displayName!.split(' ')[0],
      'lastName': userCredential.user!.displayName!.split(' ')[1],
      'email': userCredential.user!.email,
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
}
