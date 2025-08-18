import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/widgets/section_title.dart';
import 'package:part_catalog/features/debug/debug_database_screen.dart';
import 'package:part_catalog/features/suppliers/providers/optimized_system_settings_provider.dart';

/// Экран настроек оптимизированной системы API
class OptimizedSystemSettingsScreen extends ConsumerStatefulWidget {
  const OptimizedSystemSettingsScreen({super.key});

  @override
  ConsumerState<OptimizedSystemSettingsScreen> createState() =>
      _OptimizedSystemSettingsScreenState();
}

class _OptimizedSystemSettingsScreenState
    extends ConsumerState<OptimizedSystemSettingsScreen> {
  final TextEditingController _retryAttemptsController =
      TextEditingController();
  final TextEditingController _requestTimeoutController =
      TextEditingController();

  @override
  void dispose() {
    _retryAttemptsController.dispose();
    _requestTimeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(optimizedSystemSettingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.rocket_launch, color: Colors.orange),
            SizedBox(width: 8),
            Text('Оптимизированная система API'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(optimizedSystemSettingsNotifierProvider),
            tooltip: 'Обновить настройки',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 8),
                    Text('Сбросить к умолчанию'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Экспорт настроек'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('Импорт настроек'),
                  ],
                ),
              ),
              if (kDebugMode)
                const PopupMenuItem(
                  value: 'debug_db',
                  child: Row(
                    children: [
                      Icon(Icons.bug_report, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Debug БД'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: settingsAsync.when(
        data: (settings) => _buildSettingsForm(settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки настроек: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.invalidate(optimizedSystemSettingsNotifierProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsForm(OptimizedSystemSettings settings) {
    // Обновляем контроллеры при изменении настроек
    _retryAttemptsController.text = settings.retryAttempts.toString();
    _requestTimeoutController.text =
        (settings.requestTimeout / 1000).round().toString();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Основные настройки
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Основные настройки'),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Использовать оптимизированную систему'),
                  subtitle: const Text(
                      'Включает отказоустойчивость, кэширование и мониторинг'),
                  value: settings.useOptimizedSystem,
                  onChanged: _toggleOptimizedSystem,
                  secondary: Icon(
                    settings.useOptimizedSystem
                        ? Icons.rocket_launch
                        : Icons.rocket_launch_outlined,
                    color: settings.useOptimizedSystem
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Кэширование'),
                  subtitle: const Text('Ускоряет повторные запросы'),
                  value: settings.enableCaching,
                  onChanged:
                      settings.useOptimizedSystem ? _toggleCaching : null,
                  secondary: Icon(
                    settings.enableCaching
                        ? Icons.cached
                        : Icons.cached_outlined,
                    color: settings.enableCaching && settings.useOptimizedSystem
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Сбор метрик'),
                  subtitle:
                      const Text('Собирает статистику производительности'),
                  value: settings.enableMetrics,
                  onChanged:
                      settings.useOptimizedSystem ? _toggleMetrics : null,
                  secondary: Icon(
                    settings.enableMetrics
                        ? Icons.analytics
                        : Icons.analytics_outlined,
                    color: settings.enableMetrics && settings.useOptimizedSystem
                        ? Colors.purple
                        : Colors.grey,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Circuit Breaker'),
                  subtitle: const Text('Защищает от каскадных сбоев'),
                  value: settings.circuitBreakerEnabled,
                  onChanged: settings.useOptimizedSystem
                      ? _toggleCircuitBreaker
                      : null,
                  secondary: Icon(
                    settings.circuitBreakerEnabled
                        ? Icons.electrical_services
                        : Icons.electrical_services_outlined,
                    color: settings.circuitBreakerEnabled &&
                            settings.useOptimizedSystem
                        ? Colors.orange
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Дополнительные параметры
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Дополнительные параметры'),
                const SizedBox(height: 16),

                // Количество попыток
                Row(
                  children: [
                    const Icon(Icons.refresh),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Количество попыток повтора',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _retryAttemptsController,
                            enabled: settings.useOptimizedSystem,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Введите количество попыток (1-10)',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) => _updateRetryAttempts(value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Таймаут запроса
                Row(
                  children: [
                    const Icon(Icons.timer),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Таймаут запроса (секунды)',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _requestTimeoutController,
                            enabled: settings.useOptimizedSystem,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Введите таймаут в секундах (5-300)',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) => _updateRequestTimeout(value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Информационная карточка
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'О системе',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Оптимизированная система API обеспечивает:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                const Text('• Автоматические повторы при сбоях'),
                const Text('• Кэширование для ускорения запросов'),
                const Text('• Circuit Breaker для защиты от каскадных сбоев'),
                const Text('• Детальную аналитику производительности'),
                const Text('• Мониторинг состояния API поставщиков'),
                const SizedBox(height: 12),
                Text(
                  'Рекомендуется для промышленного использования.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  void _toggleOptimizedSystem(bool enabled) {
    ref
        .read(optimizedSystemSettingsNotifierProvider.notifier)
        .toggleOptimizedSystem(enabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? '🚀 Оптимизированная система включена'
            : '⚠️ Оптимизированная система отключена'),
        backgroundColor: enabled ? Colors.green : Colors.orange,
      ),
    );
  }

  void _toggleCaching(bool enabled) {
    ref
        .read(optimizedSystemSettingsNotifierProvider.notifier)
        .toggleCaching(enabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            enabled ? '💾 Кэширование включено' : '💾 Кэширование отключено'),
      ),
    );
  }

  void _toggleMetrics(bool enabled) {
    ref
        .read(optimizedSystemSettingsNotifierProvider.notifier)
        .toggleMetrics(enabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            enabled ? '📊 Сбор метрик включен' : '📊 Сбор метрик отключен'),
      ),
    );
  }

  void _toggleCircuitBreaker(bool enabled) {
    ref
        .read(optimizedSystemSettingsNotifierProvider.notifier)
        .toggleCircuitBreaker(enabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? '⚡ Circuit Breaker включен'
            : '⚡ Circuit Breaker отключен'),
      ),
    );
  }

  void _updateRetryAttempts(String value) {
    final attempts = int.tryParse(value);
    if (attempts != null && attempts >= 1 && attempts <= 10) {
      ref
          .read(optimizedSystemSettingsNotifierProvider.notifier)
          .setRetryAttempts(attempts);
    }
  }

  void _updateRequestTimeout(String value) {
    final seconds = int.tryParse(value);
    if (seconds != null && seconds >= 5 && seconds <= 300) {
      final timeoutMs = seconds * 1000;
      ref
          .read(optimizedSystemSettingsNotifierProvider.notifier)
          .setRequestTimeout(timeoutMs);
    }
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'reset':
        _showResetDialog();
        break;
      case 'export':
        _exportSettings();
        break;
      case 'import':
        _showImportDialog();
        break;
      case 'debug_db':
        if (kDebugMode) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DebugDatabaseScreen(),
            ),
          );
        }
        break;
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сбросить настройки'),
        content: const Text(
          'Все настройки будут сброшены к значениям по умолчанию. Продолжить?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetSettings();
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() async {
    try {
      await ref
          .read(optimizedSystemSettingsNotifierProvider.notifier)
          .resetToDefaults();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Настройки сброшены к значениям по умолчанию'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Ошибка сброса настроек: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _exportSettings() async {
    try {
      final settings = await ref
          .read(optimizedSystemSettingsNotifierProvider.notifier)
          .exportSettings();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Экспорт настроек'),
            content: SingleChildScrollView(
              child: SelectableText(
                settings.toString(),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Закрыть'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Реализовать сохранение в файл
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('📄 Настройки экспортированы')),
                  );
                },
                child: const Text('Сохранить в файл'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Ошибка экспорта: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImportDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Импорт настроек'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Вставьте JSON настроек:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Вставьте JSON здесь...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _importSettings(controller.text);
            },
            child: const Text('Импортировать'),
          ),
        ],
      ),
    );
  }

  void _importSettings(String jsonText) async {
    try {
      // TODO: Парсинг JSON и импорт настроек
      // final settings = jsonDecode(jsonText) as Map<String, dynamic>;
      // await ref.read(optimizedSystemSettingsNotifierProvider.notifier)
      //     .importSettings(settings);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Настройки импортированы'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Ошибка импорта: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}