# 🚀 Testing Quick Start Guide

Быстрый старт для создания и запуска тестов в проекте Part Catalog.

## 📋 Чек-лист для нового разработчика

### ✅ Подготовка окружения
```bash
# 1. Установите зависимости
flutter pub get

# 2. Сгенерируйте код
dart run build_runner build

# 3. Запустите существующие тесты
flutter test
```

### ✅ Быстрые команды

```bash
# Запуск всех тестов с отчетом
dart test/run_all_tests.dart

# Запуск конкретного теста
flutter test test/widgets/core/custom_text_form_field_test.dart

# Запуск с coverage
flutter test --coverage

# Проверка только widget тестов
flutter test test/widgets/

# Генерация недостающих тестов
dart test/helpers/test_generator.dart
```

## 🎯 Когда писать тесты

### ✅ Обязательно тестируйте
- 🔴 **Сложные виджеты**: > 200 строк, StatefulWidget, Provider
- 🔴 **Формы**: Валидация, отправка данных
- 🔴 **Критичная логика**: Расчеты, бизнес-правила
- 🔴 **API интеграции**: Запросы, ошибки, состояния

### 🟡 Опционально тестируйте
- 🟡 **Средние виджеты**: 50-200 строк, простая логика
- 🟡 **Переиспользуемые компоненты**: Кнопки, поля ввода

### ⚪ Не тестируйте
- ⚪ **Простые виджеты**: Text, Container, статичные элементы
- ⚪ **Стандартные Flutter виджеты**: они уже протестированы

## 🛠️ Как создать тест

### 1. Для простого виджета

```dart
// test/widgets/my_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/widgets/my_widget.dart';

void main() {
  testWidgets('MyWidget should display text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MyWidget(text: 'Hello World'),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
  });
}
```

### 2. Для виджета с Provider

```dart
// test/widgets/provider_widget_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('ProviderWidget should show data', (tester) async {
    await tester.pumpWidget(
      TestHelpers.createTestApp(
        MyProviderWidget(),
        overrides: [
          dataProvider.overrideWith((ref) => AsyncValue.data('Test Data')),
        ],
      ),
    );

    expect(find.text('Test Data'), findsOneWidget);
  });
}
```

### 3. Для формы

```dart
// test/widgets/form_test.dart
void main() {
  testWidgets('Form should validate input', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyForm(),
        ),
      ),
    );

    // Отправляем пустую форму
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Проверяем ошибку валидации
    expect(find.text('This field is required'), findsOneWidget);
  });
}
```

## 🎨 Использование готовых базовых классов

### BaseWidgetTest - для обычных виджетов

```dart
import '../../helpers/base_widget_test.dart';

class MyWidgetTest extends BaseWidgetTest {
  @override
  String get widgetName => 'MyWidget';

  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return MyWidget(
      title: props?['title'] ?? 'Default Title',
    );
  }
}

void main() {
  final testSuite = MyWidgetTest();
  testSuite.runAllTests(); // Автоматически запустит базовые тесты
}
```

### BaseFormTest - для форм

```dart
class MyFormTest extends BaseFormTest {
  @override
  String get widgetName => 'MyForm';

  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return MyForm();
  }

  @override
  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(find.byKey(Key('name')), 'John Doe');
    await tester.enterText(find.byKey(Key('email')), 'john@example.com');
  }

  @override
  Future<void> submitForm(WidgetTester tester) async {
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
  }
}
```

## 🔧 Частые проблемы и решения

### ❌ Проблема: "findsNothing" вместо "findsOneWidget"
```dart
// ПЛОХО
await tester.pumpWidget(MyWidget());
expect(find.text('Hello'), findsOneWidget); // Может провалиться

// ХОРОШО  
await tester.pumpWidget(MyWidget());
await tester.pump(); // Ждем отрисовку
expect(find.text('Hello'), findsOneWidget);
```

### ❌ Проблема: Тесты с Provider падают
```dart
// ПЛОХО
await tester.pumpWidget(MyProviderWidget());

// ХОРОШО
await tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(
      home: MyProviderWidget(),
    ),
  ),
);
```

### ❌ Проблема: Overflow ошибки в тестах
```dart
// ХОРОШО - используйте TestHelpers
await TestHelpers.expectNoOverflow(
  tester,
  MyWidget(),
  screenSize: Size(320, 568), // iPhone SE
);
```

## 📊 Проверка покрытия

### Запуск с coverage
```bash
# Генерируем coverage
flutter test --coverage

# Просматриваем отчет (если установлен genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Анализ недостающих тестов
```bash
# Анализ какие файлы нужно тестировать
dart test/helpers/test_generator.dart

# Пример вывода:
# Files needing tests:
#   - lib/widgets/complex_widget.dart (Сложный - обязательно тестирование)
#   - lib/screens/order_form.dart (Сложный - обязательно тестирование)
```

## 🚀 Автоматизация

### Pre-commit хук
```bash
# .git/hooks/pre-commit
#!/bin/sh
echo "🧪 Running tests before commit..."
flutter test --reporter=compact
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Commit aborted."
  exit 1
fi
echo "✅ Tests passed!"
```

### VS Code настройки
```json
// .vscode/settings.json
{
  "dart.testAdditionalArgs": [
    "--reporter=expanded"
  ],
  "dart.runPubGetOnPubspecChanges": true,
  "flutter.hot-reload-on-save": "manual"
}
```

### VS Code tasks
```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run All Tests",
      "type": "shell",
      "command": "dart test/run_all_tests.dart",
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always"
      }
    }
  ]
}
```

## 🎯 Типичные сценарии

### Тестирование списков
```dart
testWidgets('should display list of items', (tester) async {
  final items = ['Item 1', 'Item 2', 'Item 3'];
  
  await tester.pumpWidget(
    MaterialApp(
      home: ItemList(items: items),
    ),
  );

  for (final item in items) {
    expect(find.text(item), findsOneWidget);
  }
});
```

### Тестирование навигации
```dart
testWidgets('should navigate to details screen', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
      },
    ),
  );

  await tester.tap(find.text('Go to Details'));
  await tester.pumpAndSettle();

  expect(find.byType(DetailsScreen), findsOneWidget);
});
```

### Тестирование асинхронных операций
```dart
testWidgets('should show loading then data', (tester) async {
  await tester.pumpWidget(MyAsyncWidget());

  // Проверяем loading state
  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  // Ждем загрузку данных
  await tester.pumpAndSettle();

  // Проверяем loaded state
  expect(find.text('Loaded Data'), findsOneWidget);
  expect(find.byType(CircularProgressIndicator), findsNothing);
});
```

## 📚 Полезные ресурсы

### Документация
- [Детальная стратегия тестирования](../architecture/testing_strategy.md)
- [Flutter Testing Cookbook](https://docs.flutter.dev/cookbook/testing)

### Примеры в проекте
- `test/widgets/core/custom_text_form_field_test.dart` - простой виджет
- `test/widgets/core/app_dialog_test.dart` - диалог с состояниями
- `test/widgets/orders/order_list_item_test.dart` - сложный виджет с Provider

### Команды проекта
```bash
# Полный список доступных команд
dart test/run_all_tests.dart --help

# Доступные команды:
# (без команды)  Запустить все тесты
# --categories   Запустить тесты по категориям  
# --performance  Тесты производительности
# --failed       Повторить проваленные тесты
# --clean        Очистить кэш тестов
```

---

**🎯 Цель**: 80%+ покрытие тестами для критичных компонентов  
**⏱️ Время на тест**: 5-15 минут для простого виджета  
**🆘 Помощь**: Обращайтесь к команде при вопросах по тестированию