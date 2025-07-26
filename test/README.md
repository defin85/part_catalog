# Тесты Part Catalog

Этот каталог содержит все тесты для приложения Part Catalog.

## Структура тестов

```
test/
├── fixtures/           # Тестовые данные
├── helpers/            # Вспомогательные классы для тестов
├── integration/        # Интеграционные тесты
├── mocks/             # Моки и заглушки
├── unit/              # Unit тесты
├── widget/            # Widget тесты
├── test_config.dart   # Конфигурация тестов
└── README.md          # Этот файл
```

## Запуск тестов

### Все тесты
```bash
flutter test
```

### Unit тесты
```bash
flutter test test/unit/
```

### Widget тесты
```bash
flutter test test/widget/
```

### Конкретный тест
```bash
flutter test test/unit/services/client_service_simple_test.dart
```

## Текущий статус тестирования

### ✅ Завершено

#### Unit тесты
- **ClientService** (`test/unit/services/`)
  - `client_service_simple_test.dart` - 8 тестов
  - Покрытие: базовые методы сервиса
  - Моки: MockAppDatabase, MockClientService, MockClientsDao

#### Widget тесты
- **ClientsScreen** (`test/widget/screens/`)
  - `clients_screen_simple_test.dart` - 8 тестов
  - Покрытие: основная структура UI, базовые взаимодействия
  - Проверки: Scaffold, AppBar, FAB, TextField, обработка ввода

#### Инфраструктура
- **Структура папок** - настроена и готова к расширению
- **Зависимости** - mockito, mocktail, integration_test
- **Helper классы** - TestHelpers с утилитами для виджет-тестов
- **Моки** - базовые моки для сервисов и DAO
- **Тестовые данные** - частично настроены (требуют доработки)

### 🔄 В процессе

- Расширение покрытия unit тестов
- Добавление тестов для других экранов
- Интеграционные тесты

### ❌ Планируется

#### Unit тесты
- CarService тесты
- OrderService тесты
- Provider тесты (Riverpod)
- DAO тесты
- Модели данных тесты

#### Widget тесты
- OrdersScreen тесты
- HomeScreen тесты
- Формы добавления/редактирования
- Navigation тесты

#### Integration тесты
- Полные пользовательские сценарии
- Тесты базы данных
- API интеграции

## Соглашения по тестированию

### Именование файлов
- Unit тесты: `{class_name}_test.dart`
- Widget тесты: `{screen_name}_test.dart`
- Простые тесты: `{name}_simple_test.dart`

### Структура тестов
```dart
void main() {
  group('ComponentName Tests', () {
    late MockDependency mockDependency;
    
    setUp(() {
      mockDependency = MockDependency();
    });
    
    group('methodName', () {
      test('should do something when condition', () async {
        // Arrange
        // Act  
        // Assert
      });
    });
  });
}
```

### Организация
- Один файл теста на один класс/виджет
- Группировка тестов по функциональности
- Описательные имена тестов
- Паттерн Arrange-Act-Assert

## Известные проблемы

1. **Композитные модели** - сложность создания тестовых данных для сложных моделей
2. **Mockito именованные параметры** - требуют специального синтаксиса
3. **Fixture данные** - требуют обновления под реальные модели

## Следующие шаги

1. Добавить тесты для CarService
2. Создать тесты для OrderService  
3. Расширить widget тесты для других экранов
4. Настроить интеграционные тесты
5. Добавить golden тесты для UI
6. Настроить CI/CD для автоматического запуска тестов

## Метрики

- **Unit тесты**: 8 тестов
- **Widget тесты**: 8 тестов
- **Общее покрытие**: ~15% (начальная стадия)
- **Цель покрытия**: 80%

## Полезные команды

```bash
# Генерация мокв
dart run build_runner build test

# Запуск с покрытием
flutter test --coverage

# Запуск в режиме watch
flutter test --watch

# Запуск только измененных тестов
flutter test --coverage --test-randomize-ordering-seed random
```