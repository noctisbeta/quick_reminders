import 'package:quick_reminders/authentication/models/login/login_data.dart';
import 'package:quick_reminders/authentication/models/login/login_data_errors.dart';
import 'package:quick_reminders/authentication/models/processing_state.dart';

/// Login state.
class LoginState {
  /// Default constructor.
  LoginState({
    required this.loginData,
    required this.loginDataErrors,
    required this.processingState,
    required this.googleInProgress,
  });

  /// Empty constructor.
  LoginState.empty()
      : loginData = LoginData.empty(),
        loginDataErrors = LoginDataErrors.empty(),
        processingState = ProcessingState.loaded,
        googleInProgress = false;

  /// Registration data.
  final LoginData loginData;

  /// Registration data errors.
  final LoginDataErrors loginDataErrors;

  /// Processing state.
  final ProcessingState processingState;

  /// Whether the Google sign in is in progress.
  final bool googleInProgress;

  /// True if the state is loading.
  bool get isLoading => processingState == ProcessingState.loading;

  /// Copy with method.
  LoginState copyWith({
    LoginData? loginData,
    LoginDataErrors? loginDataErrors,
    ProcessingState? processingState,
    bool? googleInProgress,
  }) {
    return LoginState(
      loginData: loginData ?? this.loginData,
      loginDataErrors: loginDataErrors ?? this.loginDataErrors,
      processingState: processingState ?? this.processingState,
      googleInProgress: googleInProgress ?? this.googleInProgress,
    );
  }
}
