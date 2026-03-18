import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/color_palette.dart';
import '../../domain/models/channel.dart';
import '../providers/channels_provider.dart';

/// Browse and join public channels in a workspace.
class ChannelBrowserScreen extends ConsumerStatefulWidget {
  const ChannelBrowserScreen({super.key, required this.workspaceId});
  final String workspaceId;

  @override
  ConsumerState<ChannelBrowserScreen> createState() =>
      _ChannelBrowserScreenState();
}

class _ChannelBrowserScreenState extends ConsumerState<ChannelBrowserScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(
      publicChannelBrowserProvider(widget.workspaceId, query: _query),
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Browse channels')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(RelayColors.spacingMd),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search channels…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: channelsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.error)),
              ),
              data: (channels) => channels.isEmpty
                  ? Center(
                      child: Text(
                        _query.isEmpty
                            ? 'No public channels yet'
                            : 'No channels matching "$_query"',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: channels.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) => _ChannelBrowserTile(
                        channel: channels[index],
                        workspaceId: widget.workspaceId,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChannelBrowserTile extends ConsumerStatefulWidget {
  const _ChannelBrowserTile({
    required this.channel,
    required this.workspaceId,
  });
  final Channel channel;
  final String workspaceId;

  @override
  ConsumerState<_ChannelBrowserTile> createState() =>
      _ChannelBrowserTileState();
}

class _ChannelBrowserTileState extends ConsumerState<_ChannelBrowserTile> {
  bool _joining = false;

  Future<void> _join() async {
    setState(() => _joining = true);
    try {
      await ref.read(
        joinChannelProvider(
          workspaceId: widget.workspaceId,
          channelId: widget.channel.id,
        ).future,
      );
      if (mounted) {
        context.go('/app/${widget.workspaceId}/${widget.channel.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ch = widget.channel;
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          '#',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text('#${ch.name}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ch.topic?.isNotEmpty ?? false)
            Text(ch.topic!, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(
            '${ch.memberCount} member${ch.memberCount == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      isThreeLine: ch.topic?.isNotEmpty ?? false,
      trailing: FilledButton(
        onPressed: _joining ? null : _join,
        child: _joining
            ? const SizedBox.square(
                dimension: 16,
                child:
                    CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text('Join'),
      ),
    );
  }
}
