/// Google Sign In Exception
class GoogleSignInException implements Exception {
  /// Default constructor.
  const GoogleSignInException(this.message);

  /// Message.
  final String message;

  @override
  String toString() => message;
}
