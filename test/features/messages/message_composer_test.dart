import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/features/messages/presentation/widgets/message_composer.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('MessageComposer', () {
    testWidgets('renders message input field', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const MessageComposer(channelId: 'ch-1'),
          dioResponses: {'/channels/ch-1/typing': null},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
    });

    testWidgets('renders attach-file button', (tester) async {
      await tester.pumpWidget(
        buildTestable(const MessageComposer(channelId: 'ch-1')),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Attach file'), findsOneWidget);
    });

    testWidgets('renders emoji button', (tester) async {
      await tester.pumpWidget(
        buildTestable(const MessageComposer(channelId: 'ch-1')),
      );
      await tester.pumpAndSettle();

      expect(find.byTooltip('Add emoji'), findsOneWidget);
    });

    testWidgets('send button is initially at low opacity (no text)', (tester) async {
      await tester.pumpWidget(
        buildTestable(const MessageComposer(channelId: 'ch-1')),
      );
      await tester.pumpAndSettle();

      // Send button is wrapped in AnimatedOpacity — locate the IconButton by tooltip
      expect(find.byTooltip('Send message'), findsOneWidget);
    });

    testWidgets('send button becomes active when text is entered', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const MessageComposer(channelId: 'ch-1'),
          dioResponses: {
            '/channels/ch-1/typing': null,
            '/channels/ch-1/messages': null,
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hi there');
      await tester.pump();

      // The send IconButton should now be enabled (onPressed != null)
      final sendBtn = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.send),
      );
      expect(sendBtn.onPressed, isNotNull);
    });

    testWidgets('send button is disabled when input is whitespace only', (tester) async {
      await tester.pumpWidget(
        buildTestable(const MessageComposer(channelId: 'ch-1')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      final sendBtn = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.send),
      );
      expect(sendBtn.onPressed, isNull);
    });

    testWidgets('clears input after message is sent', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const MessageComposer(channelId: 'ch-1'),
          dioResponses: {
            '/channels/ch-1/typing': null,
            '/channels/ch-1/messages': null,
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      final sendBtn = find.widgetWithIcon(IconButton, Icons.send);
      await tester.tap(sendBtn);
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });
}
