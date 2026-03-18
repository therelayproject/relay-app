import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/core/api/http_client.dart';
import 'package:relay/features/channels/presentation/widgets/channel_sidebar.dart';
import 'package:relay/features/workspaces/domain/models/workspace.dart';
import 'package:relay/features/workspaces/presentation/providers/workspace_provider.dart';

import '../../helpers/test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake CurrentWorkspace notifier seeded with a specific workspace
// ---------------------------------------------------------------------------

class _FixedWorkspace extends CurrentWorkspace {
  _FixedWorkspace(this._workspace);
  final Workspace _workspace;

  @override
  Workspace? build() => _workspace;
}

const _testWorkspace = Workspace(id: 'ws-1', name: 'Acme Corp');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ChannelSidebar — no workspace selected', () {
    testWidgets('shows "Select a workspace" placeholder', (tester) async {
      await tester.pumpWidget(
        buildTestable(const ChannelSidebar()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select a workspace'), findsOneWidget);
    });
  });

  group('ChannelSidebar — with workspace selected', () {
    testWidgets('shows workspace name in the header', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general'),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Acme Corp'), findsOneWidget);
    });

    testWidgets('shows loading indicator while channels load', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      // One frame before async resolve.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows "Channels" section header', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general'),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CHANNELS'), findsOneWidget);
    });

    testWidgets('renders public channel names', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general'),
              channelJson(id: 'ch-2', name: 'random'),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('general'), findsOneWidget);
      expect(find.text('random'), findsOneWidget);
    });

    testWidgets('shows tag icon for public channels', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general'),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.tag), findsOneWidget);
    });

    testWidgets('shows "Private" section for private channels', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general'),
              channelJson(
                id: 'ch-2',
                name: 'secret',
                type: 'private',
              ),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PRIVATE'), findsOneWidget);
      expect(find.text('secret'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows unread badge when channel has unread messages',
        (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general', unreadCount: 5),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows "99+" for very high unread counts', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[
              channelJson(id: 'ch-1', name: 'general', unreadCount: 120),
            ],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('shows invite-people button in workspace header', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          dioResponses: {
            '/workspaces/ws-1/channels': <dynamic>[],
            '/workspaces/ws-1/invites/link': {'link': 'https://relay.app/invite/abc'},
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Invite people'), findsOneWidget);
    });

    testWidgets('shows error when channels fail to load', (tester) async {
      final errorDio = testDio();
      errorDio.interceptors.clear();
      errorDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                message: 'Network error',
              ),
            );
          },
        ),
      );

      await tester.pumpWidget(
        buildTestable(
          const ChannelSidebar(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            httpClientProvider.overrideWithValue(errorDio),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
