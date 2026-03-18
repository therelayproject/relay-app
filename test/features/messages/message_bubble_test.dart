import 'package:flutter_test/flutter_test.dart';

import 'package:relay/features/messages/domain/models/message.dart';
import 'package:relay/features/messages/domain/models/reaction.dart';
import 'package:relay/features/messages/presentation/widgets/message_bubble.dart';

import '../../helpers/test_helpers.dart';

void main() {
  // Common base message
  const _baseCreatedAt = '2024-01-01T12:00:00.000Z';

  Message _msg({
    String text = 'Hello, world!',
    int replyCount = 0,
    bool deleted = false,
    bool edited = false,
    List<Reaction> reactions = const [],
  }) =>
      Message.fromJson(
        messageJson(
          text: text,
          replyCount: replyCount,
          deleted: deleted,
          edited: edited,
          createdAt: _baseCreatedAt,
          reactions: reactions
              .map((r) => {
                    'emoji': r.emoji,
                    'count': r.count,
                    'userIds': r.userIds,
                  })
              .toList(),
        ),
      );

  group('MessageBubble', () {
    testWidgets('renders author name and message text', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('shows deleted placeholder for deleted messages', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg(deleted: true))),
      );
      await tester.pumpAndSettle();

      expect(find.text('This message was deleted.'), findsOneWidget);
      expect(find.text('Hello, world!'), findsNothing);
    });

    testWidgets('shows "(edited)" label for edited messages', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg(edited: true))),
      );
      await tester.pumpAndSettle();

      expect(find.text('(edited)'), findsOneWidget);
    });

    testWidgets('does not show "(edited)" for unedited messages', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg())),
      );
      await tester.pumpAndSettle();

      expect(find.text('(edited)'), findsNothing);
    });

    testWidgets('shows reply count link when replyCount > 0', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg(replyCount: 3))),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('3 replies'), findsOneWidget);
    });

    testWidgets('shows "1 reply" (singular) when replyCount == 1', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg(replyCount: 1))),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('1 reply'), findsOneWidget);
    });

    testWidgets('does not show reply link when replyCount == 0', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg())),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('repl'), findsNothing);
    });

    testWidgets('renders reaction emoji and count', (tester) async {
      const reaction = Reaction(emoji: '👍', count: 2, userIds: []);
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: _msg(reactions: [reaction])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('👍'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('has semantics label for accessibility', (tester) async {
      await tester.pumpWidget(
        buildTestable(MessageBubble(message: _msg(text: 'Accessibility test'))),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(find.text('Accessibility test'));
      expect(semantics, isNotNull);
    });
  });
}
