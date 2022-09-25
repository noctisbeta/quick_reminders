/// Encapsulates the registration data.
class LoginData {
  /// Default constructor.
  LoginData({
    required this.email,
    required this.password,
  });

  /// Fills with empty fields.
  LoginData.empty()
      : email = '',
        password = '';

  /// Email.
  String email;

  /// Password.
  String password;
}
