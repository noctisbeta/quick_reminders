import 'package:quick_reminders/authentication/models/registration_data.dart';
import 'package:quick_reminders/authentication/models/registration_data_errors.dart';

/// Registration state.
class RegistrationState {
  /// Default constructor.
  RegistrationState({
    required this.registrationData,
    required this.registrationDataErrors,
  });

  /// Empty constructor.
  RegistrationState.empty()
      : registrationData = RegistrationData.empty(),
        registrationDataErrors = RegistrationDataErrors.empty();

  /// Registration data.
  final RegistrationData registrationData;

  /// Registration data errors.
  final RegistrationDataErrors registrationDataErrors;

  /// Copy with method.
  RegistrationState copyWith({
    RegistrationData? registrationData,
    RegistrationDataErrors? registrationDataErrors,
  }) {
    return RegistrationState(
      registrationData: registrationData ?? this.registrationData,
      registrationDataErrors: registrationDataErrors ?? this.registrationDataErrors,
    );
  }
}
