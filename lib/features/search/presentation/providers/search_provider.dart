import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';

part 'search_provider.g.dart';

/// Filter parameters for search (SRCH-02).
class SearchFilters {
  const SearchFilters({
    this.channelId,
    this.authorId,
    this.from,
    this.to,
  });

  final String? channelId;
  final String? authorId;
  final DateTime? from;
  final DateTime? to;

  SearchFilters copyWith({
    String? channelId,
    String? authorId,
    DateTime? from,
    DateTime? to,
    bool clearChannel = false,
    bool clearAuthor = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) =>
      SearchFilters(
        channelId: clearChannel ? null : channelId ?? this.channelId,
        authorId: clearAuthor ? null : authorId ?? this.authorId,
        from: clearFrom ? null : from ?? this.from,
        to: clearTo ? null : to ?? this.to,
      );

  bool get hasFilters =>
      channelId != null || authorId != null || from != null || to != null;
}

/// A single search result item.
class SearchResult {
  const SearchResult({
    required this.id,
    required this.text,
    required this.authorName,
    this.authorAvatarUrl,
    required this.channelId,
    required this.channelName,
    required this.createdAt,
    this.highlight,
  });

  final String id;
  final String text;
  final String authorName;
  final String? authorAvatarUrl;
  final String channelId;
  final String channelName;
  final DateTime createdAt;

  /// Highlighted snippet with <mark> tags from server, or null.
  final String? highlight;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        id: json['id'] as String,
        text: json['text'] as String,
        authorName: json['authorName'] as String,
        authorAvatarUrl: json['authorAvatarUrl'] as String?,
        channelId: json['channelId'] as String,
        channelName: json['channelName'] as String? ?? json['channelId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        highlight: json['highlight'] as String?,
      );
}

/// Holds search query + filter state.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

/// Holds active search filter state.
@riverpod
class SearchFilterState extends _$SearchFilterState {
  @override
  SearchFilters build() => const SearchFilters();

  void update(SearchFilters filters) => state = filters;
  void reset() => state = const SearchFilters();
}

/// Executes a search against the API (SRCH-01/03).
///
/// Returns empty list when query is blank.  Results are ranked by relevance
/// on the server side.
@riverpod
Future<List<SearchResult>> searchResults(
  Ref ref, {
  required String workspaceId,
}) async {
  final query = ref.watch(searchQueryProvider);
  final filters = ref.watch(searchFilterStateProvider);

  if (query.trim().isEmpty) return const [];

  final dio = ref.watch(httpClientProvider);
  final response = await dio.get<List<dynamic>>(
    '/workspaces/$workspaceId/search',
    queryParameters: {
      'q': query.trim(),
      if (filters.channelId != null) 'channelId': filters.channelId,
      if (filters.authorId != null) 'authorId': filters.authorId,
      if (filters.from != null) 'from': filters.from!.toIso8601String(),
      if (filters.to != null) 'to': filters.to!.toIso8601String(),
      'limit': 50,
    },
  );

  return (response.data ?? [])
      .cast<Map<String, dynamic>>()
      .map(SearchResult.fromJson)
      .toList();
}
