/// Конфигурация для тестов
///
/// Этот файл содержит общие настройки и константы для тестов.
library;

/// Конфигурация тестов
class TestConfig {
  /// Таймаут по умолчанию для тестов
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// Таймаут для медленных тестов (например, интеграционных)
  static const Duration slowTestTimeout = Duration(seconds: 30);

  /// Включить подробное логирование в тестах
  static const bool verboseLogging = true;

  /// Папки с тестами
  static const String unitTestsDir = 'test/unit';
  static const String widgetTestsDir = 'test/widgets';
  static const String integrationTestsDir = 'test/integration';
  static const String goldenTestsDir = 'test/golden';
  static const String performanceTestsDir = 'test/performance';
  static const String accessibilityTestsDir = 'test/accessibility';

  /// Настройки для golden тестов
  static const double goldenFileThreshold = 0.01;
}

/// Утилиты для настройки тестов
class TestUtils {
  /// Настраивает тестовое окружение
  static void setupTestEnvironment() {
    // Настройка таймаутов выполняется в конфигурации отдельных тестов
    // при необходимости через timeout parameter

    // Настройка для golden тестов
    if (TestConfig.goldenFileThreshold > 0) {
      // Здесь можно добавить настройки для golden файлов
    }
  }

  /// Очищает тестовое окружение после тестов
  static void teardownTestEnvironment() {
    // Очистка ресурсов если нужно
  }
}

/// Константы для тестов
class TestConstants {
  // Тестовые UUID
  static const String testUuid1 = 'test-uuid-1';
  static const String testUuid2 = 'test-uuid-2';
  static const String testUuid3 = 'test-uuid-3';

  // Тестовые коды
  static const String testClientCode = 'TEST001';
  static const String testCarLicense = 'А123БВ77';
  static const String testOrderNumber = 'ORD-001';

  // Тестовые строки
  static const String testClientName = 'Тестовый Клиент';
  static const String testCarMake = 'Toyota';
  static const String testCarModel = 'Camry';
  static const String testSearchQuery = 'тест';

  // Тестовые числа
  static const int testCarYear = 2020;
  static const double testPrice = 1000.0;
  static const int testQuantity = 1;
}

/// Группы тестов для организации
class TestGroups {
  static const String unit = 'Unit Tests';
  static const String widget = 'Widget Tests';
  static const String integration = 'Integration Tests';
  static const String services = 'Services';
  static const String models = 'Models';
  static const String providers = 'Providers';
  static const String screens = 'Screens';
  static const String database = 'Database';
  static const String api = 'API';
}
