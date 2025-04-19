import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:namer_app/main.dart'; // make sure this points to your actual main.dart

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build your actual app
    await tester.pumpWidget(const ChefBuddyApp());

    // Since your app is no longer the default counter app,
    // this part is probably irrelevant unless you manually added a counter
    // So you can remove or rewrite these assertions based on your UI

    // Example: check if home page title exists
    expect(find.text('Find best recipes'), findsOneWidget);
  });
}

