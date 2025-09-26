import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/molecules/status_indicator.dart';
import 'package:part_catalog/core/ui/themes/app_colors.dart';

/// Карточка поставщика для управления API настройками
///
/// Отображает:
/// - Информацию о поставщике
/// - Статус настройки
/// - Кнопки действий
/// - Тестовые функции
class SupplierApiCard extends StatelessWidget {
  const SupplierApiCard({
    super.key,
    required this.name,
    required this.status,
    required this.isConfigured,
    this.icon = Icons.business_center,
    this.onConfigure,
    this.onConfigureWithWizard,
    this.onTest,
    this.onToggleTest,
    this.showTestControls = false,
  });

  final String name;
  final String status;
  final bool isConfigured;
  final IconData icon;
  final VoidCallback? onConfigure;
  final VoidCallback? onConfigureWithWizard;
  final VoidCallback? onTest;
  final VoidCallback? onToggleTest;
  final bool showTestControls;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              StatusIndicator(
                text: status,
                status: isConfigured ? StatusType.success : StatusType.warning,
                icon: isConfigured ? Icons.check_circle : Icons.warning,
                size: StatusSize.small,
              ),
            ],
          ),
        ),
        if (showTestControls && onToggleTest != null)
          _buildTestToggle(context),
      ],
    );
  }

  Widget _buildTestToggle(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            isConfigured ? Icons.toggle_on : Icons.toggle_off,
            color: isConfigured ? AppColors.success : AppColors.warning,
            size: 30,
          ),
          tooltip: 'Тест: ${isConfigured ? "Сделать не настроенным" : "Сделать настроенным"}',
          onPressed: onToggleTest,
        ),
        Text(
          'Тест',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (onConfigure != null)
          FilledButton.icon(
            onPressed: onConfigure,
            icon: const Icon(Icons.settings),
            label: const Text('Настроить'),
          ),
        if (onConfigureWithWizard != null)
          OutlinedButton.icon(
            onPressed: onConfigureWithWizard,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Через мастер'),
          ),
        if (onTest != null)
          OutlinedButton.icon(
            onPressed: onTest,
            icon: const Icon(Icons.network_check),
            label: const Text('Тестировать'),
          ),
      ],
    );
  }
}

/// Предустановленные варианты карточек поставщиков
class SupplierApiCardPresets {

  /// Карточка настроенного поставщика
  static SupplierApiCard configured({
    Key? key,
    required String name,
    String status = 'Настроен',
    IconData icon = Icons.business_center,
    VoidCallback? onConfigure,
    VoidCallback? onConfigureWithWizard,
    VoidCallback? onTest,
    bool showTestControls = false,
    VoidCallback? onToggleTest,
  }) {
    return SupplierApiCard(
      key: key,
      name: name,
      status: status,
      isConfigured: true,
      icon: icon,
      onConfigure: onConfigure,
      onConfigureWithWizard: onConfigureWithWizard,
      onTest: onTest,
      showTestControls: showTestControls,
      onToggleTest: onToggleTest,
    );
  }

  /// Карточка не настроенного поставщика
  static SupplierApiCard notConfigured({
    Key? key,
    required String name,
    String status = 'Не настроен',
    IconData icon = Icons.business_center,
    VoidCallback? onConfigure,
    VoidCallback? onConfigureWithWizard,
    VoidCallback? onTest,
    bool showTestControls = false,
    VoidCallback? onToggleTest,
  }) {
    return SupplierApiCard(
      key: key,
      name: name,
      status: status,
      isConfigured: false,
      icon: icon,
      onConfigure: onConfigure,
      onConfigureWithWizard: onConfigureWithWizard,
      onTest: onTest,
      showTestControls: showTestControls,
      onToggleTest: onToggleTest,
    );
  }

  /// Карточка с ошибкой подключения
  static SupplierApiCard error({
    Key? key,
    required String name,
    String status = 'Ошибка подключения',
    IconData icon = Icons.business_center,
    VoidCallback? onConfigure,
    VoidCallback? onConfigureWithWizard,
    VoidCallback? onTest,
    bool showTestControls = false,
    VoidCallback? onToggleTest,
  }) {
    return SupplierApiCard(
      key: key,
      name: name,
      status: status,
      isConfigured: false,
      icon: icon,
      onConfigure: onConfigure,
      onConfigureWithWizard: onConfigureWithWizard,
      onTest: onTest,
      showTestControls: showTestControls,
      onToggleTest: onToggleTest,
    );
  }
}