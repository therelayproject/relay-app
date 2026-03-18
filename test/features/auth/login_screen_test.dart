import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/features/auth/domain/auth_repository.dart';
import 'package:relay/features/auth/domain/models/user.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/presentation/screens/login_screen.dart';
import 'package:relay/app/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements AuthRepository {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps [widget] in a [ProviderScope] with an overridden [authRepositoryProvider]
/// and a [MaterialApp] with the Relay theme.
Widget _buildTestable(
  Widget widget, {
  AuthRepository? authRepo,
}) {
  return ProviderScope(
    overrides: [
      if (authRepo != null)
        authRepositoryProvider.overrideWithValue(authRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: widget,
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    // getCurrentUser returns null by default (unauthenticated)
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
    when(() => mockRepo.authStateChanges).thenAnswer((_) => const Stream.empty());
  });

  group('LoginScreen', () {
    testWidgets('renders email, password fields and sign-in button', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('email_field')).evaluate().isNotEmpty ||
             find.widgetWithText(TextFormField, 'Email').evaluate().isNotEmpty, isTrue);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('shows validation error when email is empty', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      // Tap sign in without filling fields
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('shows validation error when password is empty', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      // Fill email but leave password blank
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('calls signInWithEmail when form is valid', (tester) async {
      when(() => mockRepo.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const User(
            id: 'u1',
            email: 'test@example.com',
            displayName: 'Tester',
          ));

      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.signInWithEmail(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
    });

    testWidgets('renders OAuth buttons for Google and GitHub', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with GitHub'), findsOneWidget);
    });

    testWidgets('renders forgot password link', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('renders create account link', (tester) async {
      await tester.pumpWidget(_buildTestable(const LoginScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      expect(find.text('Create one'), findsOneWidget);
    });
  });
}
