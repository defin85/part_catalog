import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/services/smart_validation_service.dart';
import 'package:part_catalog/features/suppliers/widgets/validation_feedback_widget.dart';

/// Шаг 2: Настройка подключения
class ConnectionSetupStep extends StatefulWidget {
  final SupplierConfig? config;
  final Function(SupplierConfig) onConfigChanged;

  const ConnectionSetupStep({
    super.key,
    this.config,
    required this.onConfigChanged,
  });

  @override
  State<ConnectionSetupStep> createState() => _ConnectionSetupStepState();
}

class _ConnectionSetupStepState extends State<ConnectionSetupStep> {
  final TextEditingController _baseUrlController = TextEditingController();
  bool _useProxy = false;
  ValidationResult? _urlValidationResult;
  bool _isValidatingUrl = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController.text = widget.config?.apiConfig.baseUrl ?? '';
    _useProxy = widget.config?.apiConfig.connectionMode == ApiConnectionMode.proxy;
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Настройка подключения',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Укажите базовый URL для API поставщика и режим подключения',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          FormSection(
            title: 'URL подключения',
            children: [
              AdaptiveFormLayout(
                fields: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UrlAutoCompleteWidget(
                        supplierCode: widget.config?.supplierCode ?? 'custom',
                        currentValue: _baseUrlController.text,
                        controller: _baseUrlController,
                        onSelected: _updateBaseUrl,
                      ),
                      ValidationFeedbackWidget(result: _urlValidationResult),
                      if (_isValidatingUrl)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Проверяем доступность URL...',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          FormSection(
            title: 'Режим подключения',
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Использовать прокси'),
                        subtitle: Text(
                          _useProxy
                              ? 'Подключение через прокси-сервер (рекомендуется для продакшена)'
                              : 'Прямое подключение к API (для разработки и тестирования)',
                        ),
                        value: _useProxy,
                        onChanged: _updateUseProxy,
                      ),
                      const SizedBox(height: 8),
                      _buildConnectionModeInfo(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          _buildConnectionTips(),
        ],
      ),
    );
  }

  Widget _buildConnectionModeInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _useProxy ? Icons.security : Icons.warning_outlined,
            color: _useProxy
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _useProxy ? 'Безопасное подключение' : 'Прямое подключение',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  _useProxy
                      ? 'Запросы идут через наш прокси-сервер. Повышенная безопасность и стабильность.'
                      : 'Прямые запросы к API поставщика. Быстрее, но менее безопасно.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTips() {
    return Card(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Советы по настройке',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...([
              'Убедитесь, что URL доступен из вашей сети',
              'Для HTTPS соединений проверьте валидность сертификата',
              'В режиме прокси аутентификация проходит через наш сервер',
              'Для отладки используйте прямое подключение',
            ].map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ))),
          ],
        ),
      ),
    );
  }

  void _validateUrlSmart(String url) async {
    final supplierCode = widget.config?.supplierCode ?? 'custom';

    // Мгновенная валидация формата
    final formatResult = SmartValidationService.validateUrl(url, supplierCode);
    setState(() {
      _urlValidationResult = formatResult;
    });

    // Если формат корректный, проверяем доступность
    if (formatResult.isValid && url.isNotEmpty) {
      setState(() {
        _isValidatingUrl = true;
      });

      try {
        final accessResult = await SmartValidationService.quickUrlCheck(url);
        setState(() {
          _urlValidationResult = accessResult;
          _isValidatingUrl = false;
        });
      } catch (e) {
        setState(() {
          _urlValidationResult = ValidationResult.error(
            'Ошибка проверки URL: $e',
          );
          _isValidatingUrl = false;
        });
      }
    }
  }

  void _updateBaseUrl(String value) {
    if (widget.config != null) {
      final updatedConfig = widget.config!.copyWith(
        apiConfig: widget.config!.apiConfig.copyWith(baseUrl: value),
      );
      widget.onConfigChanged(updatedConfig);
    }

    // Выполняем умную валидацию
    _validateUrlSmart(value);
  }

  void _updateUseProxy(bool value) {
    setState(() {
      _useProxy = value;
    });

    if (widget.config != null) {
      final updatedConfig = widget.config!.copyWith(
        apiConfig: widget.config!.apiConfig.copyWith(
          connectionMode: value ? ApiConnectionMode.proxy : ApiConnectionMode.direct,
        ),
      );
      widget.onConfigChanged(updatedConfig);
    }
  }
}
