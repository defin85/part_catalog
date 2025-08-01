import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_api_providers.dart';
import 'package:part_catalog/features/suppliers/providers/parts_search_providers.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/widgets/part_price_list_item.dart';

/// Улучшенный экран поиска запчастей с поддержкой оптимизированной системы
class EnhancedPartsSearchScreen extends ConsumerStatefulWidget {
  const EnhancedPartsSearchScreen({super.key});

  @override
  ConsumerState<EnhancedPartsSearchScreen> createState() => _EnhancedPartsSearchScreenState();
}

class _EnhancedPartsSearchScreenState extends ConsumerState<EnhancedPartsSearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late TabController _tabController;
  
  bool _useOptimizedSystem = true;
  bool _useCache = true;
  final List<String> _selectedSuppliers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _articleController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_formKey.currentState?.validate() ?? false) {
      final articleNumber = _articleController.text.trim();
      final brand = _brandController.text.trim().isEmpty 
          ? null 
          : _brandController.text.trim();
          
      if (_useOptimizedSystem) {
        final optimizedParams = OptimizedPartsSearchParams(
          articleNumber: articleNumber,
          brand: brand,
          supplierCodes: _selectedSuppliers.isEmpty ? null : _selectedSuppliers,
          useCache: _useCache,
        );
        
        // Запускаем оптимизированный поиск
        ref.read(optimizedPartsSearchProvider(optimizedParams));
      } else {
        // Используем старую систему
        final params = PartsSearchParams(
          articleNumber: articleNumber,
          brand: brand,
        );
        
        ref.read(partsSearchStateProvider.notifier).state = params;
      }
    }
  }

  void _clearSearch() {
    _articleController.clear();
    _brandController.clear();
    ref.read(partsSearchStateProvider.notifier).state = null;
    setState(() {
      _selectedSuppliers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isOptimizedEnabledAsync = ref.watch(isOptimizedSystemEnabledProvider);
    final enabledSuppliers = ref.watch(enabledSupplierConfigsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Поиск запчастей'), // Упрощаем пока до исправления переводов
            Consumer(
              builder: (context, ref, child) {
                return isOptimizedEnabledAsync.when(
                  data: (isOptimizedEnabled) => isOptimizedEnabled && _useOptimizedSystem
                    ? const Text(
                        '🚀 Оптимизированный поиск',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                      )
                    : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Поиск'),
            Tab(icon: Icon(Icons.analytics), text: 'Аналитика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Consumer(
            builder: (context, ref, child) {
              return isOptimizedEnabledAsync.when(
                data: (isOptimizedEnabled) => _buildSearchTab(t, isOptimizedEnabled, enabledSuppliers),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Ошибка: $error'),
                ),
              );
            },
          ),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildSearchTab(
    dynamic t, // Убираем типизацию пока
    bool isOptimizedEnabled,
    List<dynamic> enabledSuppliers,
  ) {
    return Column(
      children: [
        // Форма поиска
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Переключатель оптимизированной системы
                  if (isOptimizedEnabled) ...[
                    Row(
                      children: [
                        const Icon(Icons.rocket_launch, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text(
                          'Система поиска',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Оптимизированная'),
                            subtitle: const Text('С кешем и circuit breaker'),
                            value: true,
                            groupValue: _useOptimizedSystem,
                            onChanged: (value) => setState(() => _useOptimizedSystem = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Классическая'),
                            subtitle: const Text('Без дополнительных функций'),
                            value: false,
                            groupValue: _useOptimizedSystem,
                            onChanged: (value) => setState(() => _useOptimizedSystem = value!),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                  
                  // Основные поля поиска
                  TextFormField(
                    controller: _articleController,
                    decoration: const InputDecoration(
                      labelText: 'Номер запчасти',
                      hintText: 'Введите артикул',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите номер запчасти';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _performSearch(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(
                      labelText: 'Бренд',
                      hintText: 'Введите бренд (необязательно)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.branding_watermark),
                    ),
                    onFieldSubmitted: (_) => _performSearch(),
                  ),
                  
                  // Дополнительные настройки для оптимизированной системы
                  if (isOptimizedEnabled && _useOptimizedSystem) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        const Icon(Icons.tune),
                        const SizedBox(width: 8),
                        const Text(
                          'Дополнительные настройки',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SwitchListTile(
                      title: const Text('Использовать кеш'),
                      subtitle: const Text('Ускоряет повторные запросы'),
                      value: _useCache,
                      onChanged: (value) => setState(() => _useCache = value),
                    ),
                    
                    if (enabledSuppliers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Фильтр по поставщикам:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: enabledSuppliers.map((supplier) {
                          final supplierCode = supplier.supplierCode as String;
                          final isSelected = _selectedSuppliers.contains(supplierCode);
                          
                          return FilterChip(
                            label: Text(supplier.displayName as String),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSuppliers.add(supplierCode);
                                } else {
                                  _selectedSuppliers.remove(supplierCode);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Кнопки действий
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _performSearch,
                          icon: const Icon(Icons.search),
                          label: Text(_useOptimizedSystem 
                            ? 'Умный поиск'
                            : 'Найти'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                        label: const Text('Очистить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Результаты поиска
        Expanded(
          child: _buildSearchResults(t),
        ),
      ],
    );
  }

  Widget _buildSearchResults(dynamic t) {
    if (_useOptimizedSystem) {
      return _buildOptimizedResults(t);
    } else {
      return _buildLegacyResults(t);
    }
  }

  Widget _buildOptimizedResults(dynamic t) {
    // Получаем текущие параметры поиска
    final articleNumber = _articleController.text.trim();
    
    if (articleNumber.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Введите номер запчасти для поиска',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final params = OptimizedPartsSearchParams(
      articleNumber: articleNumber,
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      supplierCodes: _selectedSuppliers.isEmpty ? null : _selectedSuppliers,
      useCache: _useCache,
    );

    final searchResultsAsync = ref.watch(optimizedPartsSearchProvider(params));

    return searchResultsAsync.when(
      data: (results) => _buildResultsList(results, t, isOptimized: true),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('🚀 Выполняется оптимизированный поиск...'),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка поиска: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(optimizedPartsSearchProvider(params)),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyResults(dynamic t) {
    final searchParams = ref.watch(partsSearchStateProvider);
    
    if (searchParams == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Введите номер запчасти для поиска',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final searchResultsAsync = ref.watch(partsSearchProvider(searchParams));

    return searchResultsAsync.when(
      data: (results) => _buildResultsList(results, t, isOptimized: false),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Поиск запчастей...'),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка поиска: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(partsSearchProvider(searchParams)),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(
    List<PartPriceModel> results,
    dynamic t, {
    required bool isOptimized,
  }) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Ничего не найдено',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Заголовок с информацией о результатах
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Icon(
                isOptimized ? Icons.rocket_launch : Icons.search,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Найдено: ${results.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (isOptimized) ...[
                const Spacer(),
                const Icon(Icons.cached, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                const Text(
                  'Кеш активен',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ],
          ),
        ),
        
        // Список результатов
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final part = results[index];
              return PartPriceListItem(
                part: part,
                onTap: () => _showPartDetails(part),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final diagnosticsAsync = ref.watch(systemDiagnosticsProvider);
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.read(systemDiagnosticsProvider.notifier).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Системная диагностика
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.dashboard),
                          const SizedBox(width: 8),
                          const Text(
                            'Системная диагностика',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      diagnosticsAsync.when(
                        data: (diagnostics) => _buildDiagnosticsInfo(diagnostics),
                        loading: () => const Center(child: CircularProgressIndicator()),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.settings),
                          const SizedBox(width: 8),
                          const Text(
                            'Управление системой',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _resetAllCircuitBreakers(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Сбросить CB'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _clearAllCaches(),
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Очистить кеши'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _forceCloseCircuitBreakers(),
                            icon: const Icon(Icons.power_settings_new),
                            label: const Text('Принудительно закрыть CB'),
                          ),
                        ],
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

  Widget _buildDiagnosticsInfo(Map<String, dynamic> diagnostics) {
    final systemStatus = diagnostics['system_status'] as Map<String, dynamic>?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (systemStatus != null) ...[
          Text('Оптимизированная система: ${systemStatus['optimized_enabled'] ? '✅ Включена' : '❌ Отключена'}'),
          Text('Активных поставщиков: ${systemStatus['active_suppliers']}'),
          Text('Последнее обновление: ${systemStatus['timestamp']}'),
          const SizedBox(height: 16),
        ],
        
        // Информация по клиентам
        ...diagnostics.entries
            .where((entry) => entry.key != 'system_status')
            .map((entry) {
          final clientName = entry.key;
          final clientData = entry.value as Map<String, dynamic>;
          final cbStatus = clientData['circuitBreaker']?['state'] ?? 'UNKNOWN';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  cbStatus == 'CLOSED' ? Icons.check_circle :
                  cbStatus == 'OPEN' ? Icons.error :
                  cbStatus == 'HALF_OPEN' ? Icons.warning :
                  Icons.help,
                  color: cbStatus == 'CLOSED' ? Colors.green :
                         cbStatus == 'OPEN' ? Colors.red :
                         cbStatus == 'HALF_OPEN' ? Colors.orange :
                         Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text('$clientName: $cbStatus'),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showPartDetails(PartPriceModel part) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(part.name.isNotEmpty ? part.name : part.article),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Артикул: ${part.article}'),
            if (part.brand.isNotEmpty) Text('Бренд: ${part.brand}'),
            Text('Цена: ${part.price.toStringAsFixed(2)} ₽'),
            Text('Количество: ${part.quantity}'),
            Text('Срок поставки: ${part.deliveryDays} дней'),
            Text('Поставщик: ${part.supplierName}'),
            if (part.comment?.isNotEmpty ?? false)
              Text('Комментарий: ${part.comment}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetAllCircuitBreakers() async {
    try {
      ref.read(systemDiagnosticsProvider.notifier).resetAllCircuitBreakers();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔄 Все circuit breakers сброшены')),
        );
        ref.read(systemDiagnosticsProvider.notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка: $e')),
        );
      }
    }
  }

  Future<void> _clearAllCaches() async {
    try {
      await ref.read(systemDiagnosticsProvider.notifier).clearAllCaches();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Все кеши очищены')),
        );
        ref.read(systemDiagnosticsProvider.notifier).refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка: $e')),
        );
      }
    }
  }

  Future<void> _forceCloseCircuitBreakers() async {
    try {
      await ref.read(systemDiagnosticsProvider.notifier).forceCloseAllCircuitBreakers();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚡ Circuit breakers принудительно закрыты')),
        );
        ref.read(systemDiagnosticsProvider.notifier).refresh();
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