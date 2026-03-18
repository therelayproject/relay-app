import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/api/http_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Displays and allows editing a user's custom status (emoji + text) (PRES-04).
///
/// Tap to open the edit sheet.
class CustomStatusWidget extends ConsumerWidget {
  const CustomStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final user = authAsync.valueOrNull?.user;

    if (user == null) return const SizedBox.shrink();

    final hasStatus =
        (user.statusEmoji != null || user.statusText != null);

    return InkWell(
      borderRadius: BorderRadius.circular(RelayColors.radiusSm),
      onTap: () => _CustomStatusSheet.show(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingSm,
          vertical: RelayColors.spacingXs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.statusEmoji != null)
              Text(user.statusEmoji!, style: const TextStyle(fontSize: 16))
            else
              Icon(
                Icons.mood_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            if (user.statusText != null && user.statusText!.isNotEmpty) ...[
              const SizedBox(width: RelayColors.spacingXs),
              Flexible(
                child: Text(
                  user.statusText!,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else if (!hasStatus) ...[
              const SizedBox(width: RelayColors.spacingXs),
              Text(
                'Set a status',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for editing the custom status.
class _CustomStatusSheet extends ConsumerStatefulWidget {
  const _CustomStatusSheet();

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
      builder: (_) => const _CustomStatusSheet(),
    );
  }

  @override
  ConsumerState<_CustomStatusSheet> createState() =>
      _CustomStatusSheetState();
}

class _CustomStatusSheetState extends ConsumerState<_CustomStatusSheet> {
  late final TextEditingController _textCtrl;
  String? _emoji;
  bool _saving = false;

  // Common status presets
  static const _presets = <(String, String)>[
    ('🎯', 'Focusing'),
    ('🏠', 'Working from home'),
    ('🌴', 'On vacation'),
    ('🤒', 'Out sick'),
    ('📵', 'In a meeting'),
    ('🚌', 'Commuting'),
    ('🌙', 'Out for the day'),
  ];

  @override
  void initState() {
    super.initState();
    final user =
        ref.read(authStateProvider).valueOrNull?.user;
    _textCtrl = TextEditingController(text: user?.statusText ?? '');
    _emoji = user?.statusEmoji;
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final dio = ref.read(httpClientProvider);
      await dio.patch<void>(
        '/users/me/status',
        data: {'statusEmoji': _emoji, 'statusText': _textCtrl.text.trim()},
      );
      ref.invalidate(authStateProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save status: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clear() async {
    setState(() => _saving = true);
    try {
      final dio = ref.read(httpClientProvider);
      await dio.patch<void>(
        '/users/me/status',
        data: {'statusEmoji': null, 'statusText': null},
      );
      ref.invalidate(authStateProvider);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear status: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RelayColors.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: RelayColors.spacingMd),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius:
                        BorderRadius.circular(RelayColors.radiusPill),
                  ),
                ),
              ),

              Text(
                'Set a status',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: RelayColors.spacingMd),

              // Emoji + text row
              Row(
                children: [
                  // Emoji picker trigger
                  InkWell(
                    borderRadius:
                        BorderRadius.circular(RelayColors.radiusSm),
                    onTap: _pickEmoji,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(RelayColors.radiusMd),
                      ),
                      child: _emoji != null
                          ? Text(
                              _emoji!,
                              style: const TextStyle(fontSize: 24),
                            )
                          : Icon(
                              Icons.mood_outlined,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                    ),
                  ),
                  const SizedBox(width: RelayColors.spacingSm),
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      autofocus: true,
                      maxLength: 80,
                      decoration: InputDecoration(
                        hintText: "What's your status?",
                        counterText: '',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(RelayColors.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: RelayColors.spacingMd),

              // Presets
              Wrap(
                spacing: RelayColors.spacingXs,
                runSpacing: RelayColors.spacingXs,
                children: _presets.map((preset) {
                  final (emoji, label) = preset;
                  return ActionChip(
                    label: Text('$emoji $label'),
                    onPressed: () {
                      setState(() {
                        _emoji = emoji;
                        _textCtrl.text = label;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: RelayColors.spacingLg),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : _clear,
                      child: const Text('Clear status'),
                    ),
                  ),
                  const SizedBox(width: RelayColors.spacingSm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickEmoji() async {
    // Simple inline emoji picker using a dialog of common emoji
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _SimpleEmojiDialog(),
    );
    if (result != null) {
      setState(() => _emoji = result);
    }
  }
}

class _SimpleEmojiDialog extends StatelessWidget {
  _SimpleEmojiDialog();

  static const _statusEmojis = [
    '😀', '😎', '🤔', '😴', '🤒', '🎯', '🔥', '💡', '📵', '🏠',
    '🌴', '🚌', '🌙', '🎉', '💪', '🙏', '❤️', '⭐', '✅', '🚀',
    '🎵', '☕', '🍕', '🍔', '🌮', '🏋️', '🧘', '📚', '💻', '🎮',
    '🎨', '🎤', '🎸', '🌸', '🌊', '🌻', '🦋', '🐶', '🐱', '🦊',
  ];

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Pick an emoji'),
        content: SizedBox(
          width: 280,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statusEmojis.map((e) {
              return InkWell(
                onTap: () => Navigator.of(context).pop(e),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(e, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
}
