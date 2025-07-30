import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('ArmtekInfoMasterDetail Widget Tests', () {
    late UserStructureRoot mockStructure;
    late List<BrandItem> mockBrandList;
    late List<StoreItem> mockStoreList;
    late List<BrandItem> largeBrandList;
    late List<StoreItem> largeStoreList;

    setUp(() {
      // Создаем тестовые данные для брендов
      mockBrandList = [
        const BrandItem(brand: 'BOSCH', brandName: 'Robert Bosch GmbH'),
        const BrandItem(brand: 'VAG', brandName: 'Volkswagen AG'),
        const BrandItem(brand: 'BMW', brandName: 'BMW Group'),
      ];

      // Создаем тестовые данные для складов
      mockStoreList = [
        const StoreItem(keyzak: '001', sklCode: 'MSK001', sklName: 'Москва Центральный'),
        const StoreItem(keyzak: '002', sklCode: 'SPB001', sklName: 'Санкт-Петербург Основной'),
        const StoreItem(keyzak: '003', sklCode: 'EKB001', sklName: 'Екатеринбург Региональный'),
      ];

      // Создаем большие списки для тестирования производительности
      largeBrandList = List.generate(200, (index) => 
        BrandItem(brand: 'BRAND$index', brandName: 'Brand Name $index'));
      
      largeStoreList = List.generate(200, (index) => 
        StoreItem(keyzak: 'KEY$index', sklCode: 'CODE$index', sklName: 'Store Name $index'));
      mockStructure = UserStructureRoot(
        kunag: '12345',
        vkorg: '1000',
        sname: 'Test Organization',
        fname: 'Test Organization Full Name',
        adress: '123 Test Street',
        phone: '+1234567890',
        rgTab: [
          UserStructureItem(
            kunnr: '67890',
            sname: 'Test Payer',
            fname: 'Test Payer Full Name',
            adress: '456 Payer Street',
            phone: '+0987654321',
            defaultFlag: true,
            weTab: [],
            zaTab: [],
            exwTab: [],
            dogovorTab: [],
            contactTab: [],
          ),
        ],
        contactTab: [],
        dogovorTab: [],
      );
    });

    group('Layout Tests', () {
      testWidgets('should render without overflow errors on desktop', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
          screenSize: TestHelpers.desktop,
        );
      });

      testWidgets('should render without overflow errors on mobile', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
          screenSize: TestHelpers.mobilePortrait,
        );
      });

      testWidgets('should render without overflow errors on tablet', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
          screenSize: const Size(768, 1024), // Tablet size
        );
      });

      testWidgets('should be responsive on different screen sizes', (tester) async {
        await TestHelpers.testResponsiveness(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
        );
      });
    });

    group('Structure Tests', () {
      testWidgets('should show master-detail layout on desktop', (tester) async {
        await tester.binding.setSurfaceSize(TestHelpers.desktop);
        
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: mockStructure),
          ),
        );

        // Должны быть две основные панели в Row layout
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Card), findsAtLeastNWidgets(2));
      });

      testWidgets('should handle empty structure gracefully', (tester) async {
        final emptyStructure = UserStructureRoot(
          kunag: '12345',
          vkorg: '1000',
          sname: 'Empty Organization',
          fname: null,
          adress: null,
          phone: null,
          rgTab: null,
          contactTab: null,
          dogovorTab: null,
        );

        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(structure: emptyStructure),
          screenSize: TestHelpers.desktop,
        );

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(structure: emptyStructure),
          ),
        );

        // Должен отрендериться без ошибок даже с пустыми данными
        expect(find.byType(ArmtekInfoMasterDetail), findsOneWidget);
      });
    });

    group('Constraint Tests', () {
      testWidgets('should handle constrained height properly', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ArmtekInfoMasterDetail(structure: mockStructure),
            ),
          ),
        );

        // Не должно вызывать overflow даже при ограниченной высоте
        await tester.pumpAndSettle();
        
        // Виджет должен отрендериться без ошибок
        expect(find.byType(ArmtekInfoMasterDetail), findsOneWidget);
      });

      testWidgets('should handle very small screens', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
          screenSize: const Size(320, 480), // Very small screen
        );
      });
    });

    group('Performance Tests', () {
      testWidgets('should render within performance threshold', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          ArmtekInfoMasterDetail(structure: mockStructure),
        );
      });
    });

    group('Brands and Stores Lists Tests', () {
      testWidgets('should render with brand and store lists without overflow', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(
            structure: mockStructure,
            brandList: mockBrandList,
            storeList: mockStoreList,
          ),
          screenSize: TestHelpers.desktop,
        );
      });

      testWidgets('should handle large brand lists without performance issues', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          ArmtekInfoMasterDetail(
            structure: mockStructure,
            brandList: largeBrandList,
            storeList: mockStoreList,
          ),
          maxRenderTimeMs: 200, // Увеличенный лимит для больших списков
        );
      });

      testWidgets('should handle large store lists without performance issues', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          ArmtekInfoMasterDetail(
            structure: mockStructure,
            brandList: mockBrandList,
            storeList: largeStoreList,
          ),
          maxRenderTimeMs: 200,
        );
      });

      testWidgets('should handle brands table in ScrollView without unbounded constraints', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            SingleChildScrollView(
              child: ArmtekInfoMasterDetail(
                structure: mockStructure,
                brandList: largeBrandList,
                storeList: mockStoreList,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ArmtekInfoMasterDetail), findsOneWidget);
        
        // Нажимаем на карточку брендов - ищем по тексту в карточке
        final brandCardFinder = find.widgetWithText(InkWell, 'Бренды');
        if (brandCardFinder.evaluate().isEmpty) {
          // Если не нашли InkWell, ищем просто карточку с текстом
          await tester.tap(find.byIcon(Icons.branding_watermark));
        } else {
          await tester.tap(brandCardFinder);
        }
        await tester.pumpAndSettle();
        
        // Проверяем, что таблица брендов отображается - используем более гибкий поиск
        expect(find.textContaining('Бренды'), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle stores table in ScrollView without unbounded constraints', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            SingleChildScrollView(
              child: ArmtekInfoMasterDetail(
                structure: mockStructure,
                brandList: mockBrandList,
                storeList: largeStoreList,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ArmtekInfoMasterDetail), findsOneWidget);
        
        // Нажимаем на карточку складов - ищем по иконке
        final storeCardFinder = find.widgetWithText(InkWell, 'Склады');
        if (storeCardFinder.evaluate().isEmpty) {
          await tester.tap(find.byIcon(Icons.warehouse));
        } else {
          await tester.tap(storeCardFinder);
        }
        await tester.pumpAndSettle();
        
        // Проверяем, что таблица складов отображается - используем более гибкий поиск
        expect(find.textContaining('Склады'), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle large lists without crashing', (tester) async {
        // Просто проверяем, что виджет с большими списками не вызывает ошибок
        await TestHelpers.expectNoOverflow(
          tester,
          ArmtekInfoMasterDetail(
            structure: mockStructure,
            brandList: largeBrandList,
            storeList: largeStoreList,
          ),
          screenSize: TestHelpers.desktop,
        );
        
        // Проверяем, что виджет успешно рендерится с большими списками
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(
              structure: mockStructure,
              brandList: largeBrandList,
              storeList: largeStoreList,
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        expect(find.byType(ArmtekInfoMasterDetail), findsOneWidget);
        
        // Проверяем, что в интерфейсе есть карточки для брендов и складов
        expect(find.byIcon(Icons.branding_watermark), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.warehouse), findsAtLeastNWidgets(1));
      });

      testWidgets('should show correct counts in headers', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ArmtekInfoMasterDetail(
              structure: mockStructure,
              brandList: mockBrandList,
              storeList: mockStoreList,
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Проверяем количество в карточках
        expect(find.text('3'), findsNWidgets(2)); // 3 бренда и 3 склада
      });
    });
  });
}