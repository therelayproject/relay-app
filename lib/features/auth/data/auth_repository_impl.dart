import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/secure_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/models/user.dart';
import 'auth_remote_datasource.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      remote: ref.watch(authRemoteDataSourceProvider),
      storage: ref.watch(secureStorageProvider),
    );

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.storage});

  final AuthRemoteDataSource remote;
  final RelaySecureStorage storage;

  final _authStateController = StreamController<User?>.broadcast();

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await remote.signInWithEmail(
      email: email,
      password: password,
    );
    await storage.writeTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    _authStateController.add(result.user);
    return result.user;
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final result = await remote.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
    await storage.writeTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    _authStateController.add(result.user);
    return result.user;
  }

  @override
  Future<User> handleOAuthCallback({
    required String provider,
    required String code,
  }) async {
    final result =
        await remote.handleOAuthCallback(provider: provider, code: code);
    await storage.writeTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    _authStateController.add(result.user);
    return result.user;
  }

  @override
  Future<void> signOut() async {
    await storage.clearTokens();
    _authStateController.add(null);
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await storage.readAccessToken();
    if (token == null) return null;
    return remote.getCurrentUser();
  }
}
