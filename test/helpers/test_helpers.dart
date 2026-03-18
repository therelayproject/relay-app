import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:relay/app/theme/app_theme.dart';
import 'package:relay/core/api/http_client.dart';
import 'package:relay/core/api/ws_client.dart';
import 'package:relay/features/auth/data/auth_repository_impl.dart';
import 'package:relay/features/auth/domain/auth_repository.dart';
import 'package:relay/features/auth/domain/models/user.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAuthRepository extends Mock implements AuthRepository {}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// A [WsClient] that exposes an empty broadcast stream — safe for widget tests.
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
// Dio test helper
// ---------------------------------------------------------------------------

/// Creates a [Dio] instance whose requests are answered by [responses].
///
/// The map key is the *path* portion of the URL (e.g. `'/channels/ch1/messages'`).
/// Any unmapped path resolves with `null` data and status 200.
Dio testDio([Map<String, dynamic> responses = const {}]) {
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
// Fixture helpers
// ---------------------------------------------------------------------------

const kTestUser = User(
  id: 'user-1',
  email: 'alice@example.com',
  displayName: 'Alice',
);

Map<String, dynamic> messageJson({
  String id = 'msg-1',
  String channelId = 'ch-1',
  String authorId = 'user-1',
  String authorName = 'Alice',
  String text = 'Hello, world!',
  String createdAt = '2024-01-01T12:00:00.000Z',
  int replyCount = 0,
  bool deleted = false,
  bool edited = false,
  List<Map<String, dynamic>> reactions = const [],
}) =>
    {
      'id': id,
      'channelId': channelId,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': null,
      'text': text,
      'createdAt': createdAt,
      if (deleted) 'deletedAt': '2024-01-01T13:00:00.000Z',
      if (edited) 'editedAt': '2024-01-01T12:30:00.000Z',
      'threadId': null,
      'replyCount': replyCount,
      'reactions': reactions,
      'attachments': <Map<String, dynamic>>[],
      'isPinned': false,
    };

Map<String, dynamic> channelJson({
  String id = 'ch-1',
  String workspaceId = 'ws-1',
  String name = 'general',
  String type = 'public',
  int unreadCount = 0,
}) =>
    {
      'id': id,
      'workspaceId': workspaceId,
      'name': name,
      'topic': null,
      'purpose': null,
      'type': type,
      'isArchived': false,
      'memberCount': 1,
      'unreadCount': unreadCount,
      'lastMessageAt': null,
    };

Map<String, dynamic> dmChannelJson({
  String id = 'dm-1',
  String participantId = 'user-2',
  String participantName = 'Bob',
}) =>
    {
      'id': id,
      'members': [
        {
          'id': participantId,
          'displayName': participantName,
          'avatarUrl': null,
          'presence': 'online',
        }
      ],
      'unreadCount': 0,
      'lastMessageText': null,
      'lastMessageAt': null,
    };

// ---------------------------------------------------------------------------
// Widget wrapper
// ---------------------------------------------------------------------------

/// Wraps [widget] in a [ProviderScope] and [MaterialApp] with the Relay theme.
///
/// [dioResponses] is forwarded to [testDio]. A [FakeWsClient] is always
/// installed. An authenticated [MockAuthRepository] is set up by default
/// (returning [kTestUser]) — override via [extraOverrides] if you need
/// different auth state.
Widget buildTestable(
  Widget widget, {
  Map<String, dynamic> dioResponses = const {},
  List<Override> extraOverrides = const [],
}) {
  final fakeDio = testDio(dioResponses);
  final fakeWs = FakeWsClient();
  final mockRepo = MockAuthRepository();

  when(() => mockRepo.getCurrentUser()).thenAnswer((_) async => kTestUser);
  when(() => mockRepo.authStateChanges).thenAnswer((_) => const Stream.empty());

  return ProviderScope(
    overrides: [
      httpClientProvider.overrideWithValue(fakeDio),
      wsClientProvider.overrideWithValue(fakeWs),
      authRepositoryProvider.overrideWithValue(mockRepo),
      ...extraOverrides,
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: widget,
    ),
  );
}
