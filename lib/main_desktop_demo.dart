import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PartCatalogDesktopDemo(),
    ),
  );
}

class PartCatalogDesktopDemo extends StatelessWidget {
  const PartCatalogDesktopDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part Catalog - Desktop Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DesktopDemoHomePage(),
    );
  }
}

class DesktopDemoHomePage extends StatefulWidget {
  const DesktopDemoHomePage({super.key});

  @override
  State<DesktopDemoHomePage> createState() => _DesktopDemoHomePageState();
}

class _DesktopDemoHomePageState extends State<DesktopDemoHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SuppliersConfigPage(),
    const PartsSearchPage(),
    const DocumentationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home),
                label: Text('Главная'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings),
                label: Text('Поставщики'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.search),
                label: Text('Поиск'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                selectedIcon: Icon(Icons.description),
                label: Text('Документы'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Catalog - Desktop Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeCard(),
            SizedBox(height: 24),
            FeaturesOverview(),
            SizedBox(height: 24),
            ArmtekImprovements(),
            SizedBox(height: 24),
            UnifiedConfigSystem(),
          ],
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.car_repair, size: 48, color: Colors.white),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Part Catalog',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Система управления каталогом запчастей',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              '🎉 Проект достиг стабильности и готов к продуктивному использованию!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Фаза 2 завершена на 70% - основная функциональность реализована',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturesOverview extends StatelessWidget {
  const FeaturesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ключевые возможности',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _FeatureCard(
                icon: Icons.check_circle,
                title: 'Стабильная база',
                description: '31/31 unit тестов проходят\nВосстановление после ошибок БД',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FeatureCard(
                icon: Icons.api,
                title: 'API интеграции',
                description: 'Armtek API полностью реализован\nПоддержка множественных поставщиков',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FeatureCard(
                icon: Icons.architecture,
                title: 'Гибкая архитектура',
                description: 'Riverpod + Drift + GoRouter\n1C + DDD паттерны',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ArmtekImprovements extends StatelessWidget {
  const ArmtekImprovements({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.upgrade, size: 32, color: Colors.orange),
                const SizedBox(width: 16),
                const Text(
                  'Улучшения Armtek API',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ImprovementItem(
              icon: Icons.check,
              title: 'Исправлены параметры API',
              description: 'number → PIN, brand → BRAND (корректные названия полей)',
            ),
            const _ImprovementItem(
              icon: Icons.add,
              title: 'Добавлены бизнес-параметры',
              description: 'KUNNR_RG, KUNNR_ZA, VBELN, INCOTERMS из PHP примера',
            ),
            const _ImprovementItem(
              icon: Icons.functions,
              title: 'Новые методы API',
              description: 'createTestOrder, getPriceStatusByKey для работы с заказами',
            ),
          ],
        ),
      ),
    );
  }
}

class UnifiedConfigSystem extends StatelessWidget {
  const UnifiedConfigSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_applications, size: 32, color: Colors.green),
                const SizedBox(width: 16),
                const Text(
                  'Унифицированная система конфигурации',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ImprovementItem(
              icon: Icons.settings_input_composite,
              title: 'Единый интерфейс настройки',
              description: 'Все поставщики настраиваются через одну систему',
            ),
            const _ImprovementItem(
              icon: Icons.security,
              title: 'Поддержка различных типов auth',
              description: 'Basic Auth, API Key, Bearer Token, OAuth2',
            ),
            const _ImprovementItem(
              icon: Icons.factory,
              title: 'Автоматическое создание клиентов',
              description: 'ApiClientFactory создает клиенты из конфигураций',
            ),
            const _ImprovementItem(
              icon: Icons.speed,
              title: 'Контроль лимитов и retry',
              description: 'Автоматическое отслеживание лимитов API и повторные попытки',
            ),
          ],
        ),
      ),
    );
  }
}

class _ImprovementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ImprovementItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Заглушки для других страниц
class SuppliersConfigPage extends StatelessWidget {
  const SuppliersConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройка поставщиков')),
      body: const Center(
        child: Text('Здесь будет интерфейс настройки поставщиков'),
      ),
    );
  }
}

class PartsSearchPage extends StatelessWidget {
  const PartsSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск запчастей')),
      body: const Center(
        child: Text('Здесь будет интерфейс поиска запчастей'),
      ),
    );
  }
}

class DocumentationPage extends StatelessWidget {
  const DocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Документация')),
      body: const Center(
        child: Text('Здесь будут ссылки на документацию'),
      ),
    );
  }
}