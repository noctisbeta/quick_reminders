import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
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
    this._auth,
    this._googleController,
    this._profileController,
  ) : super(
          RegistrationState.empty(),
        );

  /// Firebase auth
  final FirebaseAuth _auth;

  /// Google sign in controller.
  final GoogleSignInProtocol _googleController;

  final ProfileController _profileController;

  static final _emailSettings = ActionCodeSettings(
    url: 'https://quickreminders.page.link/verifyEmail',
    handleCodeInApp: true,
    androidPackageName: 'com.example.quick_reminders',
    androidInstallApp: true,
    dynamicLinkDomain: 'quickreminders.page.link',
  );

  /// Provides the controller.
  static final provider = StateNotifierProvider.autoDispose<RegistrationController, RegistrationState>(
    (ref) => RegistrationController(
      FirebaseAuth.instance,
      kIsWeb.match(
        () => ref.watch(GoogleSignInController.provider),
        () => ref.watch(GoogleSignInControllerWeb.provider),
      ),
      ref.watch(ProfileController.provider),
    ),
  );

  /// Registers the user with email and password, then creates a user document in Firestore.
  Future<bool> completeRegistration(RegistrationData registrationData) async => withEffect(
        Task(
          () => _createUser(registrationData),
        ).run().then(
              (either) => either.match(
                (exception) => withEffect(
                  false,
                  () => state = state.copyWith(
                    processingState: ProcessingState.loaded,
                  ),
                ),
                (userCredential) => Option.of(userCredential.user).match(
                  () => withEffect(false, () => Logger().e('User is null')),
                  (user) => _profileController.createProfileFromMap(
                    {
                      'firstName': state.registrationData.firstName,
                      'lastName': state.registrationData.lastName,
                      'email': state.registrationData.email,
                      'uid': userCredential.user!.uid,
                    },
                  ).then(
                    (either) => either.match(
                      (left) => withEffect(
                        false,
                        () => {
                          user.sendEmailVerification(),
                          state = state.copyWith(
                            processingState: ProcessingState.loaded,
                          ),
                        },
                      ),
                      (right) => withEffect(
                        true,
                        () => {
                          user.sendEmailVerification(),
                          state = state.copyWith(
                            processingState: ProcessingState.loaded,
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        () => state = state.copyWith(
          registrationData: registrationData,
          registrationDataErrors: RegistrationDataErrors.empty(),
          processingState: ProcessingState.loading,
        ),
      );

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
  Future<Either<Exception, UserCredential>> _createUser(RegistrationData data) async => Task(
        () => _auth.createUserWithEmailAndPassword(
          email: data.email.trim(),
          password: data.password.trim(),
        ),
      ).attemptEither<FirebaseAuthException>().run().then(
            (either) => either.match(
              (exception) => withEffect(
                Left(exception),
                () {
                  Logger().e('Error creating user: ${exception.message}');
                  final String message;

                  switch (exception.code) {
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
                },
              ),
              Right.new,
            ),
          );

  /// Checks if the current user has their email verified.
  Future<bool> isEmailVerified() async => Option.of(_auth.currentUser).match(
        () => withEffect(false, () => Logger().e('No user logged in')),
        (user) => Task.fromVoid(() => user.reload()).run().then((value) => user.emailVerified),
      );

  /// Sends a verification email to the current user.
  Future<bool> resendEmailVerification() async => Option.of(_auth.currentUser).match(
        () => withEffect(false, () => Logger().e('No user logged in')),
        (user) => withEffect(
          Task.fromVoid(
            () => user.sendEmailVerification(_emailSettings),
          ),
          () => state = state.copyWith(
            processingState: ProcessingState.loading,
          ),
        ).run().then(
              (_) => withEffect(
                true,
                () => state = state.copyWith(
                  processingState: ProcessingState.loaded,
                ),
              ),
            ),
      );
}
