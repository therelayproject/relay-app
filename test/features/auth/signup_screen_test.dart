import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/features/auth/domain/auth_repository.dart';
import 'package:relay/features/auth/domain/models/user.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/presentation/screens/signup_screen.dart';
import 'package:relay/app/theme/app_theme.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _buildTestable(Widget widget, {AuthRepository? authRepo}) {
  return ProviderScope(
    overrides: [
      if (authRepo != null) authRepositoryProvider.overrideWithValue(authRepo),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: widget,
    ),
  );
}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
    when(() => mockRepo.authStateChanges).thenAnswer((_) => const Stream.empty());
  });

  group('SignupScreen', () {
    testWidgets('renders display name, email and password fields', (tester) async {
      await tester.pumpWidget(_buildTestable(const SignupScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Display name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('shows validation error when display name is empty', (tester) async {
      await tester.pumpWidget(_buildTestable(const SignupScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a display name'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (tester) async {
      await tester.pumpWidget(_buildTestable(const SignupScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Display name'),
        'Alice',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'alice@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'short',
      );
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('calls signUp when form is valid', (tester) async {
      when(() => mockRepo.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          )).thenAnswer((_) async => const User(
            id: 'u1',
            email: 'alice@example.com',
            displayName: 'Alice',
          ));

      await tester.pumpWidget(_buildTestable(const SignupScreen(), authRepo: mockRepo));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Display name'),
        'Alice',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'alice@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'securepassword',
      );
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.signUp(
            email: 'alice@example.com',
            password: 'securepassword',
            displayName: 'Alice',
          )).called(1);
    });
  });
}
