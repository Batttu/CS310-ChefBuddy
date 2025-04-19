import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Cheff Buddy app loads HomeScreen', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const CheffBuddyApp());

    // Verify that HomeScreen UI appears
    expect(find.text('Cheff Buddy'), findsOneWidget); // AppBar title
    expect(find.byType(TextField), findsOneWidget);   // Search bar
  });
}
