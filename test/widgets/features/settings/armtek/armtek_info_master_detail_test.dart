import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/settings/armtek/widgets/armtek_info_master_detail.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_item.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('ArmtekInfoMasterDetail Widget Tests', () {
    late UserStructureRoot mockStructure;

    setUp(() {
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
  });
}