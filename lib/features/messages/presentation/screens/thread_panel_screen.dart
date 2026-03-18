import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../shared/widgets/relay_avatar.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/thread_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/reaction_bar.dart';

/// Full-screen (or side-panel on desktop) thread view (THR-01/02/03).
///
/// Shows all replies to [parentMessage] and allows composing new replies with
/// an optional "also send to channel" toggle.
class ThreadPanelScreen extends ConsumerStatefulWidget {
  const ThreadPanelScreen({
    super.key,
    required this.threadId,
    required this.channelId,
    required this.parentAuthorName,
    required this.parentAuthorAvatarUrl,
    required this.parentText,
    required this.parentCreatedAt,
  });

  final String threadId;
  final String channelId;
  final String parentAuthorName;
  final String? parentAuthorAvatarUrl;
  final String parentText;
  final DateTime parentCreatedAt;

  @override
  ConsumerState<ThreadPanelScreen> createState() => _ThreadPanelScreenState();
}

class _ThreadPanelScreenState extends ConsumerState<ThreadPanelScreen> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollCtrl = ScrollController();
  final _typingDebouncer = Debouncer();
  bool _canSend = false;
  bool _alsoSendToChannel = false;

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
    _scrollCtrl.dispose();
    _typingDebouncer.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    setState(() => _canSend = false);

    await ref
        .read(
          threadMessagesProvider(threadId: widget.threadId).notifier,
        )
        .sendReply(
          text: text,
          alsoSendToChannel: _alsoSendToChannel,
          channelId: widget.channelId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final threadAsync = ref.watch(
      threadMessagesProvider(threadId: widget.threadId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Parent message preview ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              RelayColors.spacingMd,
              RelayColors.spacingSm,
              RelayColors.spacingMd,
              RelayColors.spacingXs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RelayAvatar(
                  displayName: widget.parentAuthorName,
                  avatarUrl: widget.parentAuthorAvatarUrl,
                  size: 36,
                ),
                const SizedBox(width: RelayColors.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.parentAuthorName,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(width: RelayColors.spacingXs),
                          Text(
                            DateFormatter.messageTimestamp(
                              widget.parentCreatedAt,
                            ),
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.parentText,
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

          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant,
          ),

          // ── Replies ─────────────────────────────────────────────────────
          Expanded(
            child: threadAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) => messages.isEmpty
                  ? Center(
                      child: Text(
                        'No replies yet.\nBe the first to reply!',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollCtrl,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: RelayColors.spacingSm,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => MessageBubble(
                        message: messages[messages.length - 1 - index],
                      ),
                    ),
            ),
          ),

          // ── Composer ────────────────────────────────────────────────────
          _ThreadComposer(
            ctrl: _ctrl,
            focusNode: _focusNode,
            canSend: _canSend,
            alsoSendToChannel: _alsoSendToChannel,
            onToggleChannel: (v) =>
                setState(() => _alsoSendToChannel = v),
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _ThreadComposer extends StatelessWidget {
  const _ThreadComposer({
    required this.ctrl,
    required this.focusNode,
    required this.canSend,
    required this.alsoSendToChannel,
    required this.onToggleChannel,
    required this.onSend,
  });

  final TextEditingController ctrl;
  final FocusNode focusNode;
  final bool canSend;
  final bool alsoSendToChannel;
  final ValueChanged<bool> onToggleChannel;
  final VoidCallback onSend;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Also send to channel" toggle (THR-03)
          Row(
            children: [
              Switch(
                value: alsoSendToChannel,
                onChanged: onToggleChannel,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: RelayColors.spacingXs),
              Text(
                'Also send to channel',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: RelayColors.spacingXs),

          Row(
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
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Reply…',
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
                  color: theme.colorScheme.primary,
                  tooltip: 'Send reply',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
