import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../shared/widgets/relay_avatar.dart';
import '../../../../features/workspaces/presentation/providers/workspace_provider.dart';
import '../providers/search_provider.dart';

/// Full-text message search with filter support (SRCH-01/02/03).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    // Restore query state if re-entering the screen
    _ctrl.text = ref.read(searchQueryProvider);
    _ctrl.addListener(() {
      _debouncer(() {
        ref.read(searchQueryProvider.notifier).update(_ctrl.text);
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspace = ref.watch(currentWorkspaceProvider);
    final filters = ref.watch(searchFilterStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search messages…',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RelayColors.radiusMd),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RelayColors.spacingMd,
              vertical: RelayColors.spacingSm,
            ),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Filters',
                onPressed: () => _showFilters(context),
              ),
              if (filters.hasFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear',
              onPressed: () {
                _ctrl.clear();
                ref.read(searchQueryProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: workspace == null
          ? const Center(child: Text('No workspace selected'))
          : _SearchResults(workspaceId: workspace.id),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RelayColors.radiusLg),
        ),
      ),
      builder: (_) => const _SearchFiltersSheet(),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.workspaceId});
  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(
      searchResultsProvider(workspaceId: workspaceId),
    );

    if (query.trim().isEmpty) {
      return const Center(
        child: _SearchEmptyState(),
      );
    }

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(RelayColors.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: RelayColors.spacingMd),
              Text('Search failed: $e',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(RelayColors.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: RelayColors.spacingMd),
                  Text(
                    'No results for "$query"',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: RelayColors.spacingSm),
                  Text(
                    'Try different keywords or adjust your filters.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: RelayColors.spacingSm),
          itemCount: results.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) =>
              _SearchResultTile(result: results[index]),
        );
      },
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(RelayColors.spacingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search,
              size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: RelayColors.spacingMd),
          Text(
            'Search all messages',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RelayColors.spacingSm),
          Text(
            'Type to search across channels, DMs, and threads.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.result});
  final SearchResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workspace = ref.watch(currentWorkspaceProvider);

    return InkWell(
      onTap: () {
        if (workspace != null) {
          context.push('/app/${workspace.id}/${result.channelId}');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: RelayColors.spacingSm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RelayAvatar(
              displayName: result.authorName,
              avatarUrl: result.authorAvatarUrl,
              size: 36,
            ),
            const SizedBox(width: RelayColors.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(result.authorName,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(width: RelayColors.spacingXs),
                      Text(
                        'in #${result.channelName}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormatter.messageTimestamp(result.createdAt),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.highlight ?? result.text,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SearchFiltersSheet ──────────────────────────────────────────────────────

/// Bottom sheet for applying search filters (SRCH-02).
class _SearchFiltersSheet extends ConsumerStatefulWidget {
  const _SearchFiltersSheet();

  @override
  ConsumerState<_SearchFiltersSheet> createState() =>
      _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends ConsumerState<_SearchFiltersSheet> {
  late SearchFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = ref.read(searchFilterStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: RelayColors.spacingLg,
        right: RelayColors.spacingLg,
        top: RelayColors.spacingMd,
        bottom:
            MediaQuery.viewInsetsOf(context).bottom + RelayColors.spacingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius:
                    BorderRadius.circular(RelayColors.radiusPill),
              ),
            ),
          ),
          const SizedBox(height: RelayColors.spacingMd),
          Text('Filter results', style: theme.textTheme.titleMedium),
          const SizedBox(height: RelayColors.spacingMd),

          // Date range
          Text('Date range', style: theme.textTheme.labelMedium),
          const SizedBox(height: RelayColors.spacingXs),
          Row(
            children: [
              Expanded(
                child: _DateButton(
                  label: _filters.from != null
                      ? DateFormatter.dateOnly(_filters.from!)
                      : 'From date',
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _filters.from ?? DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365 * 3)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _filters =
                          _filters.copyWith(from: picked));
                    }
                  },
                  onClear: _filters.from != null
                      ? () => setState(
                            () => _filters =
                                _filters.copyWith(clearFrom: true),
                          )
                      : null,
                ),
              ),
              const SizedBox(width: RelayColors.spacingSm),
              const Text('–'),
              const SizedBox(width: RelayColors.spacingSm),
              Expanded(
                child: _DateButton(
                  label: _filters.to != null
                      ? DateFormatter.dateOnly(_filters.to!)
                      : 'To date',
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _filters.to ?? DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365 * 3)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(
                        () => _filters = _filters.copyWith(to: picked),
                      );
                    }
                  },
                  onClear: _filters.to != null
                      ? () => setState(
                            () => _filters =
                                _filters.copyWith(clearTo: true),
                          )
                      : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: RelayColors.spacingLg),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(searchFilterStateProvider.notifier).reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: RelayColors.spacingSm),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ref
                        .read(searchFilterStateProvider.notifier)
                        .update(_filters);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: RelayColors.spacingSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.clear, size: 16),
            )
          else
            const Icon(Icons.calendar_today, size: 16),
        ],
      ),
    );
  }
}
