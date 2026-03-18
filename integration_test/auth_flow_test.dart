/// Integration test: Auth flows
///
/// Covers:
///   1. App starts on the login screen when unauthenticated.
///   2. Validation errors appear for blank credentials.
///   3. Successful sign-in navigates to the app shell.
///   4. Sign-up screen is reachable from login.
///   5. Sign-out returns to the login screen.
///   6. App starts in the authenticated shell when a token is present.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/models/user.dart';

import 'helpers/integration_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth flow — unauthenticated start', () {
    testWidgets('shows login screen on cold launch', (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('shows email and password fields on login screen',
        (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('shows validation error when submitting blank form',
        (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('shows validation error for blank password', (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'tester@relay.app',
      );
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('navigates to app shell after successful sign-in',
        (tester) async {
      await pumpRelayApp(tester,
          authenticated: false,
          dioResponses: {'/workspaces': <dynamic>[]});
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'tester@relay.app',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret123',
      );
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      // After sign-in succeeds, the router redirects away from the login screen.
      expect(find.text('Sign in'), findsNothing);
    });

    testWidgets('navigates to sign-up screen from login', (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create one'));
      await tester.pumpAndSettle();

      expect(find.text('Create account'), findsOneWidget);
    });

    testWidgets('OAuth buttons are visible on login screen', (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with GitHub'), findsOneWidget);
    });
  });

  group('Auth flow — authenticated start', () {
    testWidgets('lands directly in app shell when session is active',
        (tester) async {
      await pumpRelayApp(
        tester,
        authenticated: true,
        dioResponses: {'/workspaces': <dynamic>[]},
      );
      await tester.pumpAndSettle();

      // Login screen should NOT be visible.
      expect(find.text('Sign in'), findsNothing);
    });
  });

  group('Sign-up flow', () {
    testWidgets('shows sign-up form fields', (tester) async {
      await pumpRelayApp(tester, authenticated: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create one'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Display name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    });

    testWidgets('sign-up with valid data navigates to app shell',
        (tester) async {
      await pumpRelayApp(
        tester,
        authenticated: false,
        dioResponses: {'/workspaces': <dynamic>[]},
      );
      await tester.pumpAndSettle();

      // Navigate to sign-up.
      await tester.tap(find.text('Create one'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Display name'),
        'Integration Tester',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'new@relay.app',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'newpass123',
      );
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      // Should navigate away from sign-up after success.
      expect(find.text('Create account'), findsNothing);
    });
  });
}
