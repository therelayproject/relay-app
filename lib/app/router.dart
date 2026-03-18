import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/oauth_callback_screen.dart';
import '../features/auth/presentation/screens/password_reset_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/channels/domain/models/channel.dart';
import '../features/channels/presentation/providers/channels_provider.dart';
import '../features/channels/presentation/screens/channel_browser_screen.dart';
import '../features/channels/presentation/screens/channel_feed_screen.dart';
import '../features/channels/presentation/screens/channel_settings_screen.dart';
import '../features/dm/presentation/screens/dm_screen.dart';
import '../features/messages/presentation/screens/thread_panel_screen.dart';
import '../features/notifications/presentation/screens/notification_preferences_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/workspaces/presentation/providers/workspace_provider.dart';
import '../features/workspaces/presentation/screens/workspace_create_screen.dart';
import '../features/workspaces/presentation/screens/workspace_settings_screen.dart';
import '../shared/widgets/adaptive_layout.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull?.isAuthenticated ?? false;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/signup') ||
          state.matchedLocation.startsWith('/oauth') ||
          state.matchedLocation.startsWith('/password-reset');

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/app';
      return null;
    },
    routes: [
      // ── Unauthenticated ────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/oauth/callback',
        name: 'oauth-callback',
        builder: (context, state) => OAuthCallbackScreen(
          queryParams: state.uri.queryParameters,
        ),
      ),
      GoRoute(
        path: '/password-reset',
        name: 'password-reset',
        builder: (context, state) => PasswordResetScreen(
          token: state.uri.queryParameters['token'],
        ),
      ),

      // ── Authenticated shell ─────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AdaptiveLayout(child: child),
        routes: [
          GoRoute(
            path: '/app',
            name: 'app-home',
            redirect: (_, __) => '/app/workspace',
            routes: [
              GoRoute(
                path: 'workspace/create',
                name: 'workspace-create',
                builder: (context, state) => const WorkspaceCreateScreen(),
              ),
              GoRoute(
                path: ':workspaceId',
                name: 'workspace',
                builder: (context, state) => ChannelFeedScreen(
                  workspaceId: state.pathParameters['workspaceId']!,
                  channelId: null,
                ),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'workspace-settings',
                    builder: (context, state) => WorkspaceSettingsScreen(
                      workspaceId: state.pathParameters['workspaceId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'channels/browse',
                    name: 'channel-browser',
                    builder: (context, state) => ChannelBrowserScreen(
                      workspaceId: state.pathParameters['workspaceId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':channelId',
                    name: 'channel',
                    builder: (context, state) => ChannelFeedScreen(
                      workspaceId: state.pathParameters['workspaceId']!,
                      channelId: state.pathParameters['channelId'],
                    ),
                    routes: [
                      GoRoute(
                        path: 'settings',
                        name: 'channel-settings',
                        builder: (context, state) {
                          // Retrieve channel from provider — fallback to stub.
                          final container = ProviderScope.containerOf(context);
                          final channel =
                              container.read(currentChannelProvider) ??
                                  Channel(
                                    id: state.pathParameters['channelId']!,
                                    workspaceId:
                                        state.pathParameters['workspaceId']!,
                                    name: state.pathParameters['channelId']!,
                                  );
                          return ChannelSettingsScreen(
                            workspaceId:
                                state.pathParameters['workspaceId']!,
                            channel: channel,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ── Thread panel (THR-01/02/03) ──────────────────────────────────
          GoRoute(
            path: '/app/thread/:threadId',
            name: 'thread',
            builder: (context, state) {
              final extra = (state.extra as Map<String, dynamic>?) ?? {};
              return ThreadPanelScreen(
                threadId: state.pathParameters['threadId']!,
                channelId: extra['channelId'] as String? ?? '',
                parentAuthorName: extra['authorName'] as String? ?? 'Unknown',
                parentAuthorAvatarUrl: extra['authorAvatarUrl'] as String?,
                parentText: extra['text'] as String? ?? '',
                parentCreatedAt:
                    extra['createdAt'] as DateTime? ?? DateTime.now(),
              );
            },
          ),

          // ── Direct Messages (DM-01/02/03) ─────────────────────────────
          GoRoute(
            path: '/app/dm/:dmChannelId',
            name: 'dm',
            builder: (context, state) => DmScreen(
              dmChannelId: state.pathParameters['dmChannelId']!,
            ),
          ),

          GoRoute(
            path: '/app/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),

          GoRoute(
            path: '/app/notifications',
            name: 'notifications',
            builder: (context, state) =>
                const NotificationPreferencesScreen(),
          ),

          GoRoute(
            path: '/app/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

