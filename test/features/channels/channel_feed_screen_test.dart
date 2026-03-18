import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/core/api/http_client.dart';
import 'package:relay/features/channels/presentation/screens/channel_feed_screen.dart';
import 'package:relay/features/messages/presentation/widgets/message_bubble.dart';

import '../../helpers/test_helpers.dart';

void main() {
  // Common Dio response wiring for the feed screen.
  // The feed screen additionally watches unreadNotificationCountProvider which
  // needs /notifications, and MessageComposer calls /channels/ch-1/typing.
  Map<String, dynamic> _feedDio({
    List<Map<String, dynamic>> messages = const [],
  }) =>
      {
        '/channels/ch-1/messages': messages,
        '/notifications': <Map<String, dynamic>>[],
        '/channels/ch-1/typing': null,
      };

  group('ChannelFeedScreen — no channel selected', () {
    testWidgets('shows "Select a channel" placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1'),
          dioResponses: _feedDio(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select a channel'), findsOneWidget);
    });

    testWidgets('shows tag icon on the placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1'),
          dioResponses: _feedDio(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.tag), findsOneWidget);
    });
  });

  group('ChannelFeedScreen — with channel selected', () {
    testWidgets('shows loading indicator while messages load', (tester) async {
      // Intercept the request but never resolve by using a completer (handled
      // by a slow fake).  Simplest approach: check frame before settle.
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: {
            '/channels/ch-1/messages': <dynamic>[],
            '/notifications': <dynamic>[],
          },
        ),
      );
      // Only pump one frame so the async build hasn't resolved yet.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "beginning of channel" when messages list is empty',
        (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: _feedDio(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('beginning of #ch-1'),
        findsOneWidget,
      );
    });

    testWidgets('shows appbar with channel name', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: _feedDio(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('#ch-1'), findsOneWidget);
    });

    testWidgets('renders message list when messages are present', (tester) async {
      final msgs = [
        messageJson(id: 'msg-1', text: 'First message'),
        messageJson(id: 'msg-2', text: 'Second message'),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: _feedDio(messages: msgs),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MessageBubble), findsNWidgets(2));
      expect(find.text('First message'), findsOneWidget);
      expect(find.text('Second message'), findsOneWidget);
    });

    testWidgets('shows error message when messages fail to load', (tester) async {
      // Simulate error by providing a Dio that rejects the request.
      final errorDio = testDio();
      errorDio.interceptors.clear();
      errorDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/channels/ch-1/messages') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  message: 'Network error',
                ),
              );
            } else {
              handler.resolve(
                Response(
                  data: <dynamic>[],
                  statusCode: 200,
                  requestOptions: options,
                ),
              );
            }
          },
        ),
      );

      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          extraOverrides: [
            httpClientProvider.overrideWithValue(errorDio),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('shows notification badge when unread count > 0', (tester) async {
      final notifications = List.generate(
        3,
        (i) => {
          'id': 'notif-$i',
          'type': 'mention',
          'title': 'Mention',
          'body': 'You were mentioned',
          'createdAt': '2024-01-01T12:00:00.000Z',
          'isRead': false,
        },
      );

      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: {
            '/channels/ch-1/messages': <dynamic>[],
            '/notifications': notifications,
          },
        ),
      );
      await tester.pumpAndSettle();

      // UnreadBadge should be present in the appbar
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows message composer', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelFeedScreen(workspaceId: 'ws-1', channelId: 'ch-1'),
          dioResponses: _feedDio(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
