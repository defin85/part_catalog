import 'package:flutter/material.dart';

void main() {
  runApp(const PartCatalogSimpleDemo());
}

class PartCatalogSimpleDemo extends StatelessWidget {
  const PartCatalogSimpleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part Catalog - Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Catalog - Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Icon(
              Icons.car_repair,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'Part Catalog',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Система управления каталогом запчастей для СТО',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
            FeatureCard(
              icon: Icons.api,
              title: 'Улучшенная интеграция с Armtek API',
              features: [
                'Исправлены параметры API (number → PIN, brand → BRAND)',
                'Добавлены дополнительные параметры: KUNNR_RG, KUNNR_ZA, VBELN',
                'Новые методы: createTestOrder, getPriceStatusByKey',
                'Поддержка всех бизнес-параметров из PHP примера',
              ],
            ),
            SizedBox(height: 32),
            FeatureCard(
              icon: Icons.settings_applications,
              title: 'Унифицированная система конфигурации',
              features: [
                'Единый интерфейс для настройки всех поставщиков',
                'Поддержка различных типов аутентификации',
                'Автоматическое создание API клиентов',
                'Контроль лимитов и retry механизмы',
              ],
            ),
            SizedBox(height: 32),
            FeatureCard(
              icon: Icons.architecture,
              title: 'Гибкая архитектура',
              features: [
                'Модель SupplierConfig с поддержкой любых API',
                'Фабрика ApiClientFactory для создания клиентов',
                'Интерсепторы для retry и rate limiting',
                'Riverpod провайдеры для управления состоянием',
              ],
            ),
            SizedBox(height: 48),
            ConfigExampleCard(),
            SizedBox(height: 48),
            Divider(),
            SizedBox(height: 24),
            Text(
              'Документация:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DocumentationLinks(),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> features;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.features,
  });

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
                Icon(icon, size: 32, color: Colors.blue),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ConfigExampleCard extends StatelessWidget {
  const ConfigExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.code, size: 32, color: Colors.green),
                SizedBox(width: 16),
                Text(
                  'Пример конфигурации поставщика',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''final armtekConfig = SupplierConfigFactories.createArmtekConfig(
  username: 'user@example.com',
  password: 'password123',
  vkorg: '1000',
  customerCode: 'CUST001',
  contractNumber: 'CONTRACT001',
  useProxy: false,
);

await configService.saveConfig(armtekConfig);
final client = ApiClientFactory.createClient(armtekConfig, dio);''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentationLinks extends StatelessWidget {
  const DocumentationLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DocLink(
          icon: Icons.description,
          title: 'ARMTEK_API_IMPROVEMENTS.md',
          subtitle: 'Анализ и улучшения Armtek API',
        ),
        SizedBox(height: 8),
        _DocLink(
          icon: Icons.integration_instructions,
          title: 'UNIFIED_SUPPLIER_API_CONFIG.md',
          subtitle: 'Документация унифицированной системы',
        ),
        SizedBox(height: 8),
        _DocLink(
          icon: Icons.code,
          title: 'CLAUDE.md',
          subtitle: 'Руководство для разработчиков',
        ),
        SizedBox(height: 8),
        _DocLink(
          icon: Icons.map,
          title: 'ROADMAP.md',
          subtitle: 'Дорожная карта развития проекта',
        ),
      ],
    );
  }
}

class _DocLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DocLink({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Документ: $title')),
          );
        },
      ),
    );
  }
}
