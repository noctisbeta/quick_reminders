import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Google sign in controller.
class GoogleController {
  /// Provides the controller.
  static final provider = Provider.autoDispose<GoogleController>(
    (ref) => GoogleController(),
  );

  /// Sign in with google and return the account if successful.
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      // await googleSignIn.disconnect();

      final account = await googleSignIn.signIn();

      return account;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log('Error signing in with Google: $e');
      return null;
    }
  }
}
