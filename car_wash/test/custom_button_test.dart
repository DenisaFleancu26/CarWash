import 'package:car_wash/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomButton displays text correctly!',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onTap: () {},
            withGradient: false,
            text: 'Button',
            rowText: false,
          ),
        ),
      ),
    );

    final textFinder = find.text('Button');

    expect(textFinder, findsOneWidget);
  });

  testWidgets('CustomButton onTap works correctly!',
      (WidgetTester tester) async {
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onTap: () {
              buttonPressed = true;
            },
            withGradient: false,
            text: 'Button',
            rowText: false,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Button'));

    expect(buttonPressed, true);
  });
}
