import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Вкладка основных настроек поставщика
class BasicSettingsTab extends ConsumerWidget {
  final String? supplierCode;

  const BasicSettingsTab({
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
    // TODO: Добавить notifier после создания провайдера

    return FormScreenScaffold.settings(
      title: '', // Заголовок уже в TabbedScreen
      children: [
        // Секция статуса
        _StatusSection(
          isEnabled: config?.isEnabled ?? true,
          onToggle: (value) {}, // TODO: implement
        ),

        // Секция основной информации
        _BasicInfoSection(
          displayName: config?.displayName ?? '',
          onDisplayNameChanged: (value) {}, // TODO: implement
        ),
      ],
    );
  }
}

/// Секция статуса поставщика
class _StatusSection extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const _StatusSection({
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Статус поставщика'.asH5(),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Icon(
                  isEnabled ? Icons.toggle_on : Icons.toggle_off,
                  color: isEnabled ? Colors.green : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'Активность'.asBodyMedium(),
                      (isEnabled
                        ? 'Поставщик активен и участвует в поиске'
                        : 'Поставщик отключен'
                      ).asBodySmall(color: isEnabled
                        ? Colors.green.shade600
                        : Colors.grey.shade600
                      ),
                    ],
                  ),
                ),

                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Индикатор статуса
            if (isEnabled)
              'Активен'.asSuccessStatus(style: StatusStyle.outlined)
            else
              'Отключен'.asErrorStatus(style: StatusStyle.outlined),
          ],
        ),
      ),
    );
  }
}

/// Секция основной информации
class _BasicInfoSection extends StatelessWidget {
  final String displayName;
  final ValueChanged<String> onDisplayNameChanged;

  const _BasicInfoSection({
    required this.displayName,
    required this.onDisplayNameChanged,
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
                const Icon(Icons.business, color: Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                'Основная информация'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            ValidationField(
              label: 'Название поставщика',
              hint: 'Введите отображаемое название',
              value: displayName,
              onChanged: onDisplayNameChanged,
              prefixIcon: const Icon(Icons.business),
              validationRules: const [
                RequiredRule('Название обязательно для заполнения'),
                MinLengthRule(2, 'Минимум 2 символа'),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Подсказка
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: 'Это название будет отображаться в интерфейсе приложения'
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