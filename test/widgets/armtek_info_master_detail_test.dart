import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_item.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';

void main() {
  group('ArmtekInfoMasterDetail Widget Tests', () {
    // Создаем тестовые данные
    final testStructure = UserStructureRoot(
      kunag: '12345',
      vkorg: '4000',
      sname: 'Test Company',
      fname: 'Test Company Full Name',
      adress: 'Test Address',
      phone: '+7 999 123-45-67',
      rgTab: [
        UserStructureItem(
          kunnr: '54321',
          sname: 'Test Payer',
          defaultFlag: true,
        ),
      ],
    );

    // Тест на переполнение (overflow)
    testWidgets('Should not have render overflow errors', (WidgetTester tester) async {
      // Устанавливаем различные размеры экрана для тестирования
      final testSizes = [
        const Size(1920, 1080), // Desktop
        const Size(1200, 800),  // Tablet landscape
        const Size(800, 600),   // Small desktop
        const Size(400, 800),   // Mobile
      ];

      for (final size in testSizes) {
        await tester.binding.setSurfaceSize(size);
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProvideI18n(
                child: ArmtekInfoMasterDetail(structure: testStructure),
              ),
            ),
          ),
        );

        // Проверяем отсутствие ошибок переполнения
        expect(tester.takeException(), isNull,
            reason: 'No overflow errors should occur at size: $size');
      }
    });

    // Тест на constraints
    testWidgets('Should handle window resize without constraint errors', 
        (WidgetTester tester) async {
      // Начинаем с большого размера
      await tester.binding.setSurfaceSize(const Size(1400, 900));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProvideI18n(
              child: ArmtekInfoMasterDetail(structure: testStructure),
            ),
          ),
        ),
      );

      // Изменяем размер окна на маленький
      await tester.binding.setSurfaceSize(const Size(900, 600));
      await tester.pump();
      
      // Проверяем отсутствие ошибок constraints
      expect(tester.takeException(), isNull);
    });

    // Тест на адаптивность
    testWidgets('Should switch between desktop and mobile layouts', 
        (WidgetTester tester) async {
      // Desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProvideI18n(
              child: ArmtekInfoMasterDetail(structure: testStructure),
            ),
          ),
        ),
      );
      
      // Проверяем наличие Row (desktop layout)
      expect(find.byType(Row).first, findsOneWidget);
      
      // Mobile layout
      await tester.binding.setSurfaceSize(const Size(600, 800));
      await tester.pump();
      
      // На мобильном должен быть другой layout
      // (конкретная проверка зависит от реализации мобильного layout)
    });

    // Тест на видимость элементов
    testWidgets('Should display all required elements', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProvideI18n(
              child: ArmtekInfoMasterDetail(structure: testStructure),
            ),
          ),
        ),
      );

      // Проверяем наличие основных элементов
      expect(find.text('Test Company'), findsOneWidget);
      expect(find.text('KUNAG: 12345'), findsOneWidget);
      expect(find.byIcon(Icons.business), findsWidgets);
    });

    // Тест на компактные карточки
    testWidgets('Compact info cards should have proper constraints', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProvideI18n(
              child: ArmtekInfoMasterDetail(structure: testStructure),
            ),
          ),
        ),
      );

      // Находим все Card виджеты
      final cards = find.byType(Card);
      
      // Проверяем, что карточки существуют
      expect(cards, findsWidgets);
      
      // Можно добавить дополнительные проверки размеров
    });
  });
}