import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/color_palette.dart';
import '../../domain/models/channel.dart';
import '../providers/channels_provider.dart';

/// Edit channel name, topic, purpose, and view members.
class ChannelSettingsScreen extends ConsumerStatefulWidget {
  const ChannelSettingsScreen({
    super.key,
    required this.workspaceId,
    required this.channel,
  });

  final String workspaceId;
  final Channel channel;

  @override
  ConsumerState<ChannelSettingsScreen> createState() =>
      _ChannelSettingsScreenState();
}

class _ChannelSettingsScreenState
    extends ConsumerState<ChannelSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _topicCtrl;
  late final TextEditingController _purposeCtrl;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.channel.name);
    _topicCtrl = TextEditingController(text: widget.channel.topic ?? '');
    _purposeCtrl = TextEditingController(text: widget.channel.purpose ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _topicCtrl.dispose();
    _purposeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(
        updateChannelProvider(
          workspaceId: widget.workspaceId,
          channelId: widget.channel.id,
          channelName: _nameCtrl.text.trim(),
          topic: _topicCtrl.text.trim().isEmpty ? null : _topicCtrl.text.trim(),
          purpose:
              _purposeCtrl.text.trim().isEmpty ? null : _purposeCtrl.text.trim(),
        ).future,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel updated')),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(
      channelMembersProvider(
        workspaceId: widget.workspaceId,
        channelId: widget.channel.id,
      ),
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('#${widget.channel.name}'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RelayColors.spacingLg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Channel name', style: theme.textTheme.labelMedium),
                const SizedBox(height: RelayColors.spacingXs),
                TextFormField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    prefixText: '# ',
                    hintText: 'channel-name',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Channel name is required';
                    }
                    if (v.contains(' ')) {
                      return 'Channel names cannot contain spaces';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: RelayColors.spacingMd),

                Text('Topic', style: theme.textTheme.labelMedium),
                const SizedBox(height: RelayColors.spacingXs),
                TextFormField(
                  controller: _topicCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Add a topic (optional)',
                  ),
                ),
                const SizedBox(height: RelayColors.spacingMd),

                Text('Description', style: theme.textTheme.labelMedium),
                const SizedBox(height: RelayColors.spacingXs),
                TextFormField(
                  controller: _purposeCtrl,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'What is this channel about?',
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: RelayColors.spacingMd),
                  Text(
                    _error!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                ],

                const SizedBox(height: RelayColors.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Save changes'),
                  ),
                ),

                const SizedBox(height: RelayColors.spacingXl),
                Text('Members', style: theme.textTheme.titleSmall),
                const SizedBox(height: RelayColors.spacingXs),
                membersAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Could not load members',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.error)),
                  data: (members) => Column(
                    children: members
                        .map((m) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text(
                                  (m['displayName'] as String? ?? '?')
                                      .substring(0, 1)
                                      .toUpperCase(),
                                ),
                              ),
                              title: Text(m['displayName'] as String? ?? ''),
                              subtitle: Text(m['email'] as String? ?? ''),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
