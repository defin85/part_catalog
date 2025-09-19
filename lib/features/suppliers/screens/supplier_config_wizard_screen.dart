import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/widgets/wizard_steps/supplier_selection_step.dart';
import 'package:part_catalog/features/suppliers/widgets/wizard_steps/connection_setup_step.dart';
import 'package:part_catalog/features/suppliers/widgets/wizard_steps/authentication_step.dart';
import 'package:part_catalog/features/suppliers/widgets/wizard_steps/additional_parameters_step.dart';
import 'package:part_catalog/features/suppliers/widgets/wizard_steps/completion_step.dart';
import 'package:part_catalog/features/suppliers/services/smart_validation_service.dart';

/// Мастер пошаговой настройки поставщика
class SupplierConfigWizardScreen extends ConsumerStatefulWidget {
  final String? supplierCode;

  const SupplierConfigWizardScreen({
    super.key,
    this.supplierCode,
  });

  @override
  ConsumerState<SupplierConfigWizardScreen> createState() =>
      _SupplierConfigWizardScreenState();
}

class _SupplierConfigWizardScreenState
    extends ConsumerState<SupplierConfigWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  SupplierConfig? _config;

  final List<WizardStepInfo> _steps = [
    WizardStepInfo(
      title: 'Выбор поставщика',
      description: 'Выберите тип поставщика',
      icon: Icons.business,
    ),
    WizardStepInfo(
      title: 'Подключение',
      description: 'Настройка базового URL',
      icon: Icons.link,
    ),
    WizardStepInfo(
      title: 'Аутентификация',
      description: 'Данные для входа',
      icon: Icons.security,
    ),
    WizardStepInfo(
      title: 'Дополнительно',
      description: 'Специфичные настройки',
      icon: Icons.settings,
    ),
    WizardStepInfo(
      title: 'Завершение',
      description: 'Проверка и сохранение',
      icon: Icons.check_circle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Если передан код поставщика, создаем базовую конфигурацию
    if (widget.supplierCode != null) {
      final service = ref.read(supplierServiceProvider);
      _config = service.createFromTemplate(widget.supplierCode!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мастер настройки поставщика'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('К обычной форме'),
            ),
        ],
      ),
      body: ResponsiveLayoutBuilder(
        small: (context, constraints) => _buildMobileLayout(),
        medium: (context, constraints) => _buildTabletLayout(),
        large: (context, constraints) => _buildDesktopLayout(),
        mediumBreakpoint: 600,
        largeBreakpoint: 1000,
      ),
    );
  }

  /// Мобильная компоновка - вертикальный layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileStepIndicator(),
        Expanded(
          child: _buildStepContent(),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  /// Планшетная компоновка - горизонтальный индикатор сверху
  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildTabletStepIndicator(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AdaptiveSpacing.padding(context)),
            child: _buildStepContent(),
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  /// Десктопная компоновка - боковая панель с шагами
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _buildDesktopSidebar(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AdaptiveSpacing.padding(context)),
                  child: _buildStepContent(),
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ],
    );
  }

  /// Мобильный индикатор шагов
  Widget _buildMobileStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Text(
            'Шаг ${_currentStep + 1} из ${_steps.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Планшетный индикатор шагов
  Widget _buildTabletStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: _steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : isActive
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surfaceVariant,
                        child: Icon(
                          isCompleted ? Icons.check : step.icon,
                          color: isCompleted || isActive
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: isActive ? FontWeight.w600 : null,
                              color: isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (index < _steps.length - 1)
                  Container(
                    height: 2,
                    width: 24,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Десктопная боковая панель
  Widget _buildDesktopSidebar() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Настройка поставщика',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final step = _steps[index];
                final isActive = index == _currentStep;
                final isCompleted = index < _currentStep;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : isActive
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      isCompleted ? Icons.check : step.icon,
                      color: isCompleted || isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w600 : null,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () => _goToStep(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Контент текущего шага
  Widget _buildStepContent() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentStep = index;
        });
      },
      children: [
        SupplierSelectionStep(
          config: _config,
          onConfigChanged: _updateConfig,
        ),
        ConnectionSetupStep(
          config: _config,
          onConfigChanged: _updateConfig,
        ),
        AuthenticationStep(
          config: _config,
          onConfigChanged: _updateConfig,
        ),
        AdditionalParametersStep(
          config: _config,
          onConfigChanged: _updateConfig,
        ),
        CompletionStep(
          config: _config,
          onSave: _saveConfig,
        ),
      ],
    );
  }

  /// Кнопки навигации
  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(AdaptiveSpacing.padding(context)),
      child: ResponsiveLayoutBuilder(
        small: (context, constraints) => Column(
          children: [
            if (_currentStep < _steps.length - 1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceedToNext() ? _nextStep : null,
                  child: const Text('Далее'),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Назад'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
        medium: (context, constraints) => Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Назад'),
              ),
            const Spacer(),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Отмена'),
            ),
            const SizedBox(width: 8),
            if (_currentStep < _steps.length - 1)
              ElevatedButton(
                onPressed: _canProceedToNext() ? _nextStep : null,
                child: const Text('Далее'),
              ),
          ],
        ),
        large: (context, constraints) => Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Назад'),
              ),
            const Spacer(),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Отмена'),
            ),
            const SizedBox(width: 8),
            if (_currentStep < _steps.length - 1)
              ElevatedButton(
                onPressed: _canProceedToNext() ? _nextStep : null,
                child: const Text('Далее'),
              ),
          ],
        ),
      ),
    );
  }

  /// Переход к следующему шагу
  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Переход к предыдущему шагу
  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Переход к конкретному шагу
  void _goToStep(int step) {
    if (step >= 0 && step < _steps.length) {
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Проверка возможности перехода к следующему шагу
  bool _canProceedToNext() {
    if (_config == null) return false;

    switch (_currentStep) {
      case 0: // Выбор поставщика
        return _config!.supplierCode.isNotEmpty &&
               _config!.displayName.isNotEmpty;

      case 1: // Подключение
        final urlResult = SmartValidationService.validateUrl(
          _config!.apiConfig.baseUrl,
          _config!.supplierCode,
        );
        return urlResult.isValid;

      case 2: // Аутентификация
        final credentialsResult = SmartValidationService.validateCredentials(
          _config!.apiConfig.authType,
          _config!.apiConfig.credentials,
          _config!.supplierCode,
        );
        return credentialsResult.isValid;

      case 3: // Дополнительные параметры
        // Проверяем общую валидность конфигурации
        final allResults = SmartValidationService.validateFullConfig(_config!);
        return !allResults.any((result) => !result.isValid);

      default:
        return false;
    }
  }

  /// Обновление конфигурации
  void _updateConfig(SupplierConfig config) {
    setState(() {
      _config = config;
    });
  }

  /// Сохранение конфигурации
  Future<void> _saveConfig() async {
    if (_config != null) {
      try {
        await ref
            .read(supplierConfigsProvider.notifier)
            .saveConfig(_config!);
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка сохранения: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

/// Информация о шаге мастера
class WizardStepInfo {
  final String title;
  final String description;
  final IconData icon;

  const WizardStepInfo({
    required this.title,
    required this.description,
    required this.icon,
  });
}