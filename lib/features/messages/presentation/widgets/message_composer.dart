import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../files/presentation/widgets/file_picker_sheet.dart';
import '../providers/messages_provider.dart';
import '../providers/typing_provider.dart';
import '../sheets/emoji_picker_sheet.dart';

/// Message composition bar (MSG-01, MSG-06 mentions, FILE-01 attachments).
class MessageComposer extends ConsumerStatefulWidget {
  const MessageComposer({super.key, required this.channelId});

  final String channelId;

  @override
  ConsumerState<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends ConsumerState<MessageComposer> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  final _typingDebouncer = Debouncer();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final canSend = _ctrl.text.trim().isNotEmpty;
      if (canSend != _canSend) setState(() => _canSend = canSend);

      // Emit typing indicator to server
      _typingDebouncer(() {
        sendTypingIndicator(ref, widget.channelId).catchError((_) {});
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    _typingDebouncer.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    setState(() => _canSend = false);

    await ref
        .read(messageListProvider(channelId: widget.channelId).notifier)
        .sendMessage(text);
  }

  Future<void> _openFilePicker() async {
    await FilePickerSheet.show(context, channelId: widget.channelId);
    // Uploaded files are attached to the next sendMessage call via
    // fileUploadQueueProvider; the queue is cleared after attachment.
  }

  void _openEmojiPicker() {
    EmojiPickerSheet.show(
      context,
      onEmojiSelected: (emoji) {
        final offset = _ctrl.selection.baseOffset.clamp(0, _ctrl.text.length);
        final newText =
            _ctrl.text.substring(0, offset) + emoji + _ctrl.text.substring(offset);
        _ctrl.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: offset + emoji.length),
        );
        _focusNode.requestFocus();
      },
    );
  }

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
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment button (FILE-01)
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _openFilePicker(),
            tooltip: 'Attach file',
          ),

          // Text input
          Expanded(
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): _sendMessage,
                const SingleActivator(
                  LogicalKeyboardKey.enter,
                  shift: true,
                ): () {
                  _ctrl
                    ..text = '${_ctrl.text}\n'
                    ..selection = TextSelection.collapsed(
                      offset: _ctrl.text.length,
                    );
                },
              },
              child: TextField(
                controller: _ctrl,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Message',
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

          // Emoji button (MSG-08)
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: _openEmojiPicker,
            tooltip: 'Add emoji',
          ),

          // Send button
          AnimatedOpacity(
            opacity: _canSend ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 150),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _canSend ? _sendMessage : null,
              tooltip: 'Send message',
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
