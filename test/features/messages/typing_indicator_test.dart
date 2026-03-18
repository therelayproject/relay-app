import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/shared/widgets/typing_indicator.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('TypingIndicator', () {
    testWidgets('renders nothing when typingUserNames is empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(const TypingIndicator(typingUserNames: [])),
      );
      await tester.pumpAndSettle();

      // SizedBox.shrink returns an empty box — no Text or dots visible.
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.textContaining('typing'), findsNothing);
    });

    testWidgets('shows "X is typing" for a single user', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: ['Alice']),
        ),
      );
      await tester.pump(); // start animations

      expect(find.text('Alice is typing'), findsOneWidget);
    });

    testWidgets('shows "X and Y are typing" for two users', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: ['Alice', 'Bob']),
        ),
      );
      await tester.pump();

      expect(find.text('Alice and Bob are typing'), findsOneWidget);
    });

    testWidgets('shows "Several people are typing" for 3+ users', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(
            typingUserNames: ['Alice', 'Bob', 'Charlie'],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Several people are typing'), findsOneWidget);
    });

    testWidgets('has liveRegion semantics when users are typing', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: ['Alice']),
        ),
      );
      await tester.pump();

      // Verify the Semantics widget with liveRegion is in the tree.
      final semantics = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLiveRegion = semantics.any((s) => s.properties.liveRegion ?? false);
      expect(hasLiveRegion, isTrue);
    });

    testWidgets('hides when typingUserNames changes to empty', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: ['Alice']),
        ),
      );
      await tester.pump();
      expect(find.text('Alice is typing'), findsOneWidget);

      // Rebuild with empty list.
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('typing'), findsNothing);
    });

    testWidgets('renders animated dots when users are typing', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const TypingIndicator(typingUserNames: ['Alice']),
        ),
      );
      await tester.pump();

      // Three dot containers are rendered inside _DotsAnimation.
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      expect(opacityWidgets.length, greaterThanOrEqualTo(3));
    });
  });
}
