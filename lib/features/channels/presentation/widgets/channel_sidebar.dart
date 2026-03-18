import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/color_palette.dart';
import '../../../../workspaces/presentation/providers/workspace_provider.dart';
import '../../domain/models/channel.dart';
import '../providers/channels_provider.dart';

/// Left-hand channel list panel shown in Tablet and Desktop layouts.
class ChannelSidebar extends ConsumerWidget {
  const ChannelSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(currentWorkspaceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: workspace == null
          ? const _NoWorkspaceSelected()
          : _WorkspaceChannelList(workspaceId: workspace.id),
    );
  }
}

class _NoWorkspaceSelected extends StatelessWidget {
  const _NoWorkspaceSelected();

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'Select a workspace',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
}

class _WorkspaceChannelList extends ConsumerWidget {
  const _WorkspaceChannelList({required this.workspaceId});
  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelListProvider(workspaceId));
    final currentChannel = ref.watch(currentChannelProvider);
    final workspace = ref.watch(currentWorkspaceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Workspace header
        _WorkspaceHeader(
          name: workspace?.name ?? '',
          onSettingsTap: () =>
              context.push('/app/$workspaceId/settings'),
          onInviteTap: () =>
              _showInviteSheet(context, workspaceId),
        ),

        Expanded(
          child: channelsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Error: $e',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: colorScheme.error)),
            ),
            data: (channels) {
              final publicChannels = channels
                  .where((c) => c.type == ChannelType.public && !c.isArchived)
                  .toList()
                ..sort((a, b) => a.name.compareTo(b.name));
              final privateChannels = channels
                  .where((c) => c.type == ChannelType.private && !c.isArchived)
                  .toList()
                ..sort((a, b) => a.name.compareTo(b.name));

              return ListView(
                padding: const EdgeInsets.only(
                  bottom: RelayColors.spacingMd,
                ),
                children: [
                  // Channels section
                  _SidebarSectionHeader(
                    label: 'Channels',
                    onAddTap: () =>
                        context.push('/app/$workspaceId/channels/browse'),
                  ),
                  ...publicChannels.map(
                    (ch) => _ChannelTile(
                      channel: ch,
                      isSelected: currentChannel?.id == ch.id,
                      onTap: () {
                        ref
                            .read(currentChannelProvider.notifier)
                            .select(ch);
                        context.go('/app/$workspaceId/${ch.id}');
                      },
                    ),
                  ),
                  if (privateChannels.isNotEmpty) ...[
                    _SidebarSectionHeader(label: 'Private'),
                    ...privateChannels.map(
                      (ch) => _ChannelTile(
                        channel: ch,
                        isSelected: currentChannel?.id == ch.id,
                        isPrivate: true,
                        onTap: () {
                          ref
                              .read(currentChannelProvider.notifier)
                              .select(ch);
                          context.go('/app/$workspaceId/${ch.id}');
                        },
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showInviteSheet(BuildContext context, String workspaceId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => InviteMembersSheet(workspaceId: workspaceId),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({
    required this.name,
    required this.onSettingsTap,
    required this.onInviteTap,
  });

  final String name;
  final VoidCallback onSettingsTap;
  final VoidCallback onInviteTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: RelayColors.spacingMd,
        vertical: RelayColors.spacingSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSettingsTap,
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_add_outlined, color: colorScheme.onPrimary, size: 20),
            onPressed: onInviteTap,
            tooltip: 'Invite people',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: RelayColors.minTouchTarget,
              minHeight: RelayColors.minTouchTarget,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSectionHeader extends StatelessWidget {
  const _SidebarSectionHeader({required this.label, this.onAddTap});

  final String label;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        RelayColors.spacingMd,
        RelayColors.spacingMd,
        RelayColors.spacingXs,
        RelayColors.spacingXs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (onAddTap != null)
            GestureDetector(
              onTap: onAddTap,
              child: Icon(
                Icons.add,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({
    required this.channel,
    required this.isSelected,
    required this.onTap,
    this.isPrivate = false,
  });

  final Channel channel;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnread = channel.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? colorScheme.primary.withOpacity(0.15)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: 6,
        ),
        child: Row(
          children: [
            Icon(
              isPrivate ? Icons.lock_outline : Icons.tag,
              size: 16,
              color: hasUnread
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: RelayColors.spacingXs),
            Expanded(
              child: Text(
                channel.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          hasUnread ? FontWeight.w700 : FontWeight.normal,
                      color: hasUnread
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            if (channel.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RelayColors.spacingXs,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius:
                      BorderRadius.circular(RelayColors.radiusPill),
                ),
                child: Text(
                  channel.unreadCount > 99
                      ? '99+'
                      : channel.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── InviteMembersSheet (referenced from the sidebar) ─────────────────────

class InviteMembersSheet extends ConsumerStatefulWidget {
  const InviteMembersSheet({super.key, required this.workspaceId});
  final String workspaceId;

  @override
  ConsumerState<InviteMembersSheet> createState() => _InviteMembersSheetState();
}

class _InviteMembersSheetState extends ConsumerState<InviteMembersSheet> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;
  String? _error;
  String? _successEmail;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSending = true;
      _error = null;
    });
    try {
      await ref.read(
        sendInviteProvider(
          workspaceId: widget.workspaceId,
          email: _emailCtrl.text.trim(),
        ).future,
      );
      setState(() => _successEmail = _emailCtrl.text.trim());
      _emailCtrl.clear();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inviteLinkAsync =
        ref.watch(workspaceInviteLinkProvider(widget.workspaceId));

    return Padding(
      padding: EdgeInsets.only(
        left: RelayColors.spacingLg,
        right: RelayColors.spacingLg,
        top: RelayColors.spacingLg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + RelayColors.spacingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Invite people', style: theme.textTheme.titleLarge),
          const SizedBox(height: RelayColors.spacingMd),

          // Email invite
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      hintText: 'colleague@example.com',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter an email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: RelayColors.spacingSm),
                ElevatedButton(
                  onPressed: _isSending ? null : _sendInvite,
                  child: _isSending
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Send'),
                ),
              ],
            ),
          ),

          if (_successEmail != null) ...[
            const SizedBox(height: RelayColors.spacingSm),
            Text(
              'Invite sent to $_successEmail',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.secondary),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: RelayColors.spacingSm),
            Text(
              _error!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ],

          const SizedBox(height: RelayColors.spacingLg),
          Text('Invite link', style: theme.textTheme.labelMedium),
          const SizedBox(height: RelayColors.spacingXs),

          // Shareable invite link
          inviteLinkAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Text(
              'Could not generate link',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
            data: (link) => Row(
              children: [
                Expanded(
                  child: Text(
                    link,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  tooltip: 'Copy link',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: link));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: RelayColors.spacingMd),
        ],
      ),
    );
  }
}
