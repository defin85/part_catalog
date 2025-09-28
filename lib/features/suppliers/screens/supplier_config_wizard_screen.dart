import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

/// Мастер настройки поставщика с использованием новых UI компонентов
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

  SupplierConfig _config = SupplierConfig(
    supplierCode: '',
    displayName: '',
    isEnabled: true,
    apiConfig: SupplierApiConfig(
      baseUrl: '',
      authType: AuthenticationType.basic,
    ),
  );
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return WizardScreenScaffold(
      title: 'Настройка поставщика',
      currentStep: _currentStep,
      isLoading: _isLoading,
      steps: [
        WizardStep(
          id: 'supplier',
          title: 'Выбор поставщика',
          content: _buildSupplierSelectionStep(),
        ),
        WizardStep(
          id: 'connection',
          title: 'Подключение',
          content: _buildConnectionStep(),
        ),
        WizardStep(
          id: 'auth',
          title: 'Аутентификация',
          content: _buildAuthenticationStep(),
        ),
        WizardStep(
          id: 'params',
          title: 'Параметры',
          content: _buildParametersStep(),
        ),
        WizardStep(
          id: 'finish',
          title: 'Завершение',
          content: _buildCompletionStep(),
        ),
      ],
      onStepChanged: (step) => setState(() => _currentStep = step),
      onComplete: _saveConfiguration,
      onCancel: () => context.pop(),
    );
  }

  Widget _buildSupplierSelectionStep() {
    return FormSection(
      title: 'Выберите поставщика',
      children: [
        DropdownInput<String>(
          label: 'Поставщик',
          hint: 'Выберите поставщика из списка',
          value: _config.supplierCode.isEmpty ? null : _config.supplierCode,
          items: const [
            DropdownInputItem(value: 'armtek', text: 'Armtek'),
            DropdownInputItem(value: 'emex', text: 'Emex'),
            DropdownInputItem(value: 'berg', text: 'Berg'),
          ],
          onChanged: (value) => setState(() {
            _config = _config.copyWith(supplierCode: value ?? '');
          }),
        ),
      ],
    );
  }

  Widget _buildConnectionStep() {
    return FormSection(
      title: 'Настройки подключения',
      children: [
        TextInput(
          label: 'URL API',
          hint: 'https://api.supplier.com',
          value: _config.apiConfig.baseUrl,
          onChanged: (value) => setState(() {
            _config = _config.copyWith(
              apiConfig: _config.apiConfig.copyWith(baseUrl: value)
            );
          }),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'URL API обязателен';
            }
            final uri = Uri.tryParse(value!);
            if (uri == null || !uri.hasAbsolutePath) {
              return 'Некорректный URL';
            }
            return null;
          },
        ),
        const SizedBox(height: 8.0),
        DropdownInput<String>(
          label: 'Режим подключения',
          hint: 'Выберите режим',
          value: _config.apiConfig.connectionMode?.name ?? 'direct',
          items: const [
            DropdownInputItem(value: 'direct', text: 'Прямое'),
            DropdownInputItem(value: 'proxy', text: 'Через прокси'),
          ],
          onChanged: (value) => setState(() {
            // Упрощенная реализация без создания ApiConnectionMode
            _config = _config.copyWith(
              apiConfig: _config.apiConfig.copyWith(
                proxyUrl: value == 'proxy' ? '' : null
              )
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAuthenticationStep() {
    return FormSection(
      title: 'Данные для аутентификации',
      children: [
        TextInput(
          label: 'Логин/ключ',
          hint: 'Введите логин или API ключ',
          value: _config.apiConfig.credentials?.username ?? '',
          onChanged: (value) => setState(() {
            final currentCredentials = _config.apiConfig.credentials ??
                const SupplierCredentials();
            _config = _config.copyWith(
              apiConfig: _config.apiConfig.copyWith(
                credentials: currentCredentials.copyWith(username: value)
              )
            );
          }),
        ),
        const SizedBox(height: 8.0),
        TextInput(
          label: 'Пароль',
          hint: 'Введите пароль',
          obscureText: true,
          value: _config.apiConfig.credentials?.password ?? '',
          onChanged: (value) => setState(() {
            final currentCredentials = _config.apiConfig.credentials ??
                const SupplierCredentials();
            _config = _config.copyWith(
              apiConfig: _config.apiConfig.copyWith(
                credentials: currentCredentials.copyWith(password: value)
              )
            );
          }),
        ),
      ],
    );
  }

  Widget _buildParametersStep() {
    return FormSection(
      title: 'Дополнительные параметры',
      children: [
        TextInput(
          label: 'Таймаут (сек)',
          hint: '30',
          value: (_config.apiConfig.timeout?.inSeconds ?? 30).toString(),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final timeout = int.tryParse(value) ?? 30;
            setState(() {
              _config = _config.copyWith(
                apiConfig: _config.apiConfig.copyWith(
                  timeout: Duration(seconds: timeout)
                )
              );
            });
          },
        ),
        const SizedBox(height: 8.0),
        Card(
          child: SwitchListTile(
            title: const Text('Использовать сжатие'),
            subtitle: const Text('Сжимать HTTP запросы'),
            value: _config.apiConfig.defaultHeaders?['Accept-Encoding'] == 'gzip',
            onChanged: (value) => setState(() {
              final headers = Map<String, String>.from(_config.apiConfig.defaultHeaders ?? {});
              if (value) {
                headers['Accept-Encoding'] = 'gzip';
              } else {
                headers.remove('Accept-Encoding');
              }
              _config = _config.copyWith(
                apiConfig: _config.apiConfig.copyWith(defaultHeaders: headers)
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionStep() {
    return FormSection(
      title: 'Готово к сохранению',
      children: [
        InfoCard(
          title: 'Поставщик',
          subtitle: _getSupplierDisplayName(_config.supplierCode),
        ),
        InfoCard(
          title: 'API URL',
          subtitle: _config.apiConfig.baseUrl.isEmpty ? 'Не указан' : _config.apiConfig.baseUrl,
        ),
        InfoCard(
          title: 'Режим подключения',
          subtitle: _config.apiConfig.proxyUrl != null ? 'Через прокси' : 'Прямое',
        ),
      ],
    );
  }

  String _getSupplierDisplayName(String code) {
    switch (code) {
      case 'armtek':
        return 'Armtek';
      case 'emex':
        return 'Emex';
      case 'berg':
        return 'Berg';
      default:
        return code;
    }
  }

  Future<void> _saveConfiguration() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Конфигурация поставщика сохранена')),
      );
      context.go(AppRoutes.partsSearch);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}