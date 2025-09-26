import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Вкладка настроек подключения к поставщику
class ConnectionSettingsTab extends ConsumerWidget {
  final String? supplierCode;

  const ConnectionSettingsTab({
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
        // Секция API настроек
        _ApiSettingsSection(
          baseUrl: config?.apiConfig.baseUrl ?? '',
          onBaseUrlChanged: (value) {}, // TODO: implement
          supplierCode: supplierCode,
        ),

        // Секция аутентификации
        _AuthenticationSection(
          authType: config?.apiConfig.authType ?? AuthenticationType.basic,
          credentials: config?.apiConfig.credentials,
          onAuthTypeChanged: (type) {}, // TODO: implement
          onCredentialsChanged: (creds) {}, // TODO: implement
        ),

        // Секция прокси
        _ProxySection(
          useProxy: config?.apiConfig.proxyUrl != null,
          proxyUrl: config?.apiConfig.proxyUrl,
          onProxyToggled: (use) {}, // TODO: implement
          onProxyUrlChanged: (url) {}, // TODO: implement
        ),
      ],
    );
  }
}

/// Секция API настроек
class _ApiSettingsSection extends StatelessWidget {
  final String baseUrl;
  final ValueChanged<String> onBaseUrlChanged;
  final String? supplierCode;

  const _ApiSettingsSection({
    required this.baseUrl,
    required this.onBaseUrlChanged,
    this.supplierCode,
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
                const Icon(Icons.api, color: Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                'API настройки'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            ValidationField(
              label: 'URL API',
              hint: _getUrlHint(),
              value: baseUrl,
              onChanged: onBaseUrlChanged,
              prefixIcon: const Icon(Icons.link),
              validationRules: [
                const RequiredRule('URL обязателен для заполнения'),
                const UrlRule('Введите корректный URL'),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Подсказки для конкретных поставщиков
            if (supplierCode == 'armtek') ...[
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue.shade600),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: 'Для Армтек обычно используется: https://ws.armtek.ru или https://api2.autotrade.su'
                      .asCaption(color: Colors.blue.shade600),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Icon(Icons.help_outline, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: 'Укажите полный URL до API поставщика'
                      .asCaption(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getUrlHint() {
    switch (supplierCode?.toLowerCase()) {
      case 'armtek':
        return 'https://ws.armtek.ru';
      case 'custom':
        return 'https://api.yourprovider.com';
      default:
        return 'https://api.supplier.com';
    }
  }
}

/// Секция аутентификации
class _AuthenticationSection extends StatelessWidget {
  final AuthenticationType authType;
  final dynamic credentials;
  final ValueChanged<AuthenticationType> onAuthTypeChanged;
  final ValueChanged<dynamic> onCredentialsChanged;

  const _AuthenticationSection({
    required this.authType,
    required this.credentials,
    required this.onAuthTypeChanged,
    required this.onCredentialsChanged,
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
                const Icon(Icons.security, color: Colors.green),
                const SizedBox(width: AppSpacing.sm),
                'Аутентификация'.asH5(),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Выбор типа аутентификации
            DropdownInput<AuthenticationType>(
              label: 'Тип аутентификации',
              value: authType,
              items: AuthenticationType.values.map((type) =>
                DropdownInputItem(
                  value: type,
                  text: _getAuthTypeName(type),
                  icon: Icon(_getAuthTypeIcon(type)),
                ),
              ).toList(),
              onChanged: (value) {
                if (value != null) onAuthTypeChanged(value);
              },
              prefixIcon: const Icon(Icons.vpn_key),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Поля для ввода credentials
            ..._buildAuthFields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAuthFields() {
    switch (authType) {
      case AuthenticationType.basic:
        return [
          ValidationField(
            label: 'Логин',
            value: credentials?.username ?? '',
            onChanged: (value) => onCredentialsChanged({'username': value}),
            prefixIcon: const Icon(Icons.person),
            validationRules: const [RequiredRule()],
          ),
          const SizedBox(height: AppSpacing.md),
          ValidationField(
            label: 'Пароль',
            value: credentials?.password ?? '',
            onChanged: (value) => onCredentialsChanged({'password': value}),
            prefixIcon: const Icon(Icons.lock),
            obscureText: true,
            validationRules: const [RequiredRule()],
          ),
        ];

      case AuthenticationType.apiKey:
      case AuthenticationType.bearer:
        return [
          ValidationField(
            label: authType == AuthenticationType.bearer ? 'Bearer токен' : 'API ключ',
            value: credentials?.apiKey ?? '',
            onChanged: (value) => onCredentialsChanged({'apiKey': value}),
            prefixIcon: Icon(authType == AuthenticationType.bearer
                ? Icons.token
                : Icons.key),
            validationRules: const [RequiredRule()],
          ),
        ];

      case AuthenticationType.none:
        return [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: 'Аутентификация отключена'
                    .asBodyMedium(color: Colors.orange.shade800),
                ),
              ],
            ),
          ),
        ];

      case AuthenticationType.oauth2:
      case AuthenticationType.custom:
        return [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.blue.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: 'Этот тип аутентификации будет добавлен позже'
                    .asBodyMedium(color: Colors.blue.shade800),
                ),
              ],
            ),
          ),
        ];
    }
  }

  String _getAuthTypeName(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.basic:
        return 'Логин/Пароль';
      case AuthenticationType.apiKey:
        return 'API ключ';
      case AuthenticationType.none:
        return 'Без аутентификации';
      case AuthenticationType.bearer:
        return 'Bearer токен';
      case AuthenticationType.oauth2:
        return 'OAuth 2.0';
      case AuthenticationType.custom:
        return 'Пользовательский';
    }
  }

  IconData _getAuthTypeIcon(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.basic:
        return Icons.person;
      case AuthenticationType.apiKey:
        return Icons.key;
      case AuthenticationType.none:
        return Icons.no_encryption;
      case AuthenticationType.bearer:
        return Icons.token;
      case AuthenticationType.oauth2:
        return Icons.verified_user;
      case AuthenticationType.custom:
        return Icons.settings;
    }
  }
}

/// Секция настроек прокси
class _ProxySection extends StatelessWidget {
  final bool useProxy;
  final String? proxyUrl;
  final ValueChanged<bool> onProxyToggled;
  final ValueChanged<String?> onProxyUrlChanged;

  const _ProxySection({
    required this.useProxy,
    required this.proxyUrl,
    required this.onProxyToggled,
    required this.onProxyUrlChanged,
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
                Icon(
                  useProxy ? Icons.vpn_lock : Icons.vpn_lock_outlined,
                  color: useProxy ? Colors.purple : Colors.grey,
                ),
                const SizedBox(width: AppSpacing.sm),
                'Прокси сервер'.asH5(),
                const Spacer(),
                Switch(
                  value: useProxy,
                  onChanged: onProxyToggled,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            if (useProxy) ...[
              'Подключение через прокси-сервер обеспечивает дополнительную безопасность'
                .asBodySmall(color: Colors.grey.shade600),

              const SizedBox(height: AppSpacing.lg),

              ValidationField(
                label: 'URL прокси-сервера',
                hint: 'https://proxy.company.com:8080',
                value: proxyUrl ?? '',
                onChanged: onProxyUrlChanged,
                prefixIcon: const Icon(Icons.vpn_lock),
                validationRules: const [
                  RequiredRule('Укажите URL прокси-сервера'),
                  UrlRule('Введите корректный URL'),
                ],
              ),
            ] else ...[
              'Прямое подключение к API поставщика без прокси'
                .asBodySmall(color: Colors.grey.shade600),
            ],

            const SizedBox(height: AppSpacing.sm),

            // Статус прокси
            if (useProxy)
              'Включен'.asInfoStatus(style: StatusStyle.outlined)
            else
              'Отключен'.asErrorStatus(style: StatusStyle.outlined),
          ],
        ),
      ),
    );
  }
}