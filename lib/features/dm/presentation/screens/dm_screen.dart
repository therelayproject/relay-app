import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/relay_avatar.dart';
import '../../../presence/presentation/widgets/presence_indicator.dart';
import '../providers/dm_provider.dart';
import '../sheets/new_dm_sheet.dart';

/// 1:1 or group DM conversation screen (DM-01/02/03).
class DmScreen extends ConsumerStatefulWidget {
  const DmScreen({super.key, required this.dmChannelId});

  final String dmChannelId;

  @override
  ConsumerState<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends ConsumerState<DmScreen> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final canSend = _ctrl.text.trim().isNotEmpty;
      if (canSend != _canSend) setState(() => _canSend = canSend);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    setState(() => _canSend = false);
    await ref
        .read(dmMessagesProvider(dmChannelId: widget.dmChannelId).notifier)
        .send(text);
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(dmChannelListProvider);

    final channel = channelsAsync.valueOrNull
        ?.where((c) => c.id == widget.dmChannelId)
        .firstOrNull;

    final title = channel == null
        ? 'Direct Message'
        : channel.members.map((m) => m.displayName).join(', ');

    final messagesAsync =
        ref.watch(dmMessagesProvider(dmChannelId: widget.dmChannelId));

    return Scaffold(
      appBar: AppBar(
        title: channel == null
            ? Text(title)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (channel.members.length == 1) ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        RelayAvatar(
                          displayName: channel.members.first.displayName,
                          avatarUrl: channel.members.first.avatarUrl,
                          size: 28,
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: PresenceIndicator(
                            userId: channel.members.first.id,
                            size: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: RelayColors.spacingSm),
                  ],
                  Text(title),
                ],
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'New DM',
            onPressed: () => NewDmSheet.show(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) => messages.isEmpty
                  ? _EmptyDm(members: channel?.members ?? [])
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: RelayColors.spacingSm,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg =
                            messages[messages.length - 1 - index];
                        return _DmBubble(message: msg);
                      },
                    ),
            ),
          ),
          _DmComposer(
            ctrl: _ctrl,
            focusNode: _focusNode,
            canSend: _canSend,
            onSend: _send,
            hintName: channel?.members.firstOrNull?.displayName,
          ),
        ],
      ),
    );
  }
}

class _EmptyDm extends StatelessWidget {
  const _EmptyDm({required this.members});
  final List members;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(RelayColors.spacingXl),
          child: Text(
            'This is the beginning of your direct message history.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
}

class _DmBubble extends StatelessWidget {
  const _DmBubble({required this.message});
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: RelayColors.spacingMd,
        vertical: RelayColors.spacingXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RelayAvatar(
            displayName: message.authorName as String,
            avatarUrl: message.authorAvatarUrl as String?,
            size: 36,
          ),
          const SizedBox(width: RelayColors.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        message.authorName as String,
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: RelayColors.spacingXs),
                    Text(
                      DateFormatter.messageTimestamp(
                        message.createdAt as DateTime,
                      ),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SelectableText(
                  message.text as String,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DmComposer extends StatelessWidget {
  const _DmComposer({
    required this.ctrl,
    required this.focusNode,
    required this.canSend,
    required this.onSend,
    this.hintName,
  });

  final TextEditingController ctrl;
  final FocusNode focusNode;
  final bool canSend;
  final VoidCallback onSend;
  final String? hintName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        RelayColors.spacingMd,
        RelayColors.spacingXs,
        RelayColors.spacingSm,
        RelayColors.spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): onSend,
                const SingleActivator(
                  LogicalKeyboardKey.enter,
                  shift: true,
                ): () {
                  ctrl
                    ..text = '${ctrl.text}\n'
                    ..selection = TextSelection.collapsed(
                      offset: ctrl.text.length,
                    );
                },
              },
              child: TextField(
                controller: ctrl,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText:
                      hintName != null ? 'Message $hintName' : 'Message',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(RelayColors.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: RelayColors.spacingMd,
                    vertical: RelayColors.spacingSm,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: RelayColors.spacingXs),
          AnimatedOpacity(
            opacity: canSend ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 150),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: canSend ? onSend : null,
              tooltip: 'Send message',
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
