import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/core/storage/secure_storage.dart';
import 'package:relay/features/auth/data/auth_remote_datasource.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/models/user.dart';

import '../../helpers/test_helpers.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockRelaySecureStorage extends Mock implements RelaySecureStorage {}

// ---------------------------------------------------------------------------
// Shared fixture
// ---------------------------------------------------------------------------

const _accessToken = 'access-tok';
const _refreshToken = 'refresh-tok';

({User user, String accessToken, String refreshToken}) _authResult(User user) =>
    (user: user, accessToken: _accessToken, refreshToken: _refreshToken);

void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockRelaySecureStorage mockStorage;
  late AuthRepositoryImpl repo;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockStorage = MockRelaySecureStorage();
    repo = AuthRepositoryImpl(remote: mockRemote, storage: mockStorage);

    // Default: storage always writes / clears successfully.
    when(
      () => mockStorage.writeTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockStorage.clearTokens()).thenAnswer((_) async {});
  });

  // -------------------------------------------------------------------------
  // signInWithEmail
  // -------------------------------------------------------------------------

  group('signInWithEmail', () {
    test('returns user on success', () async {
      when(
        () => mockRemote.signInWithEmail(
          email: 'alice@example.com',
          password: 'secret',
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      final user = await repo.signInWithEmail(
        email: 'alice@example.com',
        password: 'secret',
      );

      expect(user, kTestUser);
    });

    test('writes tokens to storage after successful sign-in', () async {
      when(
        () => mockRemote.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      await repo.signInWithEmail(
        email: 'alice@example.com',
        password: 'secret',
      );

      verify(
        () => mockStorage.writeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
        ),
      ).called(1);
    });

    test('emits user on authStateChanges after sign-in', () async {
      when(
        () => mockRemote.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      expect(repo.authStateChanges, emitsInOrder([kTestUser]));

      await repo.signInWithEmail(
        email: 'alice@example.com',
        password: 'secret',
      );
    });

    test('propagates exception from remote', () async {
      when(
        () => mockRemote.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Network error'));

      await expectLater(
        () => repo.signInWithEmail(email: 'a@b.com', password: 'x'),
        throwsException,
      );
    });
  });

  // -------------------------------------------------------------------------
  // signUp
  // -------------------------------------------------------------------------

  group('signUp', () {
    test('returns user on success', () async {
      when(
        () => mockRemote.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          displayName: any(named: 'displayName'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      final user = await repo.signUp(
        email: 'alice@example.com',
        password: 'secret',
        displayName: 'Alice',
      );

      expect(user, kTestUser);
    });

    test('writes tokens after successful sign-up', () async {
      when(
        () => mockRemote.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          displayName: any(named: 'displayName'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      await repo.signUp(
        email: 'alice@example.com',
        password: 'secret',
        displayName: 'Alice',
      );

      verify(
        () => mockStorage.writeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
        ),
      ).called(1);
    });
  });

  // -------------------------------------------------------------------------
  // handleOAuthCallback
  // -------------------------------------------------------------------------

  group('handleOAuthCallback', () {
    test('returns user on successful OAuth exchange', () async {
      when(
        () => mockRemote.handleOAuthCallback(
          provider: any(named: 'provider'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      final user = await repo.handleOAuthCallback(
        provider: 'google',
        code: 'auth-code',
      );

      expect(user, kTestUser);
    });

    test('writes tokens on successful OAuth exchange', () async {
      when(
        () => mockRemote.handleOAuthCallback(
          provider: any(named: 'provider'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => _authResult(kTestUser));

      await repo.handleOAuthCallback(provider: 'github', code: 'gh-code');

      verify(
        () => mockStorage.writeTokens(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
        ),
      ).called(1);
    });
  });

  // -------------------------------------------------------------------------
  // signOut
  // -------------------------------------------------------------------------

  group('signOut', () {
    test('clears tokens from storage', () async {
      await repo.signOut();

      verify(() => mockStorage.clearTokens()).called(1);
    });

    test('emits null on authStateChanges after sign-out', () async {
      expect(repo.authStateChanges, emitsInOrder([null]));

      await repo.signOut();
    });
  });

  // -------------------------------------------------------------------------
  // getCurrentUser
  // -------------------------------------------------------------------------

  group('getCurrentUser', () {
    test('returns null when no access token is stored', () async {
      when(() => mockStorage.readAccessToken()).thenAnswer((_) async => null);

      final user = await repo.getCurrentUser();

      expect(user, isNull);
    });

    test('fetches user from remote when access token exists', () async {
      when(() => mockStorage.readAccessToken())
          .thenAnswer((_) async => _accessToken);
      when(() => mockRemote.getCurrentUser()).thenAnswer((_) async => kTestUser);

      final user = await repo.getCurrentUser();

      expect(user, kTestUser);
    });

    test('does not call remote when no token is stored', () async {
      when(() => mockStorage.readAccessToken()).thenAnswer((_) async => null);

      await repo.getCurrentUser();

      verifyNever(() => mockRemote.getCurrentUser());
    });
  });
}
