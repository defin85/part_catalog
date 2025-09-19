import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/services/smart_validation_service.dart';
import 'package:part_catalog/features/suppliers/widgets/validation_feedback_widget.dart';

/// Шаг 5: Завершение настройки
class CompletionStep extends ConsumerStatefulWidget {
  final SupplierConfig? config;
  final Future<void> Function() onSave;

  const CompletionStep({
    super.key,
    this.config,
    required this.onSave,
  });

  @override
  ConsumerState<CompletionStep> createState() => _CompletionStepState();
}

class _CompletionStepState extends ConsumerState<CompletionStep> {
  bool _isTesting = false;
  bool _isSaving = false;
  bool _testPassed = false;
  String? _testError;
  List<ValidationResult> _validationResults = [];

  @override
  Widget build(BuildContext context) {
    // Проверяем конфигурацию при каждом отображении
    _validateConfiguration();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Завершение настройки',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Проверьте настройки и завершите конфигурацию поставщика',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Success Icon
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Configuration Summary
          FormSection(
            title: 'Сводка настроек',
            children: [
              _buildConfigurationSummary(),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Валидация конфигурации
          FormSection(
            title: 'Проверка настроек',
            children: [
              _buildValidationResults(),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Test Connection
          FormSection(
            title: 'Проверка подключения',
            children: [
              _buildConnectionTest(),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          // Final Actions
          FormSection(
            title: 'Завершение',
            children: [
              _buildFinalActions(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationSummary() {
    if (widget.config == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Конфигурация не задана'),
        ),
      );
    }

    final config = widget.config!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryItem(
              'Поставщик',
              config.displayName,
              Icons.business,
            ),
            const Divider(),
            _buildSummaryItem(
              'Тип',
              config.supplierCode.toUpperCase(),
              Icons.category,
            ),
            const Divider(),
            _buildSummaryItem(
              'URL подключения',
              config.apiConfig.baseUrl,
              Icons.link,
            ),
            const Divider(),
            _buildSummaryItem(
              'Аутентификация',
              _getAuthTypeName(config.apiConfig.authType),
              Icons.security,
            ),
            if (config.supplierCode == 'armtek') ...[
              const Divider(),
              _buildSummaryItem(
                'VKORG',
                config.apiConfig.credentials?.additionalParams?['VKORG'] ?? 'Не задан',
                Icons.account_tree,
              ),
              if (config.businessConfig?.customerCode?.isNotEmpty == true) ...[
                const Divider(),
                _buildSummaryItem(
                  'Код клиента',
                  config.businessConfig!.customerCode!,
                  Icons.person,
                ),
              ],
            ],
            const Divider(),
            _buildSummaryItem(
              'Режим подключения',
              config.apiConfig.connectionMode == ApiConnectionMode.proxy ? 'Через прокси' : 'Прямое',
              config.apiConfig.connectionMode == ApiConnectionMode.proxy ? Icons.security : Icons.link,
              color: config.apiConfig.connectionMode == ApiConnectionMode.proxy
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const Divider(),
            _buildSummaryItem(
              'Статус',
              config.isEnabled ? 'Активен' : 'Отключен',
              config.isEnabled ? Icons.check_circle : Icons.pause_circle,
              color: config.isEnabled
                  ? Colors.green
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTest() {
    return Card(
      color: _testPassed
          ? Colors.green.withOpacity(0.1)
          : _testError != null
              ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_testPassed)
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Подключение успешно проверено!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              )
            else if (_testError != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ошибка подключения:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _testError!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Рекомендуется проверить подключение перед сохранением',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.wifi_tethering),
                label: Text(_isTesting ? 'Проверка...' : 'Проверить подключение'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalActions() {
    return Column(
      children: [
        if (!_testPassed && _testError == null)
          Card(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Совет: Проверьте подключение перед сохранением, '
                      'чтобы убедиться в правильности настроек.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        AdaptiveFormLayout(
          fields: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveConfiguration,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Сохранение...' : 'Сохранить и завершить'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getAuthTypeName(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.basic:
        return 'Basic Authentication';
      case AuthenticationType.apiKey:
        return 'API Key';
      case AuthenticationType.bearer:
        return 'Bearer Token';
      case AuthenticationType.none:
        return 'Без аутентификации';
      case AuthenticationType.oauth2:
        return 'OAuth 2.0';
      case AuthenticationType.custom:
        return 'Пользовательский';
    }
  }

  Future<void> _testConnection() async {
    if (widget.config == null) return;

    setState(() {
      _isTesting = true;
      _testError = null;
      _testPassed = false;
    });

    try {
      final service = ref.read(supplierServiceProvider);
      final result = await service.testConnection(widget.config!);

      setState(() {
        _isTesting = false;
        if (result.success) {
          _testPassed = true;
          _testError = null;
        } else {
          _testPassed = false;
          _testError = result.errorMessage ?? 'Неизвестная ошибка';
        }
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _testPassed = false;
        _testError = e.toString();
      });
    }
  }

  Future<void> _saveConfiguration() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Конфигурация успешно сохранена!'),
            backgroundColor: Colors.green,
          ),
        );
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
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _validateConfiguration() {
    if (widget.config != null) {
      final results = SmartValidationService.validateFullConfig(widget.config!);
      if (_validationResults != results) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _validationResults = results;
          });
        });
      }
    }
  }

  Widget _buildValidationResults() {
    if (_validationResults.isEmpty) {
      return Card(
        color: Colors.green.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Конфигурация прошла все проверки!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        MultiValidationFeedbackWidget(
          results: _validationResults,
          showSuccessMessage: false,
        ),
        if (_validationResults.any((r) => !r.isValid))
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Card(
              color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Необходимо исправить ошибки перед сохранением',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}