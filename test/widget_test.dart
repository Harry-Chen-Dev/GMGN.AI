import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmgn_clone/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GMGNApp());

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Login page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const GMGNApp());
    await tester.pumpAndSettle();

    // Should display login elements
    expect(find.text('登录'), findsWidgets);
  });
}