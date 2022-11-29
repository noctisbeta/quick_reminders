import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/google/google_sign_in_protocol.dart';
import 'package:quick_reminders/authentication/models/google_sign_in_exception.dart';

/// Google sign in controller.
class GoogleSignInControllerWeb implements GoogleSignInProtocol {
  /// Default constructor.
  const GoogleSignInControllerWeb(this._auth);

  /// Auth.
  final FirebaseAuth _auth;

  /// Provides the controller.
  static final provider = Provider.autoDispose<GoogleSignInControllerWeb>(
    (ref) => GoogleSignInControllerWeb(FirebaseAuth.instance),
  );

  @override
  Future<Either<GoogleSignInException, UserCredential>>
      signInWithGoogle() async => Task(
            () => _auth.signInWithPopup(
              GoogleAuthProvider(),
            ),
          ).attempt<FirebaseAuthMultiFactorException>().run().then(
                (either) => either.match(
                  (exception) => tap(
                    tapped: Left(
                      GoogleSignInException(
                        exception.message ??
                            'Error signing in with Google on web.',
                      ),
                    ),
                    effect: () => Logger().e(
                      'Error signing in with Google on web.',
                      exception,
                      StackTrace.current,
                    ),
                  ),
                  (credential) => tap(
                    tapped: Right(credential),
                    effect: () => Logger().i('Signed in with Google on web.'),
                  ),
                ),
              );
}
