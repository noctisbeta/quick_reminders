/// Encapsulates the registration data.
class RegistrationDataErrors {
  /// Default constructor.
  RegistrationDataErrors({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// Fills with empty fields.
  RegistrationDataErrors.empty()
      : firstName = '',
        lastName = '',
        email = '',
        password = '';

  /// First name.
  String firstName;

  /// Last name.
  String lastName;

  /// Email.
  String email;

  /// Password.
  String password;

  /// Copy with method.
  RegistrationDataErrors copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) {
    return RegistrationDataErrors(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
