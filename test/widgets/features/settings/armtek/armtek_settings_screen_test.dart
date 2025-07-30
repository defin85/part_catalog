import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/settings/armtek/screens/armtek_settings_screen.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('ArmtekSettingsScreen Widget Tests', () {
    group('Layout Tests', () {
      testWidgets('should render without overflow errors', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          const ArmtekSettingsScreen(),
        );
      });

      testWidgets('should be responsive on different screen sizes', (tester) async {
        await TestHelpers.testResponsiveness(
          tester,
          const ArmtekSettingsScreen(),
        );
      });
    });

    group('Basic Structure Tests', () {
      testWidgets('should have app bar with title', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const ArmtekSettingsScreen(),
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Настройки Armtek'), findsOneWidget);
      });

      testWidgets('should have login form fields', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const ArmtekSettingsScreen(),
          ),
        );

        // Ждем загрузки виджета
        await tester.pumpAndSettle();

        // Должны быть поля для логина и пароля
        expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
      });
    });

    group('Performance Tests', () {
      testWidgets('should render within performance threshold', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          const ArmtekSettingsScreen(),
        );
      });
    });
  });
}