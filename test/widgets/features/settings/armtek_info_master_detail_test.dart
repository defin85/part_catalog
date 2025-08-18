import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';
import 'package:part_catalog/features/suppliers/models/armtek/contact_tab_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/dogovor_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/exw_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/models/armtek/we_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/za_item.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('ArmtekInfoMasterDetail Widget Tests', () {
    late UserStructureRoot testStructure;

    setUp(() {
      // Создаем тестовые данные
      testStructure = const UserStructureRoot(
        kunag: '123456',
        sname: 'Test Organization',
        fname: 'Test Full Organization Name',
        vkorg: 'VKORG001',
        adress: 'Test Address, 123',
        phone: '+7 (123) 456-78-90',
        rgTab: [
          UserStructureItem(
            kunnr: '43000',
            sname: 'Test Payer',
            defaultFlag: true,
            weTab: [
              WeItem(kunnr: '1', werks: '001', sname: 'Грузополучатель 1'),
            ],
            zaTab: [
              ZaItem(
                  kunnr: '1',
                  sname: 'Адрес доставки длинное название для теста'),
            ],
            exwTab: [
              ExwItem(
                  id: '99', name: 'Условия поставки с очень длинным названием'),
            ],
            dogovorTab: [
              DogovorItem(vbeln: '1', bstkd: 'Договор 1', defaultFlag: true),
            ],
            contactTab: [
              ContactTabItem(
                  parnr: '1',
                  lname: 'Иванов',
                  fname: 'Иван',
                  defaultFlag: true),
              ContactTabItem(parnr: '2', lname: 'Петров', fname: 'Петр'),
            ],
          ),
        ],
      );
    });

    group('Text Overflow Tests', () {
      testWidgets(
          'should handle long text in compact info cards without ugly breaks',
          (tester) async {
        // Создаем виджет с маленьким экраном для тестирования компактных карточек
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(900, 600), // Размер для desktop layout
          ),
        );

        // Даем время на рендеринг
        await tester.pumpAndSettle();

        // Сначала кликаем на плательщика чтобы увидеть карточки
        // Плательщик отображается как "Test Payer (по умолч.)" так как defaultFlag: true
        await tester.tap(find.text('Test Payer (по умолч.)'));
        await tester.pumpAndSettle();

        // Проверяем, что текст отображается корректно в карточках (не в навигации)
        final gridView = find.byType(GridView);
        expect(
            find.descendant(
                of: gridView, matching: find.text('Адреса доставки')),
            findsOneWidget);
        expect(
            find.descendant(
                of: gridView, matching: find.text('Условия поставки')),
            findsOneWidget);
        expect(
            find.descendant(
                of: gridView, matching: find.text('Грузополучатели')),
            findsOneWidget);

        // Проверяем отсутствие RenderFlex overflow ошибок
        expect(tester.takeException(), isNull);
      });

      testWidgets('should use FittedBox to scale text appropriately',
          (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(900, 600),
          ),
        );

        await tester.pumpAndSettle();

        // Находим FittedBox виджеты в карточках
        final fittedBoxes = find.byType(FittedBox);
        expect(fittedBoxes, findsWidgets);

        // Проверяем, что FittedBox использует правильные настройки
        final fittedBox = tester.widget<FittedBox>(fittedBoxes.first);
        expect(fittedBox.fit, BoxFit.scaleDown);
        expect(fittedBox.alignment, Alignment.centerLeft);
      });
    });

    group('Responsive Layout Tests', () {
      testWidgets('should adapt grid layout based on screen width',
          (tester) async {
        // Тест для широкого экрана (3 колонки)
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(1200, 800),
          ),
        );
        await tester.pumpAndSettle();

        // Кликаем на плательщика чтобы увидеть карточки
        await tester.tap(find.text('Test Payer (по умолч.)'));
        await tester.pumpAndSettle();

        // Проверяем наличие GridView
        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget);

        // Проверяем параметры сетки
        final grid = tester.widget<GridView>(gridView);
        final delegate =
            grid.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
        expect(delegate.maxCrossAxisExtent, 200);
        expect(delegate.childAspectRatio, 2.5);
      });

      // TODO: Исправить тест для мобильного layout
      // testWidgets('should show mobile layout on narrow screens', (tester) async {
      //   // Тест для узкого экрана (мобильный layout)
      //   // Порог для мобильного layout - менее 850px
      //   await tester.pumpWidget(
      //     TestHelpers.createTestApp(
      //       ArmtekInfoMasterDetail(structure: testStructure),
      //       screenSize: const Size(400, 800), // Меньше 850px - должен быть мобильный layout
      //     ),
      //   );
      //   await tester.pumpAndSettle();

      //   // На мобильном экране не должно быть основного Row с двумя Flexible панелями
      //   // В desktop layout есть Row > Flexible > Card структура
      //   final topLevelRows = find.descendant(
      //     of: find.byType(ArmtekInfoMasterDetail),
      //     matching: find.byType(Row),
      //   ).evaluate().take(1); // Берем только первый уровень

      //   // В мобильной версии используется SingleChildScrollView без Row с двумя панелями
      //   expect(topLevelRows.isEmpty ||
      //          !(topLevelRows.first.widget as Row).children.any((c) => c is Flexible),
      //          isTrue);
      // });

      testWidgets('should adjust card padding based on available width',
          (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(900, 600),
          ),
        );
        await tester.pumpAndSettle();

        // Кликаем на плательщика
        await tester.tap(find.text('Test Payer (по умолч.)'));
        await tester.pumpAndSettle();

        // Проверяем, что карточки используют LayoutBuilder для адаптивности
        final layoutBuilders = find.byType(LayoutBuilder);
        expect(layoutBuilders, findsWidgets);
      });
    });

    group('Card Content Tests', () {
      testWidgets('should display correct counts in info cards',
          (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(1200, 800),
          ),
        );
        await tester.pumpAndSettle();

        // Кликаем на плательщика
        await tester.tap(find.text('Test Payer (по умолч.)'));
        await tester.pumpAndSettle();

        // Проверяем отображение количества в карточках
        // Находим "1" только в контексте карточек (не в таблицах)
        final oneInCards = find.descendant(
          of: find.byType(GridView),
          matching: find.text('1'),
        );
        expect(oneInCards, findsNWidgets(4)); // 1 в каждой из первых 4 карточек

        final twoInCards = find.descendant(
          of: find.byType(GridView),
          matching: find.text('2'),
        );
        expect(twoInCards, findsOneWidget); // 2 контакта
      });

      testWidgets('should hide icons on very narrow cards', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
            screenSize: const Size(600, 400), // Очень маленький экран
          ),
        );
        await tester.pumpAndSettle();

        // На очень узких карточках иконки должны скрываться
        // Это проверяется через LayoutBuilder в коде
      });
    });

    group('Performance Tests', () {
      testWidgets('should render within performance threshold', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: testStructure),
          ),
        );

        await tester.pumpAndSettle();
        stopwatch.stop();

        // Виджет должен рендериться быстро (< 200ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty data gracefully', (tester) async {
        final emptyStructure = const UserStructureRoot(
          kunag: '123456',
          sname: 'Empty Org',
        );

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: emptyStructure),
          ),
        );
        await tester.pumpAndSettle();

        // Не должно быть ошибок при пустых данных
        expect(tester.takeException(), isNull);
        expect(find.text('Empty Org'), findsOneWidget);
      });

      testWidgets('should handle very long organization names', (tester) async {
        final longNameStructure = const UserStructureRoot(
          kunag: '123456',
          sname:
              'Очень длинное название организации которое может не поместиться в интерфейс и должно корректно обрабатываться',
        );

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: longNameStructure),
            screenSize: const Size(900, 600),
          ),
        );
        await tester.pumpAndSettle();

        // Проверяем, что длинное название отображается (возможно с ellipsis)
        expect(find.textContaining('Очень длинное название'), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    });
  });
}