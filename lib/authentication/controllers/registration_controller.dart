import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:functional/functional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data_errors.dart';
import 'package:quick_reminders/authentication/models/registration/registration_state.dart';
import 'package:quick_reminders/logging/log_profile.dart';
import 'package:quick_reminders/profile/controllers/profile_controller.dart';
import 'package:riverpod_firebase_authentication/riverpod_firebase_authentication.dart';

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
  static final provider = StateNotifierProvider.autoDispose<
      RegistrationController, RegistrationState>(
    (ref) => RegistrationController(
      FirebaseAuth.instance,
      kIsWeb.match(
        ifFalse: () => ref.watch(GoogleSignInController.provider),
        ifTrue: () => ref.watch(GoogleSignInControllerWeb.provider),
      ),
      ref.watch(ProfileController.provider),
    ),
  );

  /// Registers the user with email and password, then creates a user document
  /// in Firestore.
  Future<bool> completeRegistration(RegistrationData registrationData) async =>
      tap(
        tapped: Task(
          () => _createUser(registrationData),
        ).run().then(
              (either) => either.match(
                (exception) => tap(
                  tapped: false,
                  effect: () => state = state.copyWith(
                    processingState: ProcessingState.idle,
                  ),
                ),
                (userCredential) => Option.of(userCredential.user).match(
                  none: () => tap(
                    tapped: false,
                    effect: () => myLog.e('User is null'),
                  ),
                  some: (user) => _profileController.createProfileFromMap(
                    {
                      'firstName': state.registrationData.firstName,
                      'lastName': state.registrationData.lastName,
                      'email': state.registrationData.email,
                      'uid': userCredential.user!.uid,
                    },
                  ).then(
                    (either) => either.match(
                      (left) => tap(
                        tapped: false,
                        effect: () => {
                          user.sendEmailVerification(),
                          state = state.copyWith(
                            processingState: ProcessingState.idle,
                          ),
                        },
                      ),
                      (right) => tap(
                        tapped: true,
                        effect: () => {
                          user.sendEmailVerification(),
                          state = state.copyWith(
                            processingState: ProcessingState.idle,
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        effect: () => state = state.copyWith(
          registrationData: registrationData,
          registrationDataErrors: RegistrationDataErrors.empty(),
          processingState: ProcessingState.loginLoading,
        ),
      );

  void _setProcessingState(ProcessingState processingState) =>
      state = state.copyWith(processingState: processingState);

  /// Signs the user in with google.
  AsyncResult<Exception, Unit> signInWithGoogle() => tap(
        effect: () => _setProcessingState(ProcessingState.googleLoading),
        tapped: _googleController.signInWithGoogle(),
      )
          .mapEitherLeft((exception) => Exception(exception.message))
          .bindEither(_maybeCreateProfile)
          .peek((_) => _setProcessingState(ProcessingState.idle));

  /// Creates a profile if the current user does not have one yet, otherwise
  /// does nothing.
  AsyncResult<Exception, Unit> _maybeCreateProfile(
    UserCredential userCredential,
  ) =>
      _profileController.userHasProfile().bindEither(
            (hasProfile) => hasProfile.match(
              ifFalse: () => _profileController.createProfileFromUserCredential(
                userCredential,
              ),
              ifTrue: () => Task.value(const Right(unit)),
            ),
          );

  /// Creates a user with email and password.
  Future<Either<Exception, UserCredential>> _createUser(
    RegistrationData data,
  ) async =>
      Task(
        () => _auth.createUserWithEmailAndPassword(
          email: data.email.trim(),
          password: data.password.trim(),
        ),
      ).attempt<FirebaseAuthException>().run().then(
            (either) => either.match(
              (exception) => tap(
                tapped: Left(exception),
                effect: () {
                  myLog.e('Error creating user: ${exception.message}');
                  final String message;

                  switch (exception.code) {
                    case 'email-already-in-use':
                      message = 'Email already in use.';
                      state = state.copyWith(
                        registrationDataErrors:
                            state.registrationDataErrors.copyWith(
                          email: message,
                        ),
                      );
                      break;
                    case 'invalid-email':
                      message = 'Invalid email.';
                      state = state.copyWith(
                        registrationDataErrors:
                            state.registrationDataErrors.copyWith(
                          email: message,
                        ),
                      );
                      break;
                    case 'operation-not-allowed':
                      message = 'Operation not allowed.';
                      state = state.copyWith(
                        registrationDataErrors:
                            state.registrationDataErrors.copyWith(
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
                        registrationDataErrors:
                            state.registrationDataErrors.copyWith(
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
        none: () =>
            tap(tapped: false, effect: () => myLog.e('No user logged in')),
        some: (user) => Task.fromVoid(() => user.reload())
            .run()
            .then((value) => user.emailVerified),
      );

  /// Sends a verification email to the current user.
  Future<bool> resendEmailVerification() async =>
      Option.of(_auth.currentUser).match(
        none: () =>
            tap(tapped: false, effect: () => myLog.e('No user logged in')),
        some: (user) => tap(
          tapped: Task.fromVoid(
            () => user.sendEmailVerification(_emailSettings),
          ),
          effect: () => state = state.copyWith(
            processingState: ProcessingState.loginLoading,
          ),
        ).run().then(
              (_) => tap(
                tapped: true,
                effect: () => state = state.copyWith(
                  processingState: ProcessingState.idle,
                ),
              ),
            ),
      );
}
