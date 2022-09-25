/// Encapsulates the registration data.
class LoginDataErrors {
  /// Default constructor.
  LoginDataErrors({
    required this.email,
    required this.password,
  });

  /// Fills with empty fields.
  LoginDataErrors.empty()
      : email = '',
        password = '';

  /// Email.
  String email;

  /// Password.
  String password;

  /// Copy with method.
  LoginDataErrors copyWith({
    String? email,
    String? password,
  }) {
    return LoginDataErrors(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
