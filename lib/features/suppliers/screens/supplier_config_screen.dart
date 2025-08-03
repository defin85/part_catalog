import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/widgets/custom_text_form_field.dart';
import 'package:part_catalog/core/widgets/section_title.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config_form_state.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_structure_root.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/widgets/supplier_info_widget_factory.dart';

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
        
        // Установить дефолтный URL для Armtek если пустой
        if (widget.supplierCode == 'armtek' && _baseUrlController.text.isEmpty) {
          _baseUrlController.text = 'http://ws.armtek.ru/api';
        }
      }
    });
  }

  Future<void> _loadExistingConfig() async {
    try {
      final config = await ref.read(supplierConfigProvider(widget.supplierCode!).future);
      if (config != null) {
        setState(() {
          _displayNameController.text = config.displayName;
          _baseUrlController.text = config.apiConfig.baseUrl;
          _selectedAuthType = config.apiConfig.authType;
          _useProxy = config.apiConfig.proxyUrl != null;
          _isEnabled = config.isEnabled;
        });
        
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
    } catch (e) {
      // Логируем ошибку, но не показываем пользователю если просто нет конфигурации
      // Используем logger если он есть или игнорируем ошибку
      debugPrint('Error loading config: $e');
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
    final t = Translations.of(context);
    final formState = ref.watch(supplierConfigFormProvider(widget.supplierCode));
    
    // Слушаем изменения в конфигурации и обновляем поля формы
    ref.listen(supplierConfigFormProvider(widget.supplierCode), (previous, next) {
      // Обновляем поле "Код клиента" если оно изменилось в конфигурации
      final newCustomerCode = next.config?.businessConfig?.customerCode;
      if (newCustomerCode != null && 
          newCustomerCode != _customerCodeController.text &&
          newCustomerCode.isNotEmpty) {
        _customerCodeController.text = newCustomerCode;
      }
    });
    
    return PopScope(
      canPop: !_hasUnsavedChanges(),
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        // Проверяем, есть ли несохраненные изменения
        if (_hasUnsavedChanges()) {
          final shouldDiscard = await _showDiscardChangesDialog(context);
          if (shouldDiscard == true && context.mounted) {
            _safeNavigateBack(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.supplierCode != null 
              ? t.suppliers.config.screenTitle(supplierName: widget.supplierCode!)
              : t.suppliers.config.newSupplierTitle),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _onBackPressed(context),
          ),
        ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Основная информация
            SectionTitle(title: t.suppliers.config.basicInfoSection),
            const SizedBox(height: 8),
            
            CustomTextFormField(
              controller: _displayNameController,
              labelText: t.suppliers.config.supplierName,
              validator: (value) => value?.isEmpty ?? true 
                  ? t.suppliers.config.supplierNameRequired
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: Text(t.suppliers.config.active),
              subtitle: Text(t.suppliers.config.activeDescription),
              value: _isEnabled,
              onChanged: (value) => setState(() => _isEnabled = value),
            ),
            
            const SizedBox(height: 24),
            
            // Настройки API
            SectionTitle(title: t.suppliers.config.apiSettingsSection),
            const SizedBox(height: 8),
            
            CustomTextFormField(
              controller: _baseUrlController,
              labelText: t.suppliers.config.apiUrl,
              validator: (value) => value?.isEmpty ?? true 
                  ? t.suppliers.config.apiUrlRequired
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Тип аутентификации
            DropdownButtonFormField<AuthenticationType>(
              value: _selectedAuthType,
              decoration: InputDecoration(
                labelText: t.suppliers.config.authenticationType,
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
              title: Text(t.suppliers.config.useProxy),
              subtitle: Text(t.suppliers.config.useProxyDescription),
              value: _useProxy,
              onChanged: (value) => setState(() => _useProxy = value),
            ),
            
            const SizedBox(height: 24),
            
            // Бизнес-параметры
            if (widget.supplierCode == 'armtek') ...[
              SectionTitle(title: t.suppliers.config.armtekParametersSection),
              const SizedBox(height: 8),
              
              // Кнопка для загрузки списка VKORG
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: formState.isLoadingVkorgList 
                          ? null 
                          : () {
                              // Сначала обновляем конфигурацию из полей формы
                              _updateFormConfig();
                              // Затем загружаем список VKORG
                              ref.read(supplierConfigFormProvider(widget.supplierCode).notifier).loadVkorgList();
                            },
                      icon: formState.isLoadingVkorgList 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download),
                      label: Text(formState.isLoadingVkorgList 
                          ? t.suppliers.config.loadingVkorgList
                          : t.suppliers.config.loadVkorgList),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Выпадающий список VKORG или поле ввода
              if (formState.availableVkorgList.isNotEmpty) 
                DropdownButtonFormField<String>(
                  value: _vkorgController.text.isNotEmpty ? _vkorgController.text : null,
                  decoration: InputDecoration(
                    labelText: t.suppliers.config.vkorg,
                    border: OutlineInputBorder(),
                  ),
                  items: formState.availableVkorgList.map((vkorg) {
                    return DropdownMenuItem(
                      value: vkorg.vkorg,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: vkorg.vkorg,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (vkorg.programName.isNotEmpty)
                              TextSpan(
                                text: ' - ${vkorg.programName}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _vkorgController.text = value;
                      ref.read(supplierConfigFormProvider(widget.supplierCode).notifier).selectVkorg(value);
                    }
                  },
                  validator: (value) => value?.isEmpty ?? true 
                      ? t.suppliers.config.vkorgRequired
                      : null,
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _vkorgController,
                      labelText: t.suppliers.config.vkorg,
                      validator: (value) => value?.isEmpty ?? true 
                          ? t.suppliers.config.vkorgRequired
                          : null,
                    ),
                    if (formState.availableVkorgList.isEmpty && !formState.isLoadingVkorgList)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          t.suppliers.config.vkorgNotLoaded,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              
              const SizedBox(height: 12),
            ],
            
            CustomTextFormField(
              controller: _customerCodeController,
              labelText: t.suppliers.config.customerCode,
              hintText: widget.supplierCode == 'armtek' 
                  ? 'Заполняется автоматически из KUNAG'
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            // Кнопка для загрузки информации о пользователе
            if (widget.supplierCode == 'armtek') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (formState.isLoadingUserInfo || 
                                 _vkorgController.text.isEmpty ||
                                 _usernameController.text.isEmpty ||
                                 _passwordController.text.isEmpty ||
                                 _baseUrlController.text.isEmpty) 
                          ? null 
                          : () {
                              // Сначала обновляем конфигурацию из полей формы
                              _updateFormConfig();
                              // Затем загружаем информацию о пользователе
                              ref.read(supplierConfigFormProvider(widget.supplierCode).notifier).loadUserInfo();
                            },
                      icon: formState.isLoadingUserInfo 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person),
                      label: Text(formState.isLoadingUserInfo 
                          ? 'Загрузка информации...'
                          : 'Загрузить информацию о пользователе'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Кнопки для загрузки брендов и складов
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (formState.isLoadingBrandList || 
                                 _vkorgController.text.isEmpty ||
                                 _usernameController.text.isEmpty ||
                                 _passwordController.text.isEmpty ||
                                 _baseUrlController.text.isEmpty) 
                          ? null 
                          : () {
                              _updateFormConfig();
                              ref.read(supplierConfigFormProvider(widget.supplierCode).notifier).loadBrandList();
                            },
                      icon: formState.isLoadingBrandList
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.branding_watermark),
                      label: Text(formState.isLoadingBrandList 
                          ? 'Загрузка...'
                          : 'Загрузить бренды'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (formState.isLoadingStoreList || 
                                 _vkorgController.text.isEmpty ||
                                 _usernameController.text.isEmpty ||
                                 _passwordController.text.isEmpty ||
                                 _baseUrlController.text.isEmpty) 
                          ? null 
                          : () {
                              _updateFormConfig();
                              ref.read(supplierConfigFormProvider(widget.supplierCode).notifier).loadStoreList();
                            },
                      icon: formState.isLoadingStoreList
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.warehouse),
                      label: Text(formState.isLoadingStoreList 
                          ? 'Загрузка...'
                          : 'Загрузить склады'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Отображение информации о пользователе
              if (formState.userInfo != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Информация о пользователе',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Статистика загруженных данных
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Загруженные данные:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.people, size: 16, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Плательщики: ${formState.userInfo!.structure?.rgTab?.length ?? 0}'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.branding_watermark, size: 16, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Бренды: ${formState.config?.businessConfig?.brandList?.length ?? 0}'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.warehouse, size: 16, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text('Склады: ${formState.config?.businessConfig?.storeList?.length ?? 0}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Структура клиентов
                        if (formState.userInfo!.structure != null && 
                            formState.userInfo!.structure!.rgTab?.isNotEmpty == true) ...[
                          Text(
                            'Клиенты (${formState.userInfo!.structure!.rgTab!.length}):',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...formState.userInfo!.structure!.rgTab!.take(3).map((customer) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '• ${customer.sname ?? ''}${customer.fname?.isNotEmpty == true ? ' ${customer.fname}' : ''} (${customer.kunnr ?? ''})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          }),
                          if (formState.userInfo!.structure!.rgTab!.length > 3)
                            Text(
                              '... и еще ${formState.userInfo!.structure!.rgTab!.length - 3}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                        
                        // FTP данные
                        if (formState.userInfo!.ftpData != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'FTP настройки:',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Сервер: ${formState.userInfo!.ftpData!.server ?? 'Не указан'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Логин: ${formState.userInfo!.ftpData!.login ?? 'Не указан'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Рабочая директория: ${formState.userInfo!.ftpData!.workDir ?? 'Не указана'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        
                        // Кнопка для открытия детального виджета
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showDetailedSupplierInfo(context, formState),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Показать детальную информацию'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            
            
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
            Column(
              children: [
                // Первая строка: Проверить подключение и Сохранить
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
                            ? t.suppliers.config.testing
                            : t.suppliers.config.testConnection),
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
                        label: Text(t.suppliers.config.save),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Вторая строка: Кнопка отмены
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: formState.isLoading || formState.isTesting 
                        ? null 
                        : () => _onBackPressed(context),
                    icon: const Icon(Icons.close),
                    label: Text(t.suppliers.config.cancel),
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
            
            // Дополнительный отступ для предотвращения переполнения
            const SizedBox(height: 32),
          ],
        ),
      ),
      ),
    );
  }
  
  List<Widget> _buildAuthFields() {
    final t = Translations.of(context);
    
    switch (_selectedAuthType) {
      case AuthenticationType.basic:
        return [
          CustomTextFormField(
            controller: _usernameController,
            labelText: t.suppliers.config.username,
            validator: (value) => value?.isEmpty ?? true 
                ? t.suppliers.config.usernameRequired
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: t.suppliers.config.password,
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) => value?.isEmpty ?? true 
                ? t.suppliers.config.passwordRequired
                : null,
          ),
        ];
        
      case AuthenticationType.apiKey:
        return [
          CustomTextFormField(
            controller: _apiKeyController,
            labelText: t.suppliers.config.apiKey,
            validator: (value) => value?.isEmpty ?? true 
                ? t.suppliers.config.apiKeyRequired
                : null,
          ),
        ];
        
      default:
        return [];
    }
  }
  
  String _getAuthTypeName(AuthenticationType type) {
    final t = Translations.of(context);
    
    switch (type) {
      case AuthenticationType.none:
        return t.suppliers.config.authTypeNone;
      case AuthenticationType.basic:
        return t.suppliers.config.authTypeBasic;
      case AuthenticationType.apiKey:
        return t.suppliers.config.authTypeApiKey;
      case AuthenticationType.bearer:
        return t.suppliers.config.authTypeBearer;
      case AuthenticationType.oauth2:
        return t.suppliers.config.authTypeOAuth2;
      case AuthenticationType.custom:
        return t.suppliers.config.authTypeCustom;
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
      
      final success = await ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .testConnection();
          
      if (success && mounted) {
        // Получаем подробную информацию о результате
        final service = ref.read(supplierConfigServiceProvider);
        final result = await service.testConnection(
          ref.read(supplierConfigFormProvider(widget.supplierCode)).config!
        );
        
        // Проверяем mounted перед использованием context
        if (mounted) {
          // Показываем уведомление об успешном подключении
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(result.successMessage ?? 'Подключение успешно установлено'),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }
  
  Future<void> _saveConfig() async {
    if (_formKey.currentState?.validate() ?? false) {
      _updateFormConfig();
      
      final success = await ref.read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .save();
          
      if (success && mounted) {
        final t = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.suppliers.config.configSaved)),
        );
        
        if (context.mounted) {
          _safeNavigateBack(context);
        }
      } else {
        if (mounted) {
          final formState = ref.read(supplierConfigFormProvider(widget.supplierCode));
          if (formState.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ошибка сохранения: ${formState.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  /// Проверить, есть ли несохраненные изменения
  bool _hasUnsavedChanges() {
    // Проверяем, заполнены ли основные поля
    return _displayNameController.text.isNotEmpty ||
           _baseUrlController.text.isNotEmpty ||
           _usernameController.text.isNotEmpty ||
           _passwordController.text.isNotEmpty ||
           _apiKeyController.text.isNotEmpty ||
           _vkorgController.text.isNotEmpty ||
           _customerCodeController.text.isNotEmpty;
  }

  /// Обработка нажатия кнопки "Назад"
  Future<void> _onBackPressed(BuildContext context) async {
    if (_hasUnsavedChanges()) {
      final shouldDiscard = await _showDiscardChangesDialog(context);
      if (shouldDiscard == true && context.mounted) {
        _safeNavigateBack(context);
      }
    } else if (context.mounted) {
      _safeNavigateBack(context);
    }
  }

  /// Безопасная навигация назад
  void _safeNavigateBack(BuildContext context) {
    // Пытаемся использовать GoRouter для навигации назад
    if (context.canPop()) {
      context.pop();
    } else {
      // Если нет предыдущего маршрута, идем в API Control Center
      context.go(AppRoutes.apiControlCenter);
    }
  }

  /// Показать диалог подтверждения отмены изменений
  Future<bool?> _showDiscardChangesDialog(BuildContext context) {
    final t = Translations.of(context);
    
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.suppliers.config.discardChangesTitle),
          content: Text(t.suppliers.config.discardChangesMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.suppliers.config.continueEditing),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(t.suppliers.config.discardChanges),
            ),
          ],
        );
      },
    );
  }

  /// Показать детальную информацию о поставщике через фабрику виджетов
  void _showDetailedSupplierInfo(BuildContext context, SupplierConfigFormState formState) {
    if (widget.supplierCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Код поставщика не указан')),
      );
      return;
    }

    // Подготавливаем данные для фабрики виджетов
    // Для Armtek передаем объекты напрямую, без сериализации в JSON
    print('=== SUPPLIER CONFIG SCREEN DEBUG ===');
    print('UserInfo exists: ${formState.userInfo != null}');
    print('UserInfo structure exists: ${formState.userInfo?.structure != null}');
    print('UserInfo structure type: ${formState.userInfo?.structure.runtimeType}');
    print('UserInfo ftpData exists: ${formState.userInfo?.ftpData != null}');
    
    // Передаем объекты напрямую, без JSON сериализации
    final brandList = formState.config?.businessConfig?.brandList;
    final storeList = formState.config?.businessConfig?.storeList;
    
    // Проверяем, есть ли хоть какие-то данные для отображения
    final hasUserInfo = formState.userInfo?.structure != null;
    final hasBrandList = brandList != null && brandList.isNotEmpty;
    final hasStoreList = storeList != null && storeList.isNotEmpty;
    
    if (!hasUserInfo && !hasBrandList && !hasStoreList) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет данных для отображения. Сначала загрузите информацию о пользователе, бренды или склады.'),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }
    
    final supplierData = <String, dynamic>{
      // UserInfo может быть null - используем fallback пустую структуру
      'structure': formState.userInfo?.structure ?? UserStructureRoot(rgTab: []),  
      'ftpData': formState.userInfo?.ftpData,
      'brandList': brandList,                      // Список брендов из БД
      'storeList': storeList,                      // Список складов из БД
    };
    
    print('Final supplier data keys: ${supplierData.keys}');
    print('Structure rgTab length: ${formState.userInfo?.structure?.rgTab?.length ?? 0}');
    print('Brand list length: ${brandList?.length ?? 0}');
    print('Store list length: ${storeList?.length ?? 0}');

    final infoWidget = SupplierInfoWidgetFactory.createInfoWidget(
      supplierCode: widget.supplierCode!,
      supplierData: supplierData,
    );

    if (infoWidget != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Информация ${widget.supplierCode}'),
            ),
            body: infoWidget,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Виджет для ${widget.supplierCode} не найден')),
      );
    }
  }
}