// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchResultsHash() => r'167d167449e61ddf3a7191d4c53107b1f8b6539d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Executes a search against the API (SRCH-01/03).
///
/// Returns empty list when query is blank.  Results are ranked by relevance
/// on the server side.
///
/// Copied from [searchResults].
@ProviderFor(searchResults)
const searchResultsProvider = SearchResultsFamily();

/// Executes a search against the API (SRCH-01/03).
///
/// Returns empty list when query is blank.  Results are ranked by relevance
/// on the server side.
///
/// Copied from [searchResults].
class SearchResultsFamily extends Family<AsyncValue<List<SearchResult>>> {
  /// Executes a search against the API (SRCH-01/03).
  ///
  /// Returns empty list when query is blank.  Results are ranked by relevance
  /// on the server side.
  ///
  /// Copied from [searchResults].
  const SearchResultsFamily();

  /// Executes a search against the API (SRCH-01/03).
  ///
  /// Returns empty list when query is blank.  Results are ranked by relevance
  /// on the server side.
  ///
  /// Copied from [searchResults].
  SearchResultsProvider call({
    required String workspaceId,
  }) {
    return SearchResultsProvider(
      workspaceId: workspaceId,
    );
  }

  @override
  SearchResultsProvider getProviderOverride(
    covariant SearchResultsProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchResultsProvider';
}

/// Executes a search against the API (SRCH-01/03).
///
/// Returns empty list when query is blank.  Results are ranked by relevance
/// on the server side.
///
/// Copied from [searchResults].
class SearchResultsProvider
    extends AutoDisposeFutureProvider<List<SearchResult>> {
  /// Executes a search against the API (SRCH-01/03).
  ///
  /// Returns empty list when query is blank.  Results are ranked by relevance
  /// on the server side.
  ///
  /// Copied from [searchResults].
  SearchResultsProvider({
    required String workspaceId,
  }) : this._internal(
          (ref) => searchResults(
            ref as SearchResultsRef,
            workspaceId: workspaceId,
          ),
          from: searchResultsProvider,
          name: r'searchResultsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchResultsHash,
          dependencies: SearchResultsFamily._dependencies,
          allTransitiveDependencies:
              SearchResultsFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
        );

  SearchResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
  }) : super.internal();

  final String workspaceId;

  @override
  Override overrideWith(
    FutureOr<List<SearchResult>> Function(SearchResultsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultsProvider._internal(
        (ref) => create(ref as SearchResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SearchResult>> createElement() {
    return _SearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.workspaceId == workspaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchResultsRef on AutoDisposeFutureProviderRef<List<SearchResult>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;
}

class _SearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<List<SearchResult>>
    with SearchResultsRef {
  _SearchResultsProviderElement(super.provider);

  @override
  String get workspaceId => (origin as SearchResultsProvider).workspaceId;
}

String _$searchQueryHash() => r'790bd96a8a13bb944767c7bf06a5378cfc78a54d';

/// Holds search query + filter state.
///
/// Copied from [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$searchFilterStateHash() => r'd6e9288715c6fb61898a8d8ddebf968bdec339b2';

/// Holds active search filter state.
///
/// Copied from [SearchFilterState].
@ProviderFor(SearchFilterState)
final searchFilterStateProvider =
    AutoDisposeNotifierProvider<SearchFilterState, SearchFilters>.internal(
  SearchFilterState.new,
  name: r'searchFilterStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchFilterStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchFilterState = AutoDisposeNotifier<SearchFilters>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
