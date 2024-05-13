import 'package:car_wash/widgets/custom_entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomEntryField works correctly!', (WidgetTester tester) async {
    String testTitle = 'Password';
    TextEditingController controller = TextEditingController();
    bool hasObscureText = true;
    bool obscureText = true;
    IconData testIconData = Icons.lock;
    String? testErrorMessage = 'Invalid password';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomEntryField(
            title: testTitle,
            controller: controller,
            hasObscureText: hasObscureText,
            obscureText: obscureText,
            iconData: testIconData,
            errorMessage: testErrorMessage,
            onTap: () {
              obscureText = false;
            },
          ),
        ),
      ),
    );

    final entryField = find.byType(CustomEntryField);

    expect(entryField, findsOneWidget);

    final title = find.text(testTitle);
    expect(title, findsOneWidget);

    final errorMessage = find.text(testErrorMessage);
    expect(errorMessage, findsOneWidget);

    final icon = find.byIcon(testIconData);
    expect(icon, findsOneWidget);

    final gestureDetector = find.descendant(
      of: entryField,
      matching: find.byType(GestureDetector),
    );

    await tester.tap(gestureDetector);
    await tester.pump();

    expect(obscureText, false);
  });
}
