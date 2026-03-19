import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/auth_remote_datasource.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/models/user.dart';

part 'auth_provider.g.dart';

/// Auth session state.
class AuthSession {
  const AuthSession({this.user, this.isLoading = false, this.error});

  final User? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthSession copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) =>
      AuthSession(
        user: clearUser ? null : (user ?? this.user),
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );
}

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<AuthSession> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final user = await repo.getCurrentUser();
    return AuthSession(user: user);
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final user =
          await repo.signInWithEmail(email: email, password: password);
      return AuthSession(user: user);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final user = await repo.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      return AuthSession(user: user);
    });
  }

  Future<void> signInWithOAuth({
    required String provider,
    required String code,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final user =
          await repo.handleOAuthCallback(provider: provider, code: code);
      return AuthSession(user: user);
    });
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    state = const AsyncData(AuthSession());
  }
}

/// Manages password-reset request flow (stateless — just AsyncValue<void>).
@riverpod
class PasswordResetRequest extends _$PasswordResetRequest {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> sendResetEmail(String email) async {
    state = const AsyncLoading();
    final ds = ref.read(authRemoteDataSourceProvider);
    state = await AsyncValue.guard(
      () => ds.requestPasswordReset(email: email),
    );
  }
}

/// Manages the "confirm new password" step.
@riverpod
class PasswordResetConfirm extends _$PasswordResetConfirm {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> confirm({
    required String token,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final ds = ref.read(authRemoteDataSourceProvider);
    state = await AsyncValue.guard(
      () => ds.confirmPasswordReset(token: token, newPassword: newPassword),
    );
  }
}

/// Manages profile update.
@riverpod
class ProfileUpdate extends _$ProfileUpdate {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> save({
    String? displayName,
    String? avatarUrl,
    String? statusText,
    String? statusEmoji,
    String? timezone,
  }) async {
    state = const AsyncLoading();
    final ds = ref.read(authRemoteDataSourceProvider);
    state = await AsyncValue.guard(() async {
      await ds.updateProfile(
        displayName: displayName,
        avatarUrl: avatarUrl,
        statusText: statusText,
        statusEmoji: statusEmoji,
        timezone: timezone,
      );
      // Refresh auth state so router + UI pick up updated user.
      ref.invalidate(authStateProvider);
    });
  }
}
