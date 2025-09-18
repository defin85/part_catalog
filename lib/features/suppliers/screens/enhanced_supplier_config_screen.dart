import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/widgets/custom_text_form_field.dart';
import 'package:part_catalog/core/widgets/section_title.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_api_providers.dart';
import 'package:part_catalog/features/suppliers/widgets/supplier_info_widget_factory.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';

/// Улучшенный экран настройки поставщика с поддержкой оптимизированной системы
class EnhancedSupplierConfigScreen extends ConsumerStatefulWidget {
  final String? supplierCode;

  const EnhancedSupplierConfigScreen({
    super.key,
    this.supplierCode,
  });

  @override
  ConsumerState<EnhancedSupplierConfigScreen> createState() =>
      _EnhancedSupplierConfigScreenState();
}

class _EnhancedSupplierConfigScreenState
    extends ConsumerState<EnhancedSupplierConfigScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _baseUrlController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _vkorgController;
  late final TextEditingController _customerCodeController;

  late final TabController _tabController;

  AuthenticationType _selectedAuthType = AuthenticationType.basic;
  bool _useProxy = false;
  bool _isEnabled = true;
  bool _useOptimizedSystem = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _displayNameController = TextEditingController();
    _baseUrlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _apiKeyController = TextEditingController();
    _vkorgController = TextEditingController();
    _customerCodeController = TextEditingController();

    // Отслеживаем изменения в полях ввода
    for (final c in [
      _displayNameController,
      _baseUrlController,
      _usernameController,
      _passwordController,
      _apiKeyController,
      _vkorgController,
      _customerCodeController,
    ]) {
      c.addListener(_markChanged);
    }

    // Загрузить существующую конфигурацию если есть
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.supplierCode != null) {
        await _loadExistingConfig();

        // Установить дефолтный URL для Armtek если пустой
        if (widget.supplierCode == 'armtek' &&
            _baseUrlController.text.isEmpty) {
          _baseUrlController.text = 'http://ws.armtek.ru/api';
        }
      }
    });
  }

  Future<void> _loadExistingConfig() async {
    try {
      final config =
          await ref.read(supplierConfigProvider(widget.supplierCode!).future);
      if (config != null && mounted) {
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
          _useOptimizedSystem = businessConfig.useOptimizedSystem;
        }

        // Обновить форму провайдера
        ref
            .read(supplierConfigFormProvider(widget.supplierCode).notifier)
            .updateConfig(config);

        // Сброс признака изменений после загрузки
        _hasChanges = false;
      }
    } catch (e) {
      // Логируем ошибку, но не показываем пользователю если просто нет конфигурации
      debugPrint('Error loading config: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    final formState =
        ref.watch(supplierConfigFormProvider(widget.supplierCode));
    final isOptimizedEnabledAsync = ref.watch(isOptimizedSystemEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.supplierCode != null
                ? 'Настройка ${widget.supplierCode}'
                : 'Новый поставщик'),
            Consumer(
              builder: (context, ref, child) {
                return isOptimizedEnabledAsync.when(
                  data: (isOptimizedEnabled) =>
                      isOptimizedEnabled && _useOptimizedSystem
                          ? const Text(
                              '🚀 Оптимизированная система',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            )
                          : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _onCancelPressed,
            child: const Text('Отмена'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: 'Настройки'),
            Tab(icon: Icon(Icons.monitor_heart), text: 'Мониторинг'),
            Tab(icon: Icon(Icons.analytics), text: 'Статистика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isOptimizedEnabledAsync.when(
            data: (isOptimizedEnabled) =>
                _buildConfigTab(formState, isOptimizedEnabled),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Ошибка: $error')),
          ),
          _buildMonitoringTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildConfigTab(dynamic formState, bool isOptimizedEnabled) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Переключатель оптимизированной системы
          if (isOptimizedEnabled) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.rocket_launch, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text(
                          'Оптимизированная система API',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Включает отказоустойчивость, кэширование, мониторинг и circuit breaker',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title:
                          const Text('Использовать оптимизированную систему'),
                      subtitle: const Text('Рекомендуется для продакшена'),
                      value: _useOptimizedSystem,
                      onChanged: (value) => setState(() {
                        _useOptimizedSystem = value;
                        _hasChanges = true;
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Основная информация
          SectionTitle(title: 'Основная информация'),
          const SizedBox(height: 8),

          CustomTextFormField(
            controller: _displayNameController,
            labelText: 'Название поставщика',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Введите название' : null,
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Активен'),
            subtitle: const Text('Включить поставщика в поиск'),
            value: _isEnabled,
            onChanged: (value) => setState(() {
              _isEnabled = value;
              _hasChanges = true;
            }),
          ),

          const SizedBox(height: 24),

          // Настройки API
          SectionTitle(title: 'Настройки API'),
          const SizedBox(height: 8),

          CustomTextFormField(
            controller: _baseUrlController,
            labelText: 'URL API',
            validator: (value) => value?.isEmpty ?? true ? 'Введите URL' : null,
          ),

          const SizedBox(height: 16),

          // Тип аутентификации
          DropdownButtonFormField<AuthenticationType>(
            initialValue: _selectedAuthType,
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
                setState(() {
                  _selectedAuthType = value;
                  _hasChanges = true;
                });
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
            onChanged: (value) => setState(() {
              _useProxy = value;
              _hasChanges = true;
            }),
          ),

          const SizedBox(height: 24),

          // Armtek: дополнительные действия и детали
          if (widget.supplierCode == 'armtek') ...[
            const SectionTitle(title: 'Armtek: данные и детали'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateFormConfig();
                      ref
                          .read(supplierConfigFormProvider(widget.supplierCode)
                              .notifier)
                          .loadUserInfo();
                    },
                    icon: const Icon(Icons.person_search),
                    label: const Text('Загрузить пользователя'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateFormConfig();
                      ref
                          .read(supplierConfigFormProvider(widget.supplierCode)
                              .notifier)
                          .loadBrandList();
                    },
                    icon: const Icon(Icons.branding_watermark),
                    label: const Text('Загрузить бренды'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _updateFormConfig();
                      ref
                          .read(supplierConfigFormProvider(widget.supplierCode)
                              .notifier)
                          .loadStoreList();
                    },
                    icon: const Icon(Icons.warehouse),
                    label: const Text('Загрузить склады'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () => _showDetailedSupplierInfo(context, formState),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Показать детальную информацию'),
              ),
            ),
          ],

          // Бизнес-параметры
          if (widget.supplierCode == 'armtek') ...[
            SectionTitle(title: 'Параметры Armtek'),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: _vkorgController,
              labelText: 'VKORG (Код организации)',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Введите VKORG' : null,
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
                      : _useOptimizedSystem
                          ? 'Health Check'
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
    );
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _onCancelPressed() async {
    if (!_hasChanges) {
      context.go(AppRoutes.apiControlCenter);
      return;
    }

    final shouldDiscard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Выйти без сохранения?'),
            content: const Text(
                'Изменения не будут сохранены. Вы уверены, что хотите выйти?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Выйти'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDiscard && mounted) {
      context.go(AppRoutes.apiControlCenter);
    }
  }

  void _showDetailedSupplierInfo(BuildContext context, dynamic formState) {
    if (widget.supplierCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Код поставщика не указан')),
      );
      return;
    }

    final supplierData = <String, dynamic>{
      'structure': formState.userInfo?.structure,
      'ftpData': formState.userInfo?.ftpData,
      'brandList': formState.config?.businessConfig?.brandList,
      'storeList': formState.config?.businessConfig?.storeList,
    };

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

  Widget _buildMonitoringTab() {
    if (widget.supplierCode == null || !_useOptimizedSystem) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Мониторинг доступен только для\nоптимизированной системы',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final healthStatusAsync =
            ref.watch(supplierHealthStatusProvider(widget.supplierCode!));

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(supplierHealthStatusProvider(widget.supplierCode!));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Статус здоровья
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.health_and_safety),
                          const SizedBox(width: 8),
                          const Text(
                            'Состояние системы',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      healthStatusAsync.when(
                        data: (status) => _buildHealthStatus(status),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text(
                          'Ошибка: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Circuit Breaker статус
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.electrical_services),
                          const SizedBox(width: 8),
                          const Text(
                            'Circuit Breaker',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      healthStatusAsync.when(
                        data: (status) => _buildCircuitBreakerStatus(
                            status['circuit_breaker']),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text(
                          'Ошибка: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Кнопки управления
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _resetCircuitBreaker(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Сбросить CB'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _clearCache(),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Очистить кеш'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsTab() {
    if (widget.supplierCode == null || !_useOptimizedSystem) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Статистика доступна только для\nоптимизированной системы',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Consumer(
      builder: (context, ref, child) {
        final healthStatusAsync =
            ref.watch(supplierHealthStatusProvider(widget.supplierCode!));

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(supplierHealthStatusProvider(widget.supplierCode!));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Метрики производительности
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed),
                          const SizedBox(width: 8),
                          const Text(
                            'Метрики производительности',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      healthStatusAsync.when(
                        data: (status) => _buildMetrics(status['metrics']),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text(
                          'Ошибка: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Статистика кеша
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.storage),
                          const SizedBox(width: 8),
                          const Text(
                            'Статистика кеша',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      healthStatusAsync.when(
                        data: (status) => _buildCacheStats(status['cache']),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text(
                          'Ошибка: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthStatus(Map<String, dynamic> status) {
    final isHealthy = status['healthy'] as bool? ?? false;
    final statusText = status['status'] as String? ?? 'unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isHealthy ? Icons.check_circle : Icons.error,
              color: isHealthy ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              isHealthy ? 'Здоров' : 'Нездоров',
              style: TextStyle(
                color: isHealthy ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Статус: $statusText'),
        if (status['message'] != null) Text('Сообщение: ${status['message']}'),
        Text('Последняя проверка: ${status['timestamp']}'),
      ],
    );
  }

  Widget _buildCircuitBreakerStatus(Map<String, dynamic>? cbStatus) {
    if (cbStatus == null) {
      return const Text('Информация недоступна');
    }

    final state = cbStatus['state'] as String? ?? 'UNKNOWN';
    final failureCount = cbStatus['failureCount'] as int? ?? 0;

    Color stateColor;
    IconData stateIcon;

    switch (state) {
      case 'CLOSED':
        stateColor = Colors.green;
        stateIcon = Icons.check_circle;
        break;
      case 'OPEN':
        stateColor = Colors.red;
        stateIcon = Icons.error;
        break;
      case 'HALF_OPEN':
        stateColor = Colors.orange;
        stateIcon = Icons.warning;
        break;
      default:
        stateColor = Colors.grey;
        stateIcon = Icons.help;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(stateIcon, color: stateColor),
            const SizedBox(width: 8),
            Text(
              state,
              style: TextStyle(
                color: stateColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Количество ошибок: $failureCount'),
      ],
    );
  }

  Widget _buildMetrics(Map<String, dynamic>? metrics) {
    if (metrics == null || metrics.isEmpty) {
      return const Text('Метрики недоступны');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: metrics.entries.map((entry) {
        final endpoint = entry.key;
        final stats = entry.value as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                endpoint,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Всего запросов: ${stats['totalRequests'] ?? 0}'),
              Text('Среднее время: ${stats['avgResponseTime'] ?? 0}ms'),
              Text('Частота ошибок: ${stats['errorRate'] ?? 0}%'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCacheStats(Map<String, dynamic>? cacheStats) {
    if (cacheStats == null) {
      return const Text('Статистика кеша недоступна');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hit Rate: ${cacheStats['hitRate'] ?? 0}%'),
        Text('Элементов в кеше: ${cacheStats['itemCount'] ?? 0}'),
        Text('Размер кеша: ${cacheStats['cacheSize'] ?? 0} bytes'),
      ],
    );
  }

  List<Widget> _buildAuthFields() {
    switch (_selectedAuthType) {
      case AuthenticationType.basic:
        return [
          CustomTextFormField(
            controller: _usernameController,
            labelText: 'Логин',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Введите логин' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Введите пароль' : null,
          ),
        ];

      case AuthenticationType.apiKey:
        return [
          CustomTextFormField(
            controller: _apiKeyController,
            labelText: 'API ключ',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Введите API ключ' : null,
          ),
        ];

      default:
        return [];
    }
  }

  String _getAuthTypeName(AuthenticationType type) {
    switch (type) {
      case AuthenticationType.none:
        return 'Без аутентификации';
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
      supplierCode: widget.supplierCode ??
          _displayNameController.text.toLowerCase().replaceAll(' ', '_'),
      displayName: _displayNameController.text,
      isEnabled: _isEnabled,
      apiConfig: SupplierApiConfig(
        baseUrl: _baseUrlController.text,
        authType: _selectedAuthType,
        credentials: SupplierCredentials(
          username: _usernameController.text.isNotEmpty
              ? _usernameController.text
              : null,
          password: _passwordController.text.isNotEmpty
              ? _passwordController.text
              : null,
          apiKey:
              _apiKeyController.text.isNotEmpty ? _apiKeyController.text : null,
          additionalParams: _vkorgController.text.isNotEmpty
              ? {'VKORG': _vkorgController.text}
              : null,
        ),
        proxyUrl: _useProxy
            ? 'http://proxy.example.com'
            : null, // TODO: Добавить поле для прокси
      ),
      businessConfig: SupplierBusinessConfig(
        customerCode: _customerCodeController.text.isNotEmpty
            ? _customerCodeController.text
            : null,
        organizationCode:
            _vkorgController.text.isNotEmpty ? _vkorgController.text : null,
        useOptimizedSystem: _useOptimizedSystem,
      ),
    );

    ref
        .read(supplierConfigFormProvider(widget.supplierCode).notifier)
        .updateConfig(config);
  }

  Future<void> _testConnection() async {
    if (_formKey.currentState?.validate() ?? false) {
      _updateFormConfig();

      if (_useOptimizedSystem && widget.supplierCode != null) {
        // Используем оптимизированную систему для тестирования
        try {
          final notifier = ref.read(
              optimizedArmtekClientProvider(widget.supplierCode!).notifier);
          final success = await notifier.performHealthCheck();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? '✅ Health check успешен'
                    : '❌ Health check неудачен'),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Ошибка: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Используем старую систему
        await ref
            .read(supplierConfigFormProvider(widget.supplierCode).notifier)
            .testConnection();
      }
    }
  }

  Future<void> _saveConfig() async {
    if (_formKey.currentState?.validate() ?? false) {
      _updateFormConfig();

      final success = await ref
          .read(supplierConfigFormProvider(widget.supplierCode).notifier)
          .save();

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_useOptimizedSystem
                ? '🚀 Конфигурация сохранена (оптимизированная система)'
                : '✅ Конфигурация сохранена'),
          ),
        );
        context.go(AppRoutes.apiControlCenter);
      }
    }
  }

  Future<void> _resetCircuitBreaker() async {
    try {
      final notifier = ref
          .read(optimizedArmtekClientProvider(widget.supplierCode!).notifier);
      await notifier.resetCircuitBreaker();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔄 Circuit breaker сброшен')),
        );

        // Обновляем данные
        ref.invalidate(supplierHealthStatusProvider(widget.supplierCode!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка: $e')),
        );
      }
    }
  }

  Future<void> _clearCache() async {
    try {
      final notifier = ref
          .read(optimizedArmtekClientProvider(widget.supplierCode!).notifier);
      await notifier.clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Кеш очищен')),
        );

        // Обновляем данные
        ref.invalidate(supplierHealthStatusProvider(widget.supplierCode!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка: $e')),
        );
      }
    }
  }
}
