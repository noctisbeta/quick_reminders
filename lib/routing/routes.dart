/// Route information.
// ignore_for_file: public_member_api_docs

enum Routes {
  authentication,
  login,
  sendResetPassword,
  sendResetPasswordSuccessful,
  signUp,
  verify,
  verified,
  resetPassword,
  resetPasswordSuccessful,
  home,
  profile,
  loading,
  error,
  reminderGroups;

  /// Returns the route's name.
  String get name {
    switch (this) {
      case authentication:
        return 'authentication';
      case login:
        return 'login';
      case sendResetPassword:
        return 'sendResetPassword';
      case sendResetPasswordSuccessful:
        return 'sendResetPasswordSuccessful';
      case signUp:
        return 'signUp';
      case verify:
        return 'verify';
      case verified:
        return 'verified';
      case resetPassword:
        return 'resetPassword';
      case resetPasswordSuccessful:
        return 'resetPasswordSuccessful';
      case home:
        return 'home';
      case profile:
        return 'profile';
      case loading:
        return 'loading';
      case error:
        return 'error';
      case reminderGroups:
        return 'reminderGroups';
    }
  }

  String get path {
    switch (this) {
      case authentication:
        return '/authentication';
      case login:
        return '/login';
      case sendResetPassword:
        return '/sendResetPassword';
      case sendResetPasswordSuccessful:
        return '/sendResetPasswordSuccessful';
      case signUp:
        return '/signUp';
      case verify:
        return '/verify';
      case verified:
        return '/verified';
      case resetPassword:
        return '/resetPassword';
      case resetPasswordSuccessful:
        return '/resetPasswordSuccessful';
      case home:
        return '/home';
      case profile:
        return '/profile';
      case loading:
        return '/loading';
      case error:
        return '/error';
      case reminderGroups:
        return '/reminderGroups';
    }
  }

  String get subPath {
    switch (this) {
      case authentication:
        return 'authentication';
      case login:
        return 'login';
      case sendResetPassword:
        return 'sendResetPassword';
      case sendResetPasswordSuccessful:
        return 'sendResetPasswordSuccessful';
      case signUp:
        return 'signUp';
      case verify:
        return 'verify';
      case verified:
        return 'verified';
      case resetPassword:
        return 'resetPassword';
      case resetPasswordSuccessful:
        return 'resetPasswordSuccessful';
      case home:
        return 'home';
      case profile:
        return 'profile';
      case loading:
        return 'loading';
      case error:
        return 'error';
      case reminderGroups:
        return 'reminderGroups';
    }
  }
}
