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
  });

  /// Empty constructor.
  LoginState.empty()
      : loginData = LoginData.empty(),
        loginDataErrors = LoginDataErrors.empty(),
        processingState = ProcessingState.idle;

  /// Registration data.
  final LoginData loginData;

  /// Registration data errors.
  final LoginDataErrors loginDataErrors;

  /// Processing state.
  final ProcessingState processingState;

  /// True if the google sign in is loading.
  bool get googleInProgress => processingState == ProcessingState.googleLoading;

  /// True if the login is loading.
  bool get isLoading => processingState == ProcessingState.loginLoading;

  /// Copy with method.
  LoginState copyWith({
    LoginData? loginData,
    LoginDataErrors? loginDataErrors,
    ProcessingState? processingState,
  }) {
    return LoginState(
      loginData: loginData ?? this.loginData,
      loginDataErrors: loginDataErrors ?? this.loginDataErrors,
      processingState: processingState ?? this.processingState,
    );
  }
}
