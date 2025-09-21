import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/adaptive_form_layout.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/services/smart_validation_service.dart';
import 'package:part_catalog/features/suppliers/widgets/validation_feedback_widget.dart';

/// Шаг 3: Настройка аутентификации
class AuthenticationStep extends StatefulWidget {
  final SupplierConfig? config;
  final Function(SupplierConfig) onConfigChanged;

  const AuthenticationStep({
    super.key,
    this.config,
    required this.onConfigChanged,
  });

  @override
  State<AuthenticationStep> createState() => _AuthenticationStepState();
}

class _AuthenticationStepState extends State<AuthenticationStep> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  AuthenticationType _selectedAuthType = AuthenticationType.basic;
  bool _obscurePassword = true;
  ValidationResult? _credentialsValidationResult;

  @override
  void initState() {
    super.initState();
    final credentials = widget.config?.apiConfig.credentials;
    _selectedAuthType = widget.config?.apiConfig.authType ?? AuthenticationType.basic;
    _usernameController.text = credentials?.username ?? '';
    _passwordController.text = credentials?.password ?? '';
    _apiKeyController.text = credentials?.apiKey ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Настройка аутентификации',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Выберите тип аутентификации и введите данные для входа',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          FormSection(
            title: 'Тип аутентификации',
            children: [
              _buildAuthTypeSelection(),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          FormSection(
            title: 'Данные для входа',
            children: [
              _buildCredentialsForm(),
            ],
          ),

          SizedBox(height: AdaptiveSpacing.sectionSpacing(context)),

          _buildAuthInfo(),
        ],
      ),
    );
  }

  Widget _buildAuthTypeSelection() {
    return Column(
      children: AuthenticationType.values.map((type) {
        final isSelected = _selectedAuthType == type;
        return Card(
          color: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3)
              : null,
          child: ListTile(
            leading: Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(_getAuthTypeName(type)),
            subtitle: Text(_getAuthTypeDescription(type)),
            onTap: () => _updateAuthType(type),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCredentialsForm() {
    switch (_selectedAuthType) {
      case AuthenticationType.basic:
        return AdaptiveFormLayout(
          fields: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Имя пользователя',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: _updateCredentials,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              onChanged: _updateCredentials,
            ),
            ValidationFeedbackWidget(result: _credentialsValidationResult),
          ],
        );

      case AuthenticationType.apiKey:
        return AdaptiveFormLayout(
          fields: [
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API ключ',
                helperText: 'Введите ваш API ключ для доступа к сервису',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
              onChanged: _updateCredentials,
            ),
            ValidationFeedbackWidget(result: _credentialsValidationResult),
          ],
        );

      case AuthenticationType.bearer:
        return AdaptiveFormLayout(
          fields: [
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Bearer токен',
                helperText: 'Введите Bearer токен для авторизации',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.security),
              ),
              onChanged: _updateCredentials,
            ),
            ValidationFeedbackWidget(result: _credentialsValidationResult),
          ],
        );

      case AuthenticationType.oauth2:
      case AuthenticationType.custom:
        return Card(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.construction,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Данный тип аутентификации пока не поддерживается.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );

      case AuthenticationType.none:
        return Card(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Аутентификация не требуется. API доступен без авторизации.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildAuthInfo() {
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
                  Icons.security,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Безопасность данных',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Все данные аутентификации шифруются и хранятся в безопасном формате. '
              'Пароли и ключи не передаются третьим лицам и используются только '
              'для подключения к API поставщика.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Рекомендации:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            ...([
              'Используйте уникальные пароли для каждого API',
              'Регулярно обновляйте ключи доступа',
              'Проверяйте права доступа в личном кабинете поставщика',
            ].map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
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

  String _getAuthTypeDescription(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.basic:
        return 'Аутентификация по логину и паролю (наиболее распространенный)';
      case AuthenticationType.apiKey:
        return 'Использование API ключа в заголовках запроса';
      case AuthenticationType.bearer:
        return 'Bearer токен в заголовке Authorization';
      case AuthenticationType.none:
        return 'API не требует аутентификации';
      case AuthenticationType.oauth2:
        return 'OAuth 2.0 аутентификация (в разработке)';
      case AuthenticationType.custom:
        return 'Пользовательская аутентификация (в разработке)';
    }
  }

  void _updateAuthType(AuthenticationType type) {
    setState(() {
      _selectedAuthType = type;
    });
    _updateCredentials('');
  }

  void _updateCredentials(String _) {
    if (widget.config != null) {
      SupplierCredentials? credentials;

      switch (_selectedAuthType) {
        case AuthenticationType.basic:
          credentials = SupplierCredentials(
            username: _usernameController.text,
            password: _passwordController.text,
          );
          break;
        case AuthenticationType.apiKey:
        case AuthenticationType.bearer:
          credentials = SupplierCredentials(
            apiKey: _apiKeyController.text,
          );
          break;
        case AuthenticationType.none:
          credentials = null;
          break;
        case AuthenticationType.oauth2:
        case AuthenticationType.custom:
          // TODO: Implement OAuth2 and custom authentication
          credentials = null;
          break;
      }

      final updatedConfig = widget.config!.copyWith(
        apiConfig: widget.config!.apiConfig.copyWith(
          authType: _selectedAuthType,
          credentials: credentials,
        ),
      );
      widget.onConfigChanged(updatedConfig);

      // Выполняем умную валидацию
      _validateCredentialsSmart();
    }
  }

  void _validateCredentialsSmart() {
    final supplierCode = widget.config?.supplierCode ?? 'custom';
    final result = SmartValidationService.validateCredentials(
      _selectedAuthType,
      widget.config?.apiConfig.credentials,
      supplierCode,
    );

    setState(() {
      _credentialsValidationResult = result;
    });
  }
}
