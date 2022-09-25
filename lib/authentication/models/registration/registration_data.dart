/// Encapsulates the registration data.
class RegistrationData {
  /// Default constructor.
  RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// Fills with empty fields.
  RegistrationData.empty()
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
}
