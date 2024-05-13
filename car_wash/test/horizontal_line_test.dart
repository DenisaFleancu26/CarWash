import 'package:car_wash/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HorizontalLine renders correctly!', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HorizontalLine(distance: 10.0),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);

    final containerWidget = tester.widget<Container>(find.byType(Container));
    expect(containerWidget.margin, EdgeInsets.symmetric(vertical: 10.0));
  });
}
