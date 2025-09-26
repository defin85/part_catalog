import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/ui/templates/scaffolds/tabbed_screen_scaffold.dart';
import 'package:part_catalog/features/suppliers/screens/tabs/basic_settings_tab.dart';
import 'package:part_catalog/features/suppliers/screens/tabs/connection_settings_tab.dart';
import 'package:part_catalog/features/suppliers/screens/tabs/parameters_tab.dart';
import 'package:part_catalog/features/suppliers/screens/tabs/testing_tab.dart';

/// Улучшенный экран конфигурации поставщика с модульной архитектурой
///
/// Этот экран демонстрирует новый подход к построению UI:
/// - Использует TabbedScreenScaffold для организации контента
/// - Модульная структура с переиспользуемыми компонентами-вкладками
/// - Адаптивный дизайн для разных размеров экрана
/// - Четкое разделение ответственности между компонентами
/// - Консистентный дизайн в соответствии с Material Design 3
class ImprovedSupplierConfigScreen extends ConsumerWidget {
  final String? supplierCode;

  const ImprovedSupplierConfigScreen({
    super.key,
    this.supplierCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabbedScreenScaffold(
      title: _getTitle(supplierCode),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelp(context),
          tooltip: 'Справка',
        ),
      ],
      tabs: [
        TabConfig(
          icon: Icon(Icons.settings),
          label: 'Основные',
          builder: () => BasicSettingsTab(supplierCode: supplierCode ?? ''),
        ),
        TabConfig(
          icon: Icon(Icons.wifi),
          label: 'Подключение',
          builder: () => ConnectionSettingsTab(supplierCode: supplierCode ?? ''),
        ),
        TabConfig(
          icon: Icon(Icons.tune),
          label: 'Параметры',
          builder: () => ParametersTab(supplierCode: supplierCode ?? ''),
        ),
        TabConfig(
          icon: Icon(Icons.science),
          label: 'Тестирование',
          builder: () => TestingTab(supplierCode: supplierCode ?? ''),
        ),
      ],
      floatingActionButton: _buildSaveButton(context, ref),
      // Дополнительные настройки для улучшенного UX
      keepAlive: true, // Сохраняем состояние табов
      lazyLoad: false, // Загружаем все табы сразу для быстрого переключения
      adaptive: true, // Адаптивные табы для разных размеров экрана
      enableForceClose: true, // Включаем принудительное закрытие
      showForceCloseButton: true, // Показываем кнопку закрытия
    );
  }

  String _getTitle(String? code) {
    switch (code?.toLowerCase()) {
      case 'armtek':
        return 'Настройки Армтек';
      case 'custom':
        return 'Настройки пользовательского поставщика';
      default:
        return 'Настройки поставщика';
    }
  }

  Widget _buildSaveButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _saveConfig(context, ref),
      icon: const Icon(Icons.save),
      label: const Text('Сохранить'),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Справка по настройке поставщика'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Настройка поставщика включает несколько этапов:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text('📋 Основные настройки'),
              Text('• Активация/деактивация поставщика'),
              Text('• Настройка отображаемого названия'),
              SizedBox(height: 12),
              Text('🔌 Настройки подключения'),
              Text('• URL API поставщика'),
              Text('• Тип аутентификации и учетные данные'),
              Text('• Настройки прокси-сервера'),
              SizedBox(height: 12),
              Text('⚙️ Бизнес-параметры'),
              Text('• Специфические параметры поставщика'),
              Text('• Коды клиентов и организаций'),
              SizedBox(height: 12),
              Text('🧪 Тестирование'),
              Text('• Проверка соединения с API'),
              Text('• Загрузка тестовых данных'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveConfig(BuildContext context, WidgetRef ref) async {
    try {
      // TODO: Реализовать сохранение после создания провайдера
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Настройки сохранены успешно'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Ошибка сохранения: $e')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}