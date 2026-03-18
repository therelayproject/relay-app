import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/color_palette.dart';

/// Displays an image attachment as a thumbnail that expands to full-screen on
/// tap (FILE-02).
class InlineImageViewer extends StatelessWidget {
  const InlineImageViewer({
    super.key,
    required this.imageUrl,
    required this.fileName,
    this.thumbnailWidth = 240.0,
    this.thumbnailHeight = 180.0,
  });

  final String imageUrl;
  final String fileName;
  final double thumbnailWidth;
  final double thumbnailHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreen(context),
      child: Semantics(
        label: 'Image: $fileName. Tap to expand.',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RelayColors.radiusMd),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: thumbnailWidth,
            height: thumbnailHeight,
            fit: BoxFit.cover,
            placeholder: (context, _) => Container(
              width: thumbnailWidth,
              height: thumbnailHeight,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, _, __) => Container(
              width: thumbnailWidth,
              height: thumbnailHeight,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(
                child: Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: _FullScreenImageViewer(
            imageUrl: imageUrl,
            fileName: fileName,
          ),
        ),
      ),
    );
  }
}

class _FullScreenImageViewer extends StatefulWidget {
  const _FullScreenImageViewer({
    required this.imageUrl,
    required this.fileName,
  });

  final String imageUrl;
  final String fileName;

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  final _transformController = TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.fileName,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Close',
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformController,
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, _) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, _, __) => const Center(
              child: Icon(Icons.broken_image_outlined,
                  size: 64, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}
