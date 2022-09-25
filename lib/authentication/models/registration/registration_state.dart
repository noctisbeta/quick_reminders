import 'package:quick_reminders/authentication/models/processing_state.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data.dart';
import 'package:quick_reminders/authentication/models/registration/registration_data_errors.dart';

/// Registration state.
class RegistrationState {
  /// Default constructor.
  RegistrationState({
    required this.registrationData,
    required this.registrationDataErrors,
    required this.processingState,
  });

  /// Empty constructor.
  RegistrationState.empty()
      : registrationData = RegistrationData.empty(),
        registrationDataErrors = RegistrationDataErrors.empty(),
        processingState = ProcessingState.loaded;

  /// Registration data.
  final RegistrationData registrationData;

  /// Registration data errors.
  final RegistrationDataErrors registrationDataErrors;

  /// Processing state.
  final ProcessingState processingState;

  /// True if the state is loading.
  bool get isLoading => processingState == ProcessingState.loading;

  /// Copy with method.
  RegistrationState copyWith({
    RegistrationData? registrationData,
    RegistrationDataErrors? registrationDataErrors,
    ProcessingState? processingState,
  }) {
    return RegistrationState(
      registrationData: registrationData ?? this.registrationData,
      registrationDataErrors: registrationDataErrors ?? this.registrationDataErrors,
      processingState: processingState ?? this.processingState,
    );
  }
}
