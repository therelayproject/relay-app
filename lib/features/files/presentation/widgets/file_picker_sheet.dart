import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/color_palette.dart';
import '../providers/file_provider.dart';

/// Bottom sheet for picking and uploading files (FILE-01).
///
/// Shows current upload queue, allows picking new files, and confirms
/// attachment when at least one upload has completed.
class FilePickerSheet extends ConsumerWidget {
  const FilePickerSheet({
    super.key,
    required this.channelId,
    required this.onFilesAttached,
  });

  final String channelId;
  final ValueChanged<List<UploadedFile>> onFilesAttached;

  /// Convenience method to show the sheet.
  static Future<List<UploadedFile>?> show(
    BuildContext context, {
    required String channelId,
  }) async {
    return showModalBottomSheet<List<UploadedFile>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RelayColors.radiusLg),
        ),
      ),
      builder: (ctx) => FilePickerSheet(
        channelId: channelId,
        onFilesAttached: (files) => Navigator.of(ctx).pop(files),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(fileUploadQueueProvider);
    final theme = Theme.of(context);
    final attachable = queue.where((f) => f.isDone).map((f) => f.uploaded!).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: RelayColors.spacingMd,
        right: RelayColors.spacingMd,
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
              margin:
                  const EdgeInsets.only(bottom: RelayColors.spacingMd),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius:
                    BorderRadius.circular(RelayColors.radiusPill),
              ),
            ),
          ),

          Text('Attach files', style: theme.textTheme.titleMedium),
          const SizedBox(height: RelayColors.spacingMd),

          // Pick file buttons
          Row(
            children: [
              Expanded(
                child: _PickButton(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Browse files',
                  onTap: () => _pickFiles(context, ref, FileType.any),
                ),
              ),
              const SizedBox(width: RelayColors.spacingSm),
              Expanded(
                child: _PickButton(
                  icon: Icons.image_outlined,
                  label: 'Photo / Video',
                  onTap: () =>
                      _pickFiles(context, ref, FileType.media),
                ),
              ),
            ],
          ),

          if (queue.isNotEmpty) ...[
            const SizedBox(height: RelayColors.spacingMd),
            // Upload queue
            ...queue.asMap().entries.map(
                  (entry) => _UploadQueueTile(
                    state: entry.value,
                    onRemove: () => ref
                        .read(fileUploadQueueProvider.notifier)
                        .removeAt(entry.key),
                  ),
                ),
          ],

          const SizedBox(height: RelayColors.spacingLg),

          // Confirm button
          FilledButton(
            onPressed: attachable.isNotEmpty
                ? () {
                    ref.read(fileUploadQueueProvider.notifier).clear();
                    onFilesAttached(attachable);
                  }
                : null,
            child: Text(
              attachable.isEmpty
                  ? 'Attach (0)'
                  : 'Attach (${attachable.length})',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles(
    BuildContext context,
    WidgetRef ref,
    FileType type,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: true,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty) return;

    for (final file in result.files) {
      if (file.path == null) continue;
      ref.read(fileUploadQueueProvider.notifier).upload(
            file: file,
            channelId: channelId,
          );
    }
  }
}

class _PickButton extends StatelessWidget {
  const _PickButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        icon: Icon(icon, size: 18),
        label: Text(label),
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: RelayColors.spacingSm,
          ),
        ),
      );
}

class _UploadQueueTile extends StatelessWidget {
  const _UploadQueueTile({
    required this.state,
    required this.onRemove,
  });

  final FileUploadState state;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = state.file?.name ?? state.uploaded?.name ?? 'Unknown file';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: RelayColors.spacingXs),
      child: Row(
        children: [
          Icon(
            _mimeIcon(state.uploaded?.mimeType ?? ''),
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: RelayColors.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                if (state.isUploading)
                  LinearProgressIndicator(value: state.progress)
                else if (state.hasError)
                  Text(
                    state.error!,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.error),
                    overflow: TextOverflow.ellipsis,
                  )
                else if (state.isDone)
                  Text(
                    'Ready',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.secondary),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onRemove,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }

  IconData _mimeIcon(String mime) {
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime.startsWith('video/')) return Icons.videocam_outlined;
    if (mime.startsWith('audio/')) return Icons.audiotrack_outlined;
    if (mime.contains('pdf')) return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }
}
