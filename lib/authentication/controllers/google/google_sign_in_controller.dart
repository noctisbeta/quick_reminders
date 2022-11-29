import 'package:firebase_auth/firebase_auth.dart';
import 'package:functional/functional.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:quick_reminders/authentication/controllers/google/google_sign_in_protocol.dart';
import 'package:quick_reminders/authentication/models/google_sign_in_exception.dart';

/// Google sign in controller.
class GoogleSignInController implements GoogleSignInProtocol {
  /// Default constructor.
  GoogleSignInController(this._auth);

  /// Auth.
  final FirebaseAuth _auth;

  /// Provides the controller.
  static final provider = Provider.autoDispose<GoogleSignInController>(
    (ref) => GoogleSignInController(
      FirebaseAuth.instance,
    ),
  );

  @override
  Future<Either<GoogleSignInException, UserCredential>>
      signInWithGoogle() async => Task.fromNullable(
            () => GoogleSignIn().signIn(),
          ).run().then(
                (value) => value.match(
                  none: () => tap(
                    tapped: const Left(
                      GoogleSignInException('Error signing in with Google.'),
                    ),
                    effect: () => Logger().e(
                      'Error signing in with Google.',
                      'error',
                      StackTrace.current,
                    ),
                  ),
                  some: (account) => account.authentication.then(
                    (googleAuth) => Task(
                      () => _auth.signInWithCredential(
                        GoogleAuthProvider.credential(
                          idToken: googleAuth.idToken,
                          accessToken: googleAuth.accessToken,
                        ),
                      ),
                    ).attempt<FirebaseAuthMultiFactorException>().run().then(
                          (value) => value.match(
                            (exception) => tap(
                              tapped: Left(
                                GoogleSignInException(
                                  exception.message ??
                                      'Error signing in with Google.',
                                ),
                              ),
                              effect: () => Logger().e(
                                'Error signing in with Google.',
                                exception,
                                StackTrace.current,
                              ),
                            ),
                            (credential) => tap(
                              tapped: Right(credential),
                              effect: () =>
                                  Logger().i('Signed in with Google.'),
                            ),
                          ),
                        ),
                  ),
                ),
              );
}
