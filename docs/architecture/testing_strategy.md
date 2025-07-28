# 🧪 Testing Strategy & Architecture

## Обзор

Данный документ описывает комплексную стратегию тестирования для приложения Part Catalog, включая архитектуру тестов, принципы организации и лучшие практики.

## 📋 Содержание

1. [Архитектура тестирования](#🏗️-архитектура-тестирования)
2. [Типы тестов](#🎯-типы-тестов)
3. [Инфраструктура](#🔧-инфраструктура)
4. [Стратегии тестирования](#📊-стратегии-тестирования)
5. [Автоматизация](#🚀-автоматизация)
6. [Best Practices](#💡-best-practices)
7. [CI/CD Integration](#🔄-cicd-integration)

---

## 🏗️ Архитектура тестирования

### Пирамида тестов

```
    /\
   /  \         🔺 E2E Tests (5%)
  /____\             - Full user flows
 /      \            - Cross-platform
/__E2E___\           - Critical paths

/\        /\    🔸 Integration Tests (15%)
/  \      /  \       - API integration
/____\    /____\     - Database operations
/__I___\  \______/   - Provider interactions

/\    /\    /\    🔹 Widget Tests (30%)
/  \  /  \  /  \      - UI components
/____\/____\/____\    - User interactions
/___Widget_Tests__\   - Visual regression

/\  /\  /\  /\  /\  ⬜ Unit Tests (50%)
/__\/__\/__\/__\/__\    - Business logic
/____Unit_Tests_____\   - Pure functions
\____________________/  - Models & Services
```

### Структура тестовых файлов

```
test/
├── helpers/                    # 🔧 Утилиты и помощники
│   ├── test_helpers.dart      # Общие утилиты
│   ├── base_widget_test.dart  # Базовые классы
│   ├── test_generator.dart    # Автогенерация тестов
│   └── test_service_locator.dart
├── mocks/                     # 🎭 Моки и стабы
│   ├── mock_services.dart
│   └── mock_services.mocks.dart
├── fixtures/                  # 📝 Тестовые данные
│   └── test_data.dart
├── unit/                      # ⚡ Unit тесты
│   ├── models/
│   ├── services/
│   └── providers/
├── widgets/                   # 🎨 Widget тесты
│   ├── core/
│   ├── screens/
│   └── features/
├── integration/               # 🔗 Интеграционные тесты
│   ├── api/
│   ├── database/
│   └── flows/
├── performance/               # ⚡ Performance тесты
├── accessibility/             # ♿ Accessibility тесты
├── golden/                    # 🖼️ Golden тесты
└── run_all_tests.dart        # 🚀 Runner script
```

---

## 🎯 Типы тестов

### 1. Unit Tests (50%)
**Цель**: Тестирование изолированных единиц кода

```dart
// Пример unit теста
testWidgets('OrderService should calculate total correctly', () {
  // Given
  final order = Order(items: [
    OrderItem(price: 100, quantity: 2),
    OrderItem(price: 50, quantity: 1),
  ]);
  
  // When
  final total = OrderService.calculateTotal(order);
  
  // Then
  expect(total, 250);
});
```

**Покрывают**:
- 🧮 Business logic
- 📊 Data models
- 🔄 Pure functions
- ⚙️ Utilities

### 2. Widget Tests (30%)
**Цель**: Тестирование UI компонентов

```dart
// Пример widget теста
testWidgets('CustomButton should handle tap', (tester) async {
  bool wasPressed = false;
  
  await tester.pumpWidget(
    CustomButton(
      onPressed: () => wasPressed = true,
      child: Text('Test'),
    ),
  );
  
  await tester.tap(find.text('Test'));
  expect(wasPressed, isTrue);
});
```

**Покрывают**:
- 🎨 UI components
- 🖱️ User interactions
- 📱 Responsive behavior
- 🔄 State changes

### 3. Integration Tests (15%)
**Цель**: Тестирование взаимодействия компонентов

```dart
// Пример integration теста
testWidgets('Order creation flow', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Navigate to order form
  await tester.tap(find.text('New Order'));
  await tester.pumpAndSettle();
  
  // Fill form
  await tester.enterText(find.byKey(Key('client')), 'Test Client');
  await tester.tap(find.text('Save'));
  
  // Verify order created
  expect(find.text('Order created successfully'), findsOneWidget);
});
```

**Покрывают**:
- 🔗 API integrations
- 💾 Database operations
- 🔄 Provider interactions
- 🧩 Component integration

### 4. E2E Tests (5%)
**Цель**: Тестирование полных пользовательских сценариев

```dart
// Пример E2E теста
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete order workflow', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Login
    await tester.enterText(find.byKey(Key('username')), 'admin');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Create order
    await tester.tap(find.text('Orders'));
    await tester.tap(find.text('New Order'));
    // ... complete workflow
    
    // Verify in database
    final orders = await OrderService.getAllOrders();
    expect(orders.length, 1);
  });
}
```

---

## 🔧 Инфраструктура

### Базовые классы тестов

#### BaseWidgetTest
```dart
abstract class BaseWidgetTest {
  String get widgetName;
  Widget createWidget({Map<String, dynamic>? props});
  List<Override> get providerOverrides => [];
  
  void runBaseTests() {
    // Базовые тесты для всех виджетов
    testWidgets('should render without errors', ...);
    testWidgets('should not have overflow errors', ...);
    testWidgets('should be responsive', ...);
    testWidgets('should render within performance threshold', ...);
  }
}
```

#### BaseScreenTest
```dart
abstract class BaseScreenTest extends BaseWidgetTest {
  void runNavigationTests() { /* Navigation tests */ }
  void runLoadingTests() { /* Loading state tests */ }
  void runErrorTests() { /* Error handling tests */ }
}
```

#### BaseFormTest
```dart
abstract class BaseFormTest extends BaseWidgetTest {
  void runValidationTests() { /* Form validation tests */ }
  void runSubmissionTests() { /* Form submission tests */ }
  
  Future<void> fillValidForm(WidgetTester tester);
  Future<void> fillInvalidForm(WidgetTester tester);
}
```

### Test Helpers

#### TestHelpers
```dart
class TestHelpers {
  // Создание тестового окружения
  static Widget createTestApp(Widget child, {List<Override>? overrides});
  
  // Проверка overflow
  static Future<void> expectNoOverflow(WidgetTester tester, Widget widget);
  
  // Responsive тестирование
  static Future<void> testResponsiveness(WidgetTester tester, Widget widget);
  
  // Performance тестирование
  static Future<void> testPerformance(WidgetTester tester, Widget widget);
  
  // Константы размеров экранов
  static const mobilePortrait = Size(375, 667);
  static const desktop = Size(1920, 1080);
}
```

---

## 📊 Стратегии тестирования

### 1. По сложности виджета

#### 🟢 Простые виджеты (Не тестируем)
- Статичные Text, Container, Icon
- Обертки без логики
- **Критерий**: < 50 строк, нет логики

#### 🟡 Средние виджеты (Выборочно)
- Переиспользуемые компоненты
- Простая условная логика
- **Критерий**: 50-200 строк, простая логика

#### 🔴 Сложные виджеты (Обязательно)
- StatefulWidget с состоянием
- Provider/Riverpod интеграция
- Формы с валидацией
- **Критерий**: > 200 строк, сложная логика

### 2. По типу компонента

#### Core Widgets
```dart
// Пример теста для core компонента
class CustomTextFormFieldTest extends BaseFormTest {
  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return CustomTextFormField(
      controller: props?['controller'] ?? TextEditingController(),
      labelText: props?['labelText'] ?? 'Test Label',
      validator: props?['validator'],
    );
  }
  
  @override
  List<FormValidationTest> getValidationTests() {
    return [
      FormValidationTest(
        fieldName: 'required field',
        perform: (tester) async { /* test logic */ },
        verify: (tester) async { /* verify logic */ },
      ),
    ];
  }
}
```

#### Feature Widgets
```dart
// Пример теста для feature виджета
class OrderListItemTest extends BaseWidgetTest {
  @override
  List<Override> get providerOverrides => [
    clientProvider.overrideWith((ref) => AsyncValue.data(mockClient)),
    carProvider.overrideWith((ref) => AsyncValue.data(mockCar)),
  ];
  
  @override
  List<WidgetTestState> getTestStates() {
    return [
      WidgetTestState(
        name: 'loading state',
        overrides: [clientProvider.overrideWith((ref) => AsyncValue.loading())],
        verify: (tester) async {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      ),
    ];
  }
}
```

### 3. Специализированные тесты

#### Golden Tests (Visual Regression)
```dart
testWidgets('should match golden file', (tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('my_widget.png'),
  );
});
```

#### Accessibility Tests
```dart
testWidgets('should be accessible', (tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
});
```

#### Performance Tests
```dart
testWidgets('should render quickly', (tester) async {
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(MyWidget());
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
});
```

---

## 🚀 Автоматизация

### Test Generator

#### Автоматическая генерация тестов
```dart
// Использование генератора
void main() async {
  // Анализ существующих виджетов
  final report = await TestGenerator.generateCoverageReport(
    'lib/features/',
    'test/widgets/',
  );
  
  report.printReport();
  
  // Генерация недостающих тестов
  await TestGenerator.generateAllWidgetTests(
    'lib/features/',
    'test/widgets/',
  );
}
```

#### Анализ сложности виджетов
```dart
enum WidgetComplexity {
  trivial,    // Не требует тестирования
  simple,     // Опционально
  medium,     // Рекомендуется
  complex,    // Обязательно
}

WidgetComplexity analyzeWidget(String dartCode) {
  // Анализ на основе ключевых слов и размера файла
  // StatefulWidget, Provider, LayoutBuilder = +2 complexity
  // ListView, Column, Row = +1 complexity
  // > 500 lines = +3 complexity
}
```

### Test Runner

#### Командная строка
```bash
# Запуск всех тестов
dart test/run_all_tests.dart

# По категориям
dart test/run_all_tests.dart --categories

# Performance тесты
dart test/run_all_tests.dart --performance

# Только проваленные
dart test/run_all_tests.dart --failed

# Очистка кэша
dart test/run_all_tests.dart --clean
```

#### Автоматические отчеты
- 📊 Coverage report (HTML)
- 🐌 Slow tests detection
- ❌ Failed tests retry
- 📈 Performance metrics

---

## 💡 Best Practices

### 1. Организация тестов

#### ✅ DO
```dart
// Группировка по функциональности
group('OrderListItem Widget Tests', () {
  group('Display Tests', () {
    testWidgets('should show order number', ...);
    testWidgets('should show client name', ...);
  });
  
  group('Interaction Tests', () {
    testWidgets('should handle tap', ...);
    testWidgets('should handle swipe', ...);
  });
});
```

#### ❌ DON'T
```dart
// Плоская структура без группировки
testWidgets('test 1', ...);
testWidgets('test 2', ...);
testWidgets('test 3', ...);
```

### 2. Именование тестов

#### ✅ DO
```dart
testWidgets('should display error message when client not found', ...);
testWidgets('should disable submit button when form is invalid', ...);
testWidgets('should navigate to order details when item tapped', ...);
```

#### ❌ DON'T
```dart
testWidgets('test error', ...);
testWidgets('button test', ...);
testWidgets('navigation', ...);
```

### 3. Мокирование

#### ✅ DO
```dart
// Специфичные моки для каждого теста
@override
List<Override> get providerOverrides => [
  orderServiceProvider.overrideWith((ref) => MockOrderService()),
  clientProvider('123').overrideWith((ref) => AsyncValue.data(mockClient)),
];
```

#### ❌ DON'T
```dart
// Глобальные моки для всех тестов
setUp(() {
  GetIt.instance.registerSingleton<OrderService>(MockOrderService());
});
```

### 4. Асинхронность

#### ✅ DO
```dart
testWidgets('should load data', (tester) async {
  await tester.pumpWidget(MyWidget());
  await tester.pumpAndSettle(); // Ждем загрузку
  
  expect(find.text('Loaded data'), findsOneWidget);
});
```

#### ❌ DON'T
```dart
testWidgets('should load data', (tester) async {
  await tester.pumpWidget(MyWidget());
  // Не ждем загрузку
  
  expect(find.text('Loaded data'), findsOneWidget); // Может провалиться
});
```

### 5. Проверки

#### ✅ DO
```dart
// Специфичные проверки
expect(find.text('Order #12345'), findsOneWidget);
expect(controller.text, 'Expected value');
expect(mockService.callCount, 1);
```

#### ❌ DON'T
```dart
// Общие проверки
expect(find.byType(Widget), findsWidgets);
expect(result, isNotNull);
```

---

## 🔄 CI/CD Integration

### GitHub Actions Workflow

```yaml
name: 🧪 Tests & Quality Checks

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    name: 🧪 Run Tests
    runs-on: ubuntu-latest
    
    steps:
    - name: 📥 Checkout code
      uses: actions/checkout@v4
      
    - name: 🐦 Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        
    - name: 📦 Get dependencies
      run: flutter pub get
      
    - name: 🔧 Generate code
      run: dart run build_runner build --delete-conflicting-outputs
      
    - name: 🔍 Analyze code
      run: flutter analyze
      
    - name: 🧪 Run tests with coverage
      run: flutter test --coverage
      
    - name: 📊 Check coverage threshold
      run: |
        COVERAGE=$(grep -o '[0-9]*\.[0-9]*%' coverage_report.txt | head -1 | sed 's/%//')
        if (( $(echo "$COVERAGE < 80" | bc -l) )); then
          echo "❌ Coverage too low: $COVERAGE%"
          exit 1
        fi
```

### Качество кода

#### Coverage Requirements
- **Минимум**: 80% line coverage
- **Цель**: 90% line coverage
- **Критичные компоненты**: 95%+ coverage

#### Performance Thresholds
- **Widget render time**: < 100ms
- **Test execution time**: < 5s per test
- **Memory usage**: < 50MB increase during tests

#### Quality Gates
```yaml
# Проверки перед merge
- name: 🎯 Quality Gates
  run: |
    # Проверка coverage
    if [[ $COVERAGE -lt 80 ]]; then exit 1; fi
    
    # Проверка производительности
    if [[ $SLOW_TESTS -gt 0 ]]; then exit 1; fi
    
    # Проверка accessibility
    flutter test test/accessibility/ --reporter=expanded
```

---

## 📈 Метрики и мониторинг

### Test Metrics Dashboard

```
📊 Test Coverage Report
========================
Total files: 156
Files with tests: 124
Coverage: 89.2%

🎯 By Category:
- Core widgets: 95.2%
- Feature widgets: 87.4%
- Screens: 82.1%
- Services: 91.8%

⚡ Performance:
- Average test time: 2.3s
- Slow tests (>5s): 3
- Memory usage: +23MB

♿ Accessibility:
- Tested components: 45/67
- Accessibility coverage: 67.2%
```

### Continuous Monitoring

#### Slack Notifications
```yaml
- name: 📱 Notify on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    text: |
      🚨 Tests failed in ${{ github.repository }}
      Branch: ${{ github.ref }}
      Coverage: ${{ env.COVERAGE }}%
```

#### Test Results History
- 📈 Coverage trends over time
- ⏱️ Performance regression detection
- 🐛 Flaky test identification
- 📊 Test stability metrics

---

## 🚀 Roadmap

### Phase 1: Foundation (Completed ✅)
- [x] Base test infrastructure
- [x] Core widget tests
- [x] Test automation scripts
- [x] CI/CD integration

### Phase 2: Expansion (In Progress 🔄)
- [ ] Complete feature widget coverage
- [ ] Integration test suite
- [ ] Performance benchmarks
- [ ] Accessibility audit

### Phase 3: Advanced (Planned 📋)
- [ ] Visual regression testing
- [ ] Cross-platform test matrix
- [ ] Automated test generation
- [ ] AI-powered test optimization

---

## 📚 Дополнительные ресурсы

### Документация
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Test Best Practices](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Инструменты
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [mockito](https://pub.dev/packages/mockito)
- [golden_toolkit](https://pub.dev/packages/golden_toolkit)

### Примеры
```bash
# Запуск конкретного теста
flutter test test/widgets/core/custom_text_form_field_test.dart

# Запуск с coverage
flutter test --coverage

# Golden tests update
flutter test --update-goldens

# Performance profiling
flutter test --reporter=json > results.json
```

---

*Документ поддерживается командой разработки. Последнее обновление: $(date)*