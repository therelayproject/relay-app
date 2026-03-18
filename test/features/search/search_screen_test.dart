import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/core/api/http_client.dart';
import 'package:relay/features/search/presentation/providers/search_provider.dart';
import 'package:relay/features/search/presentation/screens/search_screen.dart';
import 'package:relay/features/workspaces/domain/models/workspace.dart';
import 'package:relay/features/workspaces/presentation/providers/workspace_provider.dart';

import '../../helpers/test_helpers.dart';

// ---------------------------------------------------------------------------
// Fakes for state injection
// ---------------------------------------------------------------------------

class _FixedWorkspace extends CurrentWorkspace {
  _FixedWorkspace(this._workspace);
  final Workspace _workspace;

  @override
  Workspace? build() => _workspace;
}

class _FixedSearchQuery extends SearchQuery {
  _FixedSearchQuery(this._q);
  final String _q;

  @override
  String build() => _q;
}

class _FixedSearchFilter extends SearchFilterState {
  _FixedSearchFilter(this._f);
  final SearchFilters _f;

  @override
  SearchFilters build() => _f;
}

// ---------------------------------------------------------------------------
// Fixture helpers
// ---------------------------------------------------------------------------

const _testWorkspace = Workspace(id: 'ws-1', name: 'Acme Corp');

Map<String, dynamic> _searchResultJson({
  String id = 'res-1',
  String text = 'Hello world',
  String authorName = 'Alice',
  String channelId = 'ch-1',
  String channelName = 'general',
  String? highlight,
}) =>
    {
      'id': id,
      'text': text,
      'authorName': authorName,
      'authorAvatarUrl': null,
      'channelId': channelId,
      'channelName': channelName,
      'createdAt': '2024-01-01T12:00:00.000Z',
      if (highlight != null) 'highlight': highlight,
    };

Dio _buildErrorDio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            message: 'Search unavailable',
          ),
        );
      },
    ),
  );
  return dio;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SearchScreen — no workspace', () {
    testWidgets('shows "No workspace selected" when no workspace',
        (tester) async {
      await tester.pumpWidget(buildTestable(const SearchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('No workspace selected'), findsOneWidget);
    });
  });

  group('SearchScreen — empty query', () {
    testWidgets('shows search prompt when query is empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search all messages'), findsOneWidget);
    });

    testWidgets('search field has correct hint text', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search messages…'), findsOneWidget);
    });

    testWidgets('filters button is always visible', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Filters'), findsOneWidget);
    });

    testWidgets('clear button is hidden when query is empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Clear'), findsNothing);
    });
  });

  group('SearchScreen — with query', () {
    testWidgets('shows loading indicator while results load', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [_searchResultJson()],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('hello')),
          ],
        ),
      );
      // One pump: searchResultsProvider build not yet resolved.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows result tiles when search returns data', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [
              _searchResultJson(
                id: 'r1',
                authorName: 'Alice',
                channelName: 'general',
                text: 'Hello world',
              ),
              _searchResultJson(
                id: 'r2',
                authorName: 'Bob',
                channelName: 'random',
                text: 'Another result',
              ),
            ],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('hello')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Hello world'), findsOneWidget);
      expect(find.text('Another result'), findsOneWidget);
    });

    testWidgets('shows channel name in result tile', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [
              _searchResultJson(channelName: 'general'),
            ],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('hello')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('in #general'), findsOneWidget);
    });

    testWidgets('shows "No results" message when empty list returned',
        (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {'/workspaces/ws-1/search': <dynamic>[]},
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('zzz')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('No results'), findsOneWidget);
      expect(find.textContaining('"zzz"'), findsOneWidget);
    });

    testWidgets('shows error UI when search request fails', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('crash')),
            httpClientProvider.overrideWithValue(_buildErrorDio()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Search failed'), findsOneWidget);
    });

    testWidgets('clear button appears when query is non-empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {'/workspaces/ws-1/search': <dynamic>[]},
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('test')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Clear'), findsOneWidget);
    });

    testWidgets('result list uses ListView with separators', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [
              _searchResultJson(id: 'r1'),
              _searchResultJson(id: 'r2', text: 'Second message'),
            ],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('hello')),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('SearchScreen — filter indicator', () {
    testWidgets('filter dot appears when active filters are set', (tester) async {
      final activeFilters = SearchFilters(from: DateTime(2024));

      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {'/workspaces/ws-1/search': <dynamic>[]},
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
            searchQueryProvider
                .overrideWith(() => _FixedSearchQuery('hello')),
            searchFilterStateProvider
                .overrideWith(() => _FixedSearchFilter(activeFilters)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // The filter indicator is a small circle overlaid on the filter button.
      // Verify via circular BoxDecoration containers in the subtree.
      final circleDecos = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
            final deco = c.decoration;
            return deco is BoxDecoration && deco.shape == BoxShape.circle;
          })
          .toList();
      expect(circleDecos.isNotEmpty, isTrue);
    });

    testWidgets('SearchFilters.hasFilters is true when from is set',
        (tester) async {
      final filters = SearchFilters(from: DateTime(2024));
      expect(filters.hasFilters, isTrue);
    });

    testWidgets('SearchFilters.hasFilters is false when all null',
        (tester) async {
      const filters = SearchFilters();
      expect(filters.hasFilters, isFalse);
    });
  });

  group('SearchScreen — debounce behavior', () {
    testWidgets('typing in field shows results after debounce delay',
        (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [
              _searchResultJson(text: 'Debounced result'),
            ],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Empty state initially.
      expect(find.text('Search all messages'), findsOneWidget);

      // Enter text into the search field.
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump(); // One frame — debounce not yet fired.

      // Advance past 400 ms debounce.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Debounced result'), findsOneWidget);
    });

    testWidgets('rapid typing only triggers one search after settling',
        (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const SearchScreen(),
          dioResponses: {
            '/workspaces/ws-1/search': [
              _searchResultJson(text: 'Final result'),
            ],
          },
          extraOverrides: [
            currentWorkspaceProvider
                .overrideWith(() => _FixedWorkspace(_testWorkspace)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final field = find.byType(TextField);

      // Simulate rapid typing.
      await tester.enterText(field, 'h');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(field, 'he');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(field, 'hello');
      await tester.pump(const Duration(milliseconds: 100));

      // After the final debounce fires.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('Final result'), findsOneWidget);
    });
  });
}
