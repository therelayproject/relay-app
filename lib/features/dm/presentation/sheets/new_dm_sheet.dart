import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/api/http_client.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../shared/widgets/relay_avatar.dart';
import '../../../presence/presentation/widgets/presence_indicator.dart';
import '../providers/dm_provider.dart';

/// Bottom sheet to start a new DM conversation (DM-03).
///
/// Searches workspace members by name and opens (or creates) a DM channel.
class NewDmSheet extends ConsumerStatefulWidget {
  const NewDmSheet._();

  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RelayColors.radiusLg),
        ),
      ),
      builder: (_) => const NewDmSheet._(),
    );
  }

  @override
  ConsumerState<NewDmSheet> createState() => _NewDmSheetState();
}

class _NewDmSheetState extends ConsumerState<NewDmSheet> {
  final _searchCtrl = TextEditingController();
  final _debouncer = Debouncer();
  List<_UserResult> _results = [];
  final Set<String> _selectedIds = {};
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      _debouncer(() => _search(_searchCtrl.text.trim()));
    });
    // Populate initial list
    _search('');
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = ref.read(httpClientProvider);
      final resp = await dio.get<List<dynamic>>(
        '/users/search',
        queryParameters: {'q': query, 'limit': 20},
      );
      if (!mounted) return;
      setState(() {
        _results = (resp.data ?? [])
            .cast<Map<String, dynamic>>()
            .map(_UserResult.fromJson)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _toggle(String userId) {
    setState(() {
      if (_selectedIds.contains(userId)) {
        _selectedIds.remove(userId);
      } else {
        _selectedIds.add(userId);
      }
    });
  }

  Future<void> _open() async {
    if (_selectedIds.isEmpty) return;
    try {
      final channel = await ref
          .read(dmChannelListProvider.notifier)
          .openOrCreate(_selectedIds.toList());
      if (mounted) {
        Navigator.of(context).pop();
        // Navigate to the new DM
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed('/app/dm/${channel.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open DM: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin:
                const EdgeInsets.symmetric(vertical: RelayColors.spacingSm),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(RelayColors.radiusPill),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: RelayColors.spacingMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'New Direct Message',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (_selectedIds.isNotEmpty)
                  FilledButton(
                    onPressed: _open,
                    child: const Text('Open'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: RelayColors.spacingSm),

          // Selected chips
          if (_selectedIds.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: RelayColors.spacingMd,
                ),
                children: _selectedIds.map((id) {
                  final user = _results.where((u) => u.id == id).firstOrNull;
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: RelayColors.spacingXs,
                    ),
                    child: Chip(
                      label: Text(user?.displayName ?? id),
                      onDeleted: () => _toggle(id),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: RelayColors.spacingMd,
              vertical: RelayColors.spacingXs,
            ),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name…',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(RelayColors.radiusPill),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: RelayColors.spacingMd,
                  vertical: RelayColors.spacingXs,
                ),
              ),
            ),
          ),

          // Results
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'No users found',
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final user = _results[index];
                              final selected =
                                  _selectedIds.contains(user.id);
                              return ListTile(
                                leading: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    RelayAvatar(
                                      displayName: user.displayName,
                                      avatarUrl: user.avatarUrl,
                                      size: 40,
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: -2,
                                      child: PresenceIndicator(
                                        userId: user.id,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(user.displayName),
                                trailing: selected
                                    ? Icon(
                                        Icons.check_circle,
                                        color: theme.colorScheme.primary,
                                      )
                                    : null,
                                onTap: () => _toggle(user.id),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _UserResult {
  const _UserResult({
    required this.id,
    required this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String? avatarUrl;

  factory _UserResult.fromJson(Map<String, dynamic> json) => _UserResult(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        avatarUrl: json['avatarUrl'] as String?,
      );
}
