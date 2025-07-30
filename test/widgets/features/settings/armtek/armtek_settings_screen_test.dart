import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:part_catalog/features/settings/armtek/screens/armtek_settings_screen.dart';
import 'package:part_catalog/features/settings/armtek/notifiers/armtek_settings_notifier.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import '../../../../helpers/test_helpers.dart';
import '../../../../mocks/mock_services.mocks.dart';

void main() {
  group('ArmtekSettingsScreen Widget Tests', () {
    late List<Override> testOverrides;
    late MockSupplierSettingsDao mockDao;
    late MockApiClientManager mockApiManager;

    setUp(() {
      mockDao = MockSupplierSettingsDao();
      mockApiManager = MockApiClientManager();
      
      // Setup service locator for ApiClientManager
      locator.reset();
      locator.registerSingleton<ApiClientManager>(mockApiManager);
      
      // Setup default mock behavior
      when(mockDao.getSupplierSettingByCode(any))
          .thenAnswer((_) async => null);

      testOverrides = [
        armtekSettingsNotifierProvider.overrideWith((ref) {
          final notifier = ArmtekSettingsNotifier(mockDao, mockApiManager);
          // Disable initial loading to avoid async issues in tests
          return notifier;
        }),
        supplierSettingsDaoProvider.overrideWithValue(mockDao),
      ];
    });

    group('Layout Tests', () {
      testWidgets('should render without overflow errors', (tester) async {
        await TestHelpers.expectNoOverflow(
          tester,
          const ArmtekSettingsScreen(),
          overrides: testOverrides,
        );
      });

      testWidgets('should be responsive on different screen sizes', (tester) async {
        await TestHelpers.testResponsiveness(
          tester,
          const ArmtekSettingsScreen(),
          overrides: testOverrides,
        );
      });
    });

    group('Basic Structure Tests', () {
      testWidgets('should have app bar with title', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const ArmtekSettingsScreen(),
            overrides: testOverrides,
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should have login form fields', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const ArmtekSettingsScreen(),
            overrides: testOverrides,
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
          overrides: testOverrides,
        );
      });
    });
  });
}