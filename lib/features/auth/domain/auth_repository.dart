import 'models/user.dart';

abstract interface class AuthRepository {
  /// Sign in with email + password. Returns the authenticated [User].
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Register a new account.
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  /// Exchange an OAuth authorization code for a session.
  Future<User> handleOAuthCallback({
    required String provider,
    required String code,
  });

  /// Sign out and clear local tokens.
  Future<void> signOut();

  /// Returns the currently authenticated user, or null.
  Future<User?> getCurrentUser();

  /// Stream that emits the current [User] whenever auth state changes.
  Stream<User?> get authStateChanges;
}
