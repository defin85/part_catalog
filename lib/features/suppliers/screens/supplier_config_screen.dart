import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/core/widgets/custom_text_form_field.dart';
import 'package:part_catalog/core/widgets/section_title.dart';

/// Экран настройки поставщика
class SupplierConfigScreen extends ConsumerStatefulWidget {
  final String? supplierCode;

  const SupplierConfigScreen({
    super.key,
    this.supplierCode,
  });

  @override
  ConsumerState<SupplierConfigScreen> createState() => _SupplierConfigScreenState();
}

class _SupplierConfigScreenState extends ConsumerState<SupplierConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _baseUrlController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _vkorgController;
  late final TextEditingController _customerCodeController;
  
  AuthenticationType _selectedAuthType = AuthenticationType.basic;
  bool _useProxy = false;
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _baseUrlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _apiKeyController = TextEditingController();
    _vkorgController = TextEditingController();
    _customerCodeController = TextEditingController();
    
    // Загрузить существующую конфигурацию если есть
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.supplierCode != null) {
        _loadExistingConfig();
      }
    });
  }

  void _loadExistingConfig() {
    final config = ref.read(supplierConfigProvider(widget.supplierCode!));
    if (config != null) {
      _displayNameController.text = config.displayName;
      _baseUrlController.text = config.apiConfig.baseUrl;
      _selectedAuthType = config.apiConfig.authType;
      _useProxy = config.apiConfig.proxyUrl != null;
      _isEnabled = config.isEnabled;
      
      final creds = config.apiConfig.credentials;
      if (creds != null) {
        _usernameController.text = creds.username ?? '';
        _passwordController.text = creds.password ?? '';
        _apiKeyController.text = creds.apiKey ?? '';
        _vkorgController.text = creds.additionalParams?['VKORG'] ?? '';
      }
      
      final businessConfig = config.businessConfig;
      if (businessConfig != null) {
        _customerCodeController.text = businessConfig.customerCode ?? '';
      }
      
      // Обновить форму провайдера
      ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .updateConfig(config);
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _baseUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _apiKeyController.dispose();
    _vkorgController.dispose();
    _customerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(supplierConfigFormProvider(widget.supplierCode));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplierCode != null 
            ? 'Настройка ${widget.supplierCode}'
            : 'Новый поставщик'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Основная информация
            SectionTitle(title: 'Основная информация'),
            const SizedBox(height: 8),
            
            CustomTextFormField(
              controller: _displayNameController,
              labelText: 'Название поставщика',
              validator: (value) => value?.isEmpty ?? true 
                  ? 'Введите название' 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Активен'),
              subtitle: const Text('Включить поставщика в поиск'),
              value: _isEnabled,
              onChanged: (value) => setState(() => _isEnabled = value),
            ),
            
            const SizedBox(height: 24),
            
            // Настройки API
            SectionTitle(title: 'Настройки API'),
            const SizedBox(height: 8),
            
            CustomTextFormField(
              controller: _baseUrlController,
              labelText: 'URL API',
              validator: (value) => value?.isEmpty ?? true 
                  ? 'Введите URL' 
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Тип аутентификации
            DropdownButtonFormField<AuthenticationType>(
              value: _selectedAuthType,
              decoration: const InputDecoration(
                labelText: 'Тип аутентификации',
                border: OutlineInputBorder(),
              ),
              items: AuthenticationType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getAuthTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAuthType = value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Поля аутентификации в зависимости от типа
            ..._buildAuthFields(),
            
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Использовать прокси'),
              subtitle: const Text('Подключение через прокси-сервер'),
              value: _useProxy,
              onChanged: (value) => setState(() => _useProxy = value),
            ),
            
            const SizedBox(height: 24),
            
            // Бизнес-параметры
            if (widget.supplierCode == 'armtek') ...[
              SectionTitle(title: 'Параметры Armtek'),
              const SizedBox(height: 8),
              
              CustomTextFormField(
                controller: _vkorgController,
                labelText: 'VKORG (Код организации)',
                validator: (value) => value?.isEmpty ?? true 
                    ? 'Введите VKORG' 
                    : null,
              ),
              
              const SizedBox(height: 16),
            ],
            
            CustomTextFormField(
              controller: _customerCodeController,
              labelText: 'Код клиента',
            ),
            
            const SizedBox(height: 32),
            
            // Ошибки валидации
            if (formState.validationErrors.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: formState.validationErrors.map((error) {
                    return Text(
                      '• $error',
                      style: TextStyle(color: Colors.red.shade700),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: formState.isTesting ? null : _testConnection,
                    icon: formState.isTesting 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.wifi_tethering),
                    label: Text(formState.isTesting 
                        ? 'Проверка...' 
                        : 'Проверить подключение'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: formState.isLoading ? null : _saveConfig,
                    icon: formState.isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Сохранить'),
                  ),
                ),
              ],
            ),
            
            // Сообщение об ошибке
            if (formState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                formState.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildAuthFields() {
    switch (_selectedAuthType) {
      case AuthenticationType.basic:
        return [
          CustomTextFormField(
            controller: _usernameController,
            labelText: 'Логин',
            validator: (value) => value?.isEmpty ?? true 
                ? 'Введите логин' 
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) => value?.isEmpty ?? true 
                ? 'Введите пароль' 
                : null,
          ),
        ];
        
      case AuthenticationType.apiKey:
        return [
          CustomTextFormField(
            controller: _apiKeyController,
            labelText: 'API ключ',
            validator: (value) => value?.isEmpty ?? true 
                ? 'Введите API ключ' 
                : null,
          ),
        ];
        
      default:
        return [];
    }
  }
  
  String _getAuthTypeName(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.basic:
        return 'Логин/Пароль';
      case AuthenticationType.apiKey:
        return 'API ключ';
      case AuthenticationType.bearer:
        return 'Bearer токен';
      case AuthenticationType.oauth2:
        return 'OAuth 2.0';
      case AuthenticationType.custom:
        return 'Другой';
    }
  }
  
  void _updateFormConfig() {
    final config = SupplierConfig(
      supplierCode: widget.supplierCode ?? _displayNameController.text.toLowerCase().replaceAll(' ', '_'),
      displayName: _displayNameController.text,
      isEnabled: _isEnabled,
      apiConfig: SupplierApiConfig(
        baseUrl: _baseUrlController.text,
        authType: _selectedAuthType,
        credentials: SupplierCredentials(
          username: _usernameController.text.isNotEmpty ? _usernameController.text : null,
          password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
          apiKey: _apiKeyController.text.isNotEmpty ? _apiKeyController.text : null,
          additionalParams: _vkorgController.text.isNotEmpty 
              ? {'VKORG': _vkorgController.text} 
              : null,
        ),
        proxyUrl: _useProxy ? 'http://proxy.example.com' : null, // TODO: Добавить поле для прокси
      ),
      businessConfig: SupplierBusinessConfig(
        customerCode: _customerCodeController.text.isNotEmpty ? _customerCodeController.text : null,
        organizationCode: _vkorgController.text.isNotEmpty ? _vkorgController.text : null,
      ),
    );
    
    ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
        .updateConfig(config);
  }
  
  Future<void> _testConnection() async {
    if (_formKey.currentState?.validate() ?? false) {
      _updateFormConfig();
      await ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .testConnection();
    }
  }
  
  Future<void> _saveConfig() async {
    if (_formKey.currentState?.validate() ?? false) {
      _updateFormConfig();
      
      final success = await ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .save();
          
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Конфигурация сохранена')),
        );
        Navigator.of(context).pop();
      }
    }
  }
}