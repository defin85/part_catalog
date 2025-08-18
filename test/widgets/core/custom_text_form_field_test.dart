import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:part_catalog/core/widgets/custom_text_form_field.dart';

void main() {
  group('CustomTextFormField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    // Базовые тесты
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextFormField(
              controller: controller,
              labelText: 'Test Label',
            ),
          ),
        ),
      );

      expect(find.byType(CustomTextFormField), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('should handle text input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextFormField(
              controller: controller,
              labelText: 'Test Label',
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Hello World');
      expect(controller.text, 'Hello World');
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('should show hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextFormField(
              controller: controller,
              labelText: 'Test Label',
              hintText: 'Enter text here',
            ),
          ),
        ),
      );

      expect(find.text('Enter text here'), findsOneWidget);
    });

    testWidgets('should validate input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: CustomTextFormField(
                controller: controller,
                labelText: 'Required Field',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'This field is required' : null,
              ),
            ),
          ),
        ),
      );

      // Валидируем пустое поле
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();
      await tester.pump();

      expect(isValid, false);
      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}