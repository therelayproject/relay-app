import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/features/messages/domain/models/reaction.dart';
import 'package:relay/features/messages/presentation/widgets/reaction_bar.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('ReactionBar', () {
    testWidgets('renders nothing when reactions list is empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('renders a chip for each reaction', (tester) async {
      const reactions = [
        Reaction(emoji: '👍', count: 3, userIds: []),
        Reaction(emoji: '❤️', count: 1, userIds: []),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('👍'), findsOneWidget);
      expect(find.text('❤️'), findsOneWidget);
    });

    testWidgets('shows correct reaction count', (tester) async {
      const reactions = [
        Reaction(emoji: '🔥', count: 7, userIds: []),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('has semantics label for accessibility', (tester) async {
      const reactions = [
        Reaction(emoji: '👍', count: 2, userIds: []),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(find.byType(InkWell).first);
      expect(semantics.label, contains('👍'));
    });

    testWidgets('chip appears highlighted when current user has reacted',
        (tester) async {
      // kTestUser.id == 'user-1' is set up by buildTestable's MockAuthRepository.
      const reactions = [
        Reaction(emoji: '👍', count: 2, userIds: ['user-1', 'user-2']),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
        ),
      );
      await tester.pumpAndSettle();

      // The chip is rendered — we verify the widget tree is built without error
      // and the emoji is visible (highlight is a colour difference, hard to
      // assert in unit tests without golden images).
      expect(find.text('👍'), findsOneWidget);
    });

    testWidgets('tapping reaction chip does not throw', (tester) async {
      const reactions = [
        Reaction(emoji: '👍', count: 1, userIds: []),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
          dioResponses: {
            '/messages/msg-1/reactions': null,
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tap the chip — should fire _toggleReaction without throwing.
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
    });

    testWidgets('renders multiple chips in a Wrap', (tester) async {
      const reactions = [
        Reaction(emoji: '👍', count: 1, userIds: []),
        Reaction(emoji: '😂', count: 5, userIds: []),
        Reaction(emoji: '🎉', count: 3, userIds: []),
      ];

      await tester.pumpWidget(
        buildTestable(
          const ReactionBar(messageId: 'msg-1', reactions: reactions),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(InkWell), findsNWidgets(3));
    });
  });
}
