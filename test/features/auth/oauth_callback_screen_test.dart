import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/app/theme/app_theme.dart';
import 'package:relay/core/api/ws_client.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/models/user.dart';
import 'package:relay/features/auth/presentation/screens/oauth_callback_screen.dart';

import '../../helpers/test_helpers.dart';

// ---------------------------------------------------------------------------
// Router-aware test helper (needed because OAuthCallbackScreen calls context.go)
// ---------------------------------------------------------------------------

Widget _buildWithRouter(
  Map<String, String> queryParams, {
  MockAuthRepository? repo,
  List<Override> extraOverrides = const [],
}) {
  final mockRepo = repo ?? MockAuthRepository();
  when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
  when(() => mockRepo.authStateChanges)
      .thenAnswer((_) => const Stream.empty());
  when(() => mockRepo.handleOAuthCallback(
        provider: any(named: 'provider'),
        code: any(named: 'code'),
      )).thenAnswer((_) async => kTestUser);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => OAuthCallbackScreen(queryParams: queryParams),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const Scaffold(body: Text('Login Page')),
      ),
      GoRoute(
        path: '/app/workspace',
        builder: (_, __) => const Scaffold(body: Text('App Page')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      wsClientProvider.overrideWithValue(FakeWsClient()),
      authRepositoryProvider.overrideWithValue(mockRepo),
      ...extraOverrides,
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: router,
    ),
  );
}

void main() {
  group('OAuthCallbackScreen — loading state', () {
    testWidgets('shows loading indicator before processing completes',
        (tester) async {
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
      when(() => mockRepo.authStateChanges)
          .thenAnswer((_) => const Stream.empty());
      // Make the OAuth call hang so we can observe the loading state.
      when(() => mockRepo.handleOAuthCallback(
            provider: any(named: 'provider'),
            code: any(named: 'code'),
          )).thenAnswer((_) => Future.delayed(const Duration(seconds: 60)));

      await tester.pumpWidget(
        _buildWithRouter(
          {'provider': 'google', 'code': 'test-code'},
          repo: mockRepo,
        ),
      );
      // Pump one frame so the widget is built; postFrameCallback has not run yet.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "Completing sign in…" text while loading',
        (tester) async {
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
      when(() => mockRepo.authStateChanges)
          .thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.handleOAuthCallback(
            provider: any(named: 'provider'),
            code: any(named: 'code'),
          )).thenAnswer((_) => Future.delayed(const Duration(seconds: 60)));

      await tester.pumpWidget(
        _buildWithRouter(
          {'provider': 'github', 'code': 'gh-code'},
          repo: mockRepo,
        ),
      );
      await tester.pump();

      expect(find.text('Completing sign in…'), findsOneWidget);
    });
  });

  group('OAuthCallbackScreen — error param', () {
    testWidgets('redirects to login page when error query param is present',
        (tester) async {
      await tester.pumpWidget(
        _buildWithRouter({'error': 'access_denied'}),
      );
      await tester.pumpAndSettle();

      // After navigation the Login Page scaffold should be visible.
      expect(find.text('Login Page'), findsOneWidget);
    });
  });

  group('OAuthCallbackScreen — missing params', () {
    testWidgets('redirects to login when provider is absent', (tester) async {
      await tester.pumpWidget(_buildWithRouter({'code': 'some-code'}));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });

    testWidgets('redirects to login when code is absent', (tester) async {
      await tester.pumpWidget(_buildWithRouter({'provider': 'google'}));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });

  group('OAuthCallbackScreen — successful OAuth', () {
    testWidgets('navigates to app on successful sign-in', (tester) async {
      await tester.pumpWidget(
        _buildWithRouter({'provider': 'google', 'code': 'valid-code'}),
      );
      await tester.pumpAndSettle();

      // kTestUser is authenticated, so the screen navigates to /app/workspace.
      expect(find.text('App Page'), findsOneWidget);
    });
  });

  group('OAuthCallbackScreen — auth error UI', () {
    testWidgets('shows error icon when authStateProvider is in error state',
        (tester) async {
      // Override authStateProvider to return an error value directly.
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.getCurrentUser()).thenThrow(Exception('auth error'));
      when(() => mockRepo.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        _buildWithRouter(
          {'provider': 'google', 'code': 'bad-code'},
          repo: mockRepo,
          extraOverrides: const [],
        ),
      );
      await tester.pumpAndSettle();

      // The screen shows error icon + "Sign in failed" when authState.hasError.
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Sign in failed'), findsOneWidget);
    });

    testWidgets('"Back to sign in" button navigates to login on error',
        (tester) async {
      final mockRepo = MockAuthRepository();
      when(() => mockRepo.getCurrentUser()).thenThrow(Exception('bad'));
      when(() => mockRepo.authStateChanges)
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        _buildWithRouter({'provider': 'google', 'code': 'bad'}, repo: mockRepo),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Back to sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
