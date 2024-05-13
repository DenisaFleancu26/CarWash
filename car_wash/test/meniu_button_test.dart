import 'package:car_wash/widgets/meniu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MeniuButton works correctly!', (WidgetTester tester) async {
    IconData testIcon = Icons.home;
    String? testLabel = 'Home';
    bool buttonTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeniuButton(
            icon: testIcon,
            label: testLabel,
            onTap: () {
              buttonTapped = true;
            },
          ),
        ),
      ),
    );

    final button = find.byType(MeniuButton);

    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(buttonTapped, true);

    final icon = find.byIcon(testIcon);
    expect(icon, findsOneWidget);

    final label = find.text(testLabel);
    expect(label, findsOneWidget);
  });
}
