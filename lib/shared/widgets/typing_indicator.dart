import 'package:flutter/material.dart';

import '../../app/theme/color_palette.dart';

/// Animated "… is typing" indicator (PRES-04).
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, required this.typingUserNames});

  /// Names of users currently typing (empty = hidden).
  final List<String> typingUserNames;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _label {
    final names = widget.typingUserNames;
    if (names.isEmpty) return '';
    if (names.length == 1) return '${names[0]} is typing';
    if (names.length == 2) return '${names[0]} and ${names[1]} are typing';
    return 'Several people are typing';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUserNames.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Semantics(
      liveRegion: true,
      label: _label,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: 4,
        ),
        child: Row(
          children: [
            _DotsAnimation(controller: _controller),
            const SizedBox(width: RelayColors.spacingXs),
            Flexible(
              child: Text(
                _label,
                style: theme.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsAnimation extends AnimatedWidget {
  const _DotsAnimation({required AnimationController controller})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final t = (listenable as AnimationController).value;
    final theme = Theme.of(context);
    const dotSize = 5.0;
    const spacing = 3.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final phase = (t * 3 - i).clamp(0.0, 1.0);
        final opacity = (phase < 0.5 ? phase * 2 : 2 - phase * 2).clamp(0.3, 1.0);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}
