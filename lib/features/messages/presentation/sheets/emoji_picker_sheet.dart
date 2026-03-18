import 'package:flutter/material.dart';

import '../../../../app/theme/color_palette.dart';

// Lightweight built-in emoji data — no external package required.
// Categories use the standard Unicode emoji groups.
const _kEmojiCategories = <String, List<String>>{
  'Smileys': [
    '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
    '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙',
    '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔',
    '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤥',
    '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤧', '🥵',
    '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😕',
    '😟', '🙁', '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨',
    '😰', '😥', '😢', '😭', '😱', '😖', '😣', '😞', '😓', '😩',
    '😫', '🥱', '😤', '😡', '😠', '🤬', '😈', '👿', '💀', '💩',
    '🤡', '👹', '👺', '👻', '👽', '👾', '🤖',
  ],
  'Gestures': [
    '👋', '🤚', '🖐', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞',
    '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '☝️', '👍',
    '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '👐', '🤲', '🤝',
    '🙏', '✍️', '💅', '🤳', '💪', '🦾', '🦿', '🦵', '🦶', '👂',
  ],
  'Objects': [
    '💡', '🔦', '🕯️', '📱', '💻', '⌨️', '🖥️', '🖨️', '🖱️', '📷',
    '📸', '📹', '🎥', '📽️', '🎞️', '📞', '☎️', '📟', '📠', '📺',
    '📻', '🎙️', '🎚️', '🎛️', '🧭', '⏱️', '⏰', '🕰️', '📡', '🔋',
    '🔌', '💰', '💳', '💎', '🔧', '🔨', '⚒️', '🛠️', '⛏️', '🔩',
    '🧱', '🔑', '🗝️', '🔐', '🔏', '🔓', '🔒', '🚪', '🛋️', '🪑',
  ],
  'Nature': [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯',
    '🦁', '🐮', '🐷', '🐸', '🐵', '🐔', '🐧', '🐦', '🐤', '🦆',
    '🦅', '🦉', '🦇', '🐺', '🐗', '🐴', '🦄', '🐝', '🐛', '🦋',
    '🌸', '🌼', '🌻', '🌺', '🌹', '🌷', '🍀', '🌿', '🍃', '🍂',
    '🍁', '🌲', '🌳', '🌴', '🌵', '🌾', '🌍', '🌎', '🌏', '🌙',
    '⭐', '🌟', '✨', '⚡', '❄️', '🌊', '🌈', '☁️', '🌤️', '⛅',
  ],
  'Food': [
    '🍎', '🍊', '🍋', '🍇', '🍓', '🫐', '🍈', '🍒', '🍑', '🥭',
    '🍍', '🥥', '🥝', '🍅', '🥑', '🍆', '🌽', '🌶️', '🥦', '🥕',
    '🧅', '🍔', '🍟', '🍕', '🌭', '🥪', '🥙', '🧆', '🌮', '🌯',
    '🍣', '🍱', '🥟', '🦪', '🍤', '🍙', '🍘', '🍥', '🥮', '🍢',
    '🍡', '🍧', '🍨', '🍦', '🥧', '🧁', '🍰', '🎂', '🍮', '🍭',
    '🍬', '🍫', '🍿', '🍩', '🍪', '🌰', '🥜', '🍯', '🧃', '☕',
    '🍵', '🧋', '🍺', '🍻', '🥂', '🍷', '🥃', '🍸', '🍹', '🍾',
  ],
  'Symbols': [
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
    '❣️', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟', '☮️',
    '✝️', '☪️', '🕉️', '☯️', '♾️', '♻️', '✅', '❎', '🔴', '🟠',
    '🟡', '🟢', '🔵', '🟣', '⚫', '⚪', '🔺', '🔻', '💠', '🔶',
    '🔷', '🔸', '🔹', '#️⃣', '0️⃣', '🆕', '🆒', '🆓', '🆙', '🆗',
    '🅰️', '🅱️', '🆎', '🆑', '🅾️', '🆘', '🚫', '⛔', '📵', '🔞',
  ],
  'Activities': [
    '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🎱', '🏓',
    '🏸', '🏒', '🏑', '🥍', '🏏', '⛳', '🎣', '🤿', '🎽', '🎿',
    '🛷', '🥌', '🎯', '🎱', '🎳', '🎮', '🎰', '🎲', '♟️', '🧩',
    '🎭', '🎨', '🖼️', '🎪', '🤹', '🎤', '🎧', '🎼', '🎹', '🥁',
    '🎷', '🎺', '🎸', '🎻', '🎬', '🎤', '🎵', '🎶', '🎙️',
  ],
  'Travel': [
    '🚗', '🚕', '🚙', '🚌', '🚎', '🏎️', '🚓', '🚑', '🚒', '🚐',
    '🛻', '🚚', '🚛', '🚜', '🏍️', '🛵', '🛺', '🚲', '🛴', '🛹',
    '🚁', '🛸', '✈️', '🛩️', '🚀', '🛶', '⛵', '🚤', '🛥️', '🛳️',
    '🚢', '⚓', '🗺️', '🗼', '🗽', '🗾', '🗿', '🌋', '⛺', '🏕️',
    '🏖️', '🏜️', '🏝️', '🏞️', '🏟️', '🏛️', '🏗️', '🏘️', '🏚️', '🏠',
    '🏡', '🏢', '🏣', '🏤', '🏥', '🏦', '🏨', '🏩', '🏪', '🏫',
  ],
};

/// Bottom sheet presenting a categorized emoji grid with search (MSG-08).
///
/// Shows the picker and calls [onEmojiSelected] with the chosen emoji string.
class EmojiPickerSheet extends StatefulWidget {
  const EmojiPickerSheet({super.key, required this.onEmojiSelected});

  final ValueChanged<String> onEmojiSelected;

  /// Convenience helper to show the sheet.
  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onEmojiSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RelayColors.radiusLg),
        ),
      ),
      builder: (_) => EmojiPickerSheet(onEmojiSelected: onEmojiSelected),
    );
  }

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  String _query = '';
  late final TabController _tabController;

  final _categories = _kEmojiCategories.keys.toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _searchResults {
    if (_query.isEmpty) return const [];
    return _kEmojiCategories.values
        .expand((e) => e)
        .where((e) => e.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = _query.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: RelayColors.spacingSm),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(RelayColors.radiusPill),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: RelayColors.spacingMd,
            ),
            child: TextField(
              controller: _searchCtrl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search emoji',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: _searchCtrl.clear,
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(RelayColors.radiusPill),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: RelayColors.spacingMd,
                  vertical: RelayColors.spacingXs,
                ),
              ),
            ),
          ),

          const SizedBox(height: RelayColors.spacingXs),

          if (!isSearching)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: RelayColors.spacingSm,
              ),
              tabs: _categories
                  .map((c) => Tab(text: c, height: 36))
                  .toList(),
            ),

          Expanded(
            child: isSearching
                ? _EmojiGrid(
                    emojis: _searchResults,
                    onTap: _pick,
                    scrollController: scrollController,
                  )
                : TabBarView(
                    controller: _tabController,
                    children: _categories.map((cat) {
                      return _EmojiGrid(
                        emojis: _kEmojiCategories[cat]!,
                        onTap: _pick,
                        scrollController: scrollController,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  void _pick(String emoji) {
    Navigator.of(context).pop();
    widget.onEmojiSelected(emoji);
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({
    required this.emojis,
    required this.onTap,
    required this.scrollController,
  });

  final List<String> emojis;
  final ValueChanged<String> onTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (emojis.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(RelayColors.spacingSm),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 48,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        return Tooltip(
          message: emoji,
          child: InkWell(
            borderRadius: BorderRadius.circular(RelayColors.radiusSm),
            onTap: () => onTap(emoji),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
        );
      },
    );
  }
}
