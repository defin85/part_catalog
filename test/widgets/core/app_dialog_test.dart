import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:part_catalog/core/widgets/app_dialog.dart';

void main() {
  group('AppDialog Widget Tests', () {
    testWidgets('should display title and content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDialog(
              title: const Text('Test Title'),
              content: const Text('Test Content'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('should be an AlertDialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppDialog(
              title: Text('Title'),
              content: Text('Content'),
              actions: [],
            ),
          ),
        ),
      );

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}