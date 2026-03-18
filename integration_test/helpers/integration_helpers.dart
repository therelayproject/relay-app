import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/app/app.dart';
import 'package:relay/core/api/http_client.dart';
import 'package:relay/core/api/ws_client.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/auth_repository.dart';
import 'package:relay/features/auth/domain/models/user.dart';

// ---------------------------------------------------------------------------
// Shared fixtures
// ---------------------------------------------------------------------------

const kIntegrationTestUser = User(
  id: 'itest-user-1',
  email: 'tester@relay.app',
  displayName: 'Integration Tester',
);

// ---------------------------------------------------------------------------
// Mocks / fakes
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeWsClient extends WsClient {
  final _ctrl = StreamController<WsEvent>.broadcast();

  @override
  Stream<WsEvent> get events => _ctrl.stream;

  @override
  Stream<WsConnectionState> get connectionState => const Stream.empty();

  @override
  Future<void> connect(String token) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> dispose() async => _ctrl.close();
}

// ---------------------------------------------------------------------------
// Dio helper
// ---------------------------------------------------------------------------

Dio integrationDio([Map<String, dynamic> responses = const {}]) {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final data = responses[options.path];
        handler.resolve(
          Response<dynamic>(
            data: data,
            statusCode: 200,
            requestOptions: options,
          ),
        );
      },
    ),
  );
  return dio;
}

// ---------------------------------------------------------------------------
// App pump helper
// ---------------------------------------------------------------------------

/// Pumps the full [RelayApp] with injected providers for integration testing.
///
/// Pass [authenticated] = true to start in an authenticated state (the router
/// will redirect to the app shell). Pass [dioResponses] to stub API calls.
Future<void> pumpRelayApp(
  WidgetTester tester, {
  bool authenticated = false,
  Map<String, dynamic> dioResponses = const {},
  List<Override> extraOverrides = const [],
}) async {
  final mockRepo = MockAuthRepository();
  when(() => mockRepo.getCurrentUser()).thenAnswer(
    (_) async => authenticated ? kIntegrationTestUser : null,
  );
  when(() => mockRepo.authStateChanges)
      .thenAnswer((_) => const Stream.empty());
  when(() => mockRepo.signInWithEmail(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => kIntegrationTestUser);
  when(() => mockRepo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        displayName: any(named: 'displayName'),
      )).thenAnswer((_) async => kIntegrationTestUser);
  when(() => mockRepo.handleOAuthCallback(
        provider: any(named: 'provider'),
        code: any(named: 'code'),
      )).thenAnswer((_) async => kIntegrationTestUser);
  when(() => mockRepo.signOut()).thenAnswer((_) async {});

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        httpClientProvider.overrideWithValue(integrationDio(dioResponses)),
        wsClientProvider.overrideWithValue(FakeWsClient()),
        authRepositoryProvider.overrideWithValue(mockRepo),
        ...extraOverrides,
      ],
      child: const RelayApp(),
    ),
  );
}
