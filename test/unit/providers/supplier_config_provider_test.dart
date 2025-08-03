import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

void main() {
  group('SupplierConfigFormProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with empty state', () {
      final provider = supplierConfigFormProvider('test');
      final state = container.read(provider);

      expect(state.config, isNull);
      expect(state.isLoading, false);
      expect(state.isTesting, false);
      expect(state.isLoadingVkorgList, false);
      expect(state.error, isNull);
      expect(state.validationErrors, isEmpty);
      expect(state.availableVkorgList, isEmpty);
    });

    test('should update config when updateConfig called', () {
      final provider = supplierConfigFormProvider('test');
      final notifier = container.read(provider.notifier);

      final testConfig = SupplierConfig(
        supplierCode: 'test',
        displayName: 'Test Supplier',
        isEnabled: true,
        apiConfig: SupplierApiConfig(
          baseUrl: 'http://test.api',
          authType: AuthenticationType.basic,
        ),
      );

      notifier.updateConfig(testConfig);

      final state = container.read(provider);
      expect(state.config, equals(testConfig));
      expect(state.error, isNull);
    });

    test('should validate config correctly', () {
      final provider = supplierConfigFormProvider('test');
      final notifier = container.read(provider.notifier);

      // Тест с пустой конфигурацией
      expect(notifier.validate(), false);

      final state = container.read(provider);
      expect(state.validationErrors, isNotEmpty);
    });

    test('should handle selectVkorg correctly', () {
      final provider = supplierConfigFormProvider('test');
      final notifier = container.read(provider.notifier);

      // Создаем базовую конфигурацию
      final testConfig = SupplierConfig(
        supplierCode: 'test',
        displayName: 'Test Supplier',
        isEnabled: true,
        apiConfig: SupplierApiConfig(
          baseUrl: 'http://test.api',
          authType: AuthenticationType.basic,
          credentials: SupplierCredentials(),
        ),
      );

      notifier.updateConfig(testConfig);
      notifier.selectVkorg('4000');

      final state = container.read(provider);
      expect(
        state.config?.apiConfig.credentials?.additionalParams?['VKORG'],
        equals('4000'),
      );
    });

    group('Error handling', () {
      test('should handle validation errors correctly', () {
        final provider = supplierConfigFormProvider('test');
        final notifier = container.read(provider.notifier);

        // Валидируем пустую конфигурацию
        final isValid = notifier.validate();

        expect(isValid, false);
        final state = container.read(provider);
        expect(state.validationErrors, contains('Конфигурация не задана'));
      });

      test('should clear errors when config updated', () {
        final provider = supplierConfigFormProvider('test');
        final notifier = container.read(provider.notifier);

        // Сначала создаем ошибку
        notifier.validate();
        expect(container.read(provider).validationErrors, isNotEmpty);

        // Обновляем конфигурацию
        final testConfig = SupplierConfig(
          supplierCode: 'test',
          displayName: 'Test Supplier',
          isEnabled: true,
          apiConfig: SupplierApiConfig(
            baseUrl: 'http://test.api',
            authType: AuthenticationType.basic,
          ),
        );

        notifier.updateConfig(testConfig);

        final state = container.read(provider);
        expect(state.error, isNull);
      });
    });

    group('State management', () {
      test('should handle loading states correctly', () {
        final provider = supplierConfigFormProvider('test');
        final initialState = container.read(provider);

        expect(initialState.isLoading, false);
        expect(initialState.isTesting, false);
        expect(initialState.isLoadingVkorgList, false);
      });

      test('should manage VKORG list correctly', () {
        final provider = supplierConfigFormProvider('test');
        final initialState = container.read(provider);

        expect(initialState.availableVkorgList, isEmpty);
      });
    });
  });

  group('SupplierConfigsProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should handle enabled configs filter', () {
      final provider = enabledSupplierConfigsProvider;
      final configs = container.read(provider);

      expect(configs, isA<List<SupplierConfig>>());
    });

    test('should handle usage stats', () {
      const supplierCode = 'test';
      final provider = supplierUsageStatsProvider(supplierCode);
      final stats = container.read(provider);

      expect(stats, isA<Map<String, dynamic>>());
      expect(stats.containsKey('dailyUsed'), true);
    });
  });
}