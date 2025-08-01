import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/screens/parts_search_screen.dart';
import 'package:part_catalog/features/suppliers/screens/supplier_config_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: TranslationProvider(
        child: const PartCatalogWebApp(),
      ),
    ),
  );
}

class PartCatalogWebApp extends StatelessWidget {
  const PartCatalogWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part Catalog - Web Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WebDemoHomePage(),
    );
  }
}

class WebDemoHomePage extends StatelessWidget {
  const WebDemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Catalog - Web Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.car_repair,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Part Catalog',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Система управления каталогом запчастей для СТО',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              const Text(
                'Демонстрация новых возможностей:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _DemoCard(
                    icon: Icons.settings,
                    title: 'Настройка поставщиков',
                    description: 'Унифицированная система конфигурации API',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SupplierConfigScreen(),
                        ),
                      );
                    },
                  ),
                  _DemoCard(
                    icon: Icons.search,
                    title: 'Поиск запчастей',
                    description: 'Интеграция с API поставщиков',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PartsSearchScreen(),
                        ),
                      );
                    },
                  ),
                  _DemoCard(
                    icon: Icons.api,
                    title: 'Armtek API',
                    description: 'Улучшенная интеграция с корректными параметрами',
                    onTap: () {
                      _showApiInfoDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Примечание: Это веб-демо версия. Полная функциональность доступна в настольной версии.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApiInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Улучшения Armtek API'),
        content: const SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✅ Исправлены параметры API:'),
              Text('• number → PIN (правильное название)'),
              Text('• brand → BRAND (корректный регистр)'),
              SizedBox(height: 16),
              Text('✅ Добавлены методы:'),
              Text('• createTestOrder - создание заказов'),
              Text('• getPriceStatusByKey - статус обработки'),
              SizedBox(height: 16),
              Text('✅ Дополнительные параметры:'),
              Text('• KUNNR_RG - код покупателя'),
              Text('• VBELN - номер договора'),
              Text('• INCOTERMS - условия доставки'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _DemoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}