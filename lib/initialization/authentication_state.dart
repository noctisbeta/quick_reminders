/// The authentication state.
enum AuthenticationState {
  /// If the user is logged in.
  loggedIn,

  /// If the user is logged in and their email is verified.
  loggedInAndVerified,

  /// If the user is logged out.
  loggedOut,
}
