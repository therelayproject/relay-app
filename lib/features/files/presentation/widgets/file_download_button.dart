import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/theme/color_palette.dart';

/// Shows a non-image file attachment with a download/open button (FILE-03).
///
/// Opens the file URL in the external browser / OS handler when tapped.
class FileDownloadButton extends StatelessWidget {
  const FileDownloadButton({
    super.key,
    required this.name,
    required this.mimeType,
    required this.url,
    this.sizeBytes,
  });

  final String name;
  final String mimeType;
  final String url;
  final int? sizeBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'File attachment: $name. Tap to open.',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(RelayColors.radiusMd),
        onTap: () => _open(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RelayColors.spacingMd,
            vertical: RelayColors.spacingSm,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(RelayColors.radiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconFor(mimeType),
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: RelayColors.spacingSm),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (sizeBytes != null)
                      Text(
                        _formatSize(sizeBytes!),
                        style: theme.textTheme.labelSmall,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: RelayColors.spacingSm),
              Icon(
                Icons.download_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open file')),
        );
      }
    }
  }

  IconData _iconFor(String mime) {
    if (mime.startsWith('video/')) return Icons.videocam_outlined;
    if (mime.startsWith('audio/')) return Icons.audiotrack_outlined;
    if (mime.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (mime.contains('spreadsheet') ||
        mime.contains('excel') ||
        mime.contains('csv')) return Icons.table_chart_outlined;
    if (mime.contains('presentation') ||
        mime.contains('powerpoint')) return Icons.slideshow_outlined;
    if (mime.contains('word') || mime.contains('document')) {
      return Icons.description_outlined;
    }
    if (mime.contains('zip') ||
        mime.contains('tar') ||
        mime.contains('gzip')) return Icons.folder_zip_outlined;
    return Icons.insert_drive_file_outlined;
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
