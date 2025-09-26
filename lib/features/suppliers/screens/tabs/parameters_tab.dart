import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Вкладка бизнес-параметров поставщика
class ParametersTab extends ConsumerWidget {
  final String? supplierCode;

  const ParametersTab({
    super.key,
    this.supplierCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(supplierConfigProvider(supplierCode ?? ''));

    return configAsync.when(
      data: (config) => _buildContent(context, ref, config),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Ошибка загрузки: $error'),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, SupplierConfig? config) {

    return FormScreenScaffold.settings(
      title: '', // Заголовок уже в TabbedScreen
      children: [
        if (supplierCode == 'armtek')
          _ArmtekParametersSection(
            businessConfig: config?.businessConfig,
            onParametersChanged: (params) {}, // TODO: implement
          )
        else
          _GenericParametersSection(
            businessConfig: config?.businessConfig,
            onParametersChanged: (params) {}, // TODO: implement
          ),

        // Дополнительные настройки
        _AdditionalSettingsSection(
          config: config,
          onConfigChanged: (updatedConfig) {}, // TODO: implement
        ),
      ],
    );
  }
}

/// Секция параметров для Armtek
class _ArmtekParametersSection extends StatelessWidget {
  final dynamic businessConfig;
  final ValueChanged<dynamic> onParametersChanged;

  const _ArmtekParametersSection({
    required this.businessConfig,
    required this.onParametersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final vkorg = businessConfig?.additionalParams?['VKORG'] as String?;
    final customerCode = businessConfig?.customerCode as String?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.orange),
                const SizedBox(width: AppSpacing.sm),
                'Параметры Armtek'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // VKORG (Код организации)
            DropdownInput<String>(
              label: 'VKORG (Код организации)',
              hint: 'Выберите организацию',
              value: vkorg,
              items: ['1000', '2000', '3000'].map((vkorg) =>
                DropdownInputItem(
                  value: vkorg,
                  text: 'VKORG $vkorg',
                  icon: const Icon(Icons.business_center),
                ),
              ).toList(),
              onChanged: (value) {
                onParametersChanged({
                  'additionalParams': {'VKORG': value},
                  'customerCode': customerCode,
                });
              },
              prefixIcon: const Icon(Icons.business_center),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Код клиента
            ValidationField(
              label: 'Код клиента',
              hint: 'Введите код клиента в системе Армтек',
              value: customerCode ?? '',
              onChanged: (value) {
                onParametersChanged({
                  'additionalParams': {'VKORG': vkorg},
                  'customerCode': value,
                });
              },
              prefixIcon: const Icon(Icons.account_box),
              validationRules: const [
                MinLengthRule(3, 'Код должен содержать минимум 3 символа'),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Подсказки
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      'Важные параметры для Армтек'.asBodyMedium(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  '• VKORG - код организации в системе SAP Армтек'
                    .asBodySmall(color: Colors.orange.shade700),
                  '• Код клиента - ваш уникальный номер в системе поставщика'
                    .asBodySmall(color: Colors.orange.shade700),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Секция параметров для других поставщиков
class _GenericParametersSection extends StatelessWidget {
  final dynamic businessConfig;
  final ValueChanged<dynamic> onParametersChanged;

  const _GenericParametersSection({
    required this.businessConfig,
    required this.onParametersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final customerCode = businessConfig?.customerCode as String?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                'Дополнительные параметры'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            ValidationField(
              label: 'Код клиента',
              hint: 'Введите ваш код в системе поставщика',
              value: customerCode ?? '',
              onChanged: (value) {
                onParametersChanged({'customerCode': value});
              },
              prefixIcon: const Icon(Icons.account_box),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Icon(Icons.help_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: 'Код клиента используется для идентификации в API поставщика'
                    .asCaption(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Секция дополнительных настроек
class _AdditionalSettingsSection extends StatelessWidget {
  final SupplierConfig? config;
  final ValueChanged<SupplierConfig> onConfigChanged;

  const _AdditionalSettingsSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, color: Colors.grey),
                const SizedBox(width: AppSpacing.sm),
                'Дополнительные настройки'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Таймаут запросов
            ValidationField(
              label: 'Таймаут запросов (сек)',
              hint: '30',
              value: '30', // Placeholder
              onChanged: (value) {
                // TODO: Implement timeout setting
              },
              prefixIcon: const Icon(Icons.timer),
              keyboardType: TextInputType.number,
              validationRules: const [
                RequiredRule(),
                // TODO: Add number validation rule
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Количество попыток
            ValidationField(
              label: 'Максимум попыток',
              hint: '3',
              value: '3', // Placeholder
              onChanged: (value) {
                // TODO: Implement retry count setting
              },
              prefixIcon: const Icon(Icons.refresh),
              keyboardType: TextInputType.number,
              validationRules: const [
                RequiredRule(),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Подсказка
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: 'Эти настройки влияют на производительность и надежность соединения'
                    .asCaption(color: Colors.blue.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}