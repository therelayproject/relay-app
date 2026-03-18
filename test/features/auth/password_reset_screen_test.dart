import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/features/auth/data/auth_remote_datasource.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/auth_repository.dart';
import 'package:relay/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:relay/app/theme/app_theme.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

Widget _buildTestable(Widget widget, {
  AuthRepository? authRepo,
  AuthRemoteDataSource? dataSource,
}) {
  return ProviderScope(
    overrides: [
      if (authRepo != null) authRepositoryProvider.overrideWithValue(authRepo),
      if (dataSource != null)
        authRemoteDataSourceProvider.overrideWithValue(dataSource),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: widget,
    ),
  );
}

void main() {
  late MockAuthRepository mockRepo;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockDataSource = MockAuthRemoteDataSource();
    when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => null);
    when(() => mockRepo.authStateChanges).thenAnswer((_) => const Stream.empty());
  });

  group('PasswordResetScreen — request step', () {
    testWidgets('renders email field and send button', (tester) async {
      await tester.pumpWidget(_buildTestable(
        const PasswordResetScreen(),
        authRepo: mockRepo,
        dataSource: mockDataSource,
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.text('Send reset link'), findsOneWidget);
    });

    testWidgets('shows validation error when email is empty', (tester) async {
      await tester.pumpWidget(_buildTestable(
        const PasswordResetScreen(),
        authRepo: mockRepo,
        dataSource: mockDataSource,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Send reset link'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('shows success message after sending reset email', (tester) async {
      when(() => mockDataSource.requestPasswordReset(email: any(named: 'email')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(_buildTestable(
        const PasswordResetScreen(),
        authRepo: mockRepo,
        dataSource: mockDataSource,
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.tap(find.text('Send reset link'));
      await tester.pumpAndSettle();

      expect(find.text('Check your inbox'), findsOneWidget);
    });
  });

  group('PasswordResetScreen — confirm step', () {
    testWidgets('renders new password field when token is present', (tester) async {
      await tester.pumpWidget(_buildTestable(
        const PasswordResetScreen(token: 'valid-token-123'),
        authRepo: mockRepo,
        dataSource: mockDataSource,
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'New password'), findsOneWidget);
      expect(find.text('Set new password'), findsOneWidget);
    });
  });
}
