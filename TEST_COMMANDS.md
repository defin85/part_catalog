# 🧪 Testing Commands Cheat Sheet

## 🚀 Основные команды

```bash
# Запуск всех тестов
flutter test

# Запуск с подробным выводом  
flutter test --reporter=expanded

# Запуск с покрытием кода
flutter test --coverage

# Запуск конкретного теста
flutter test test/widgets/core/custom_text_form_field_test.dart

# Запуск тестов по директории
flutter test test/widgets/
flutter test test/unit/
```

## 🎯 Специальные команды проекта

```bash
# Запуск всех тестов с отчетом
dart test/run_all_tests.dart

# Запуск по категориям (unit, widget, integration)
dart test/run_all_tests.dart --categories

# Запуск только performance тестов
dart test/run_all_tests.dart --performance

# Повторный запуск только проваленных тестов
dart test/run_all_tests.dart --failed

# Очистка кэша тестов
dart test/run_all_tests.dart --clean

# Анализ покрытия и генерация недостающих тестов
dart test/helpers/test_generator.dart
```

## 🔧 Отладка и анализ

```bash
# Запуск с подробной отладочной информацией
flutter test --verbose

# Запуск в режиме отладки (для breakpoints)
flutter test --start-paused

# Генерация coverage HTML отчета (если установлен genhtml)
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Проверка только анализа кода без тестов
flutter analyze

# Форматирование кода перед тестами
dart format lib/ test/
```

## 🎨 Golden тесты (визуальная регрессия)

```bash
# Обновление golden файлов
flutter test --update-goldens

# Запуск только golden тестов
flutter test test/golden/

# Сравнение с golden файлами
flutter test test/golden/ --reporter=expanded
```

## ⚡ Performance и профилирование

```bash
# Запуск с профилированием памяти
flutter test --reporter=json > test_results.json

# Анализ медленных тестов
grep -i "slow\|timeout" test_results.json

# Запуск с ограничением времени
timeout 300 flutter test  # 5 минут максимум
```

## 🔄 CI/CD команды

```bash
# Команда для CI (быстрая, без UI)
flutter test --reporter=compact --concurrency=4

# Полный набор проверок как в CI
flutter analyze
flutter test --coverage --reporter=compact
dart format --set-exit-if-changed lib/ test/
```

## 📊 Анализ покрытия

```bash
# Быстрая проверка покрытия
flutter test --coverage && grep -o '[0-9]*\.[0-9]*%' coverage/lcov.info

# Детальный анализ по файлам
lcov --summary coverage/lcov.info

# Поиск непокрытых строк
lcov --list coverage/lcov.info | grep -E "(0|low)"
```

## 🐛 Отладка проблемных тестов

```bash
# Запуск одного теста с максимальной детализацией
flutter test test/path/to/failing_test.dart --verbose --reporter=expanded

# Запуск теста с паузой для подключения отладчика
flutter test test/path/to/failing_test.dart --start-paused

# Проверка зависимостей теста
flutter pub deps

# Очистка и пересборка
flutter clean && flutter pub get && dart run build_runner build
```

## 📱 Тестирование на разных платформах

```bash
# Тесты для конкретной платформы (если поддерживается)
flutter test --platform=vm
flutter test --platform=chrome

# Проверка кроссплатформенности
flutter test --concurrency=1  # Последовательно для стабильности
```

## 🎯 Быстрые проверки

```bash
# Проверка что тесты не падают
flutter test --reporter=compact | grep -E "(PASSED|FAILED|ERROR)"

# Подсчет количества тестов
find test/ -name "*_test.dart" -exec grep -l "testWidgets\|test(" {} \; | wc -l

# Поиск тестов без группировки
grep -r "testWidgets\|test(" test/ | grep -v "group("

# Поиск медленных тестов (>5 секунд)
flutter test --reporter=json | jq '.[] | select(.time > 5000)'
```

---

## 📚 Документация
- [Детальная стратегия тестирования](docs/architecture/testing_strategy.md)
- [Быстрый старт](docs/guides/testing_quickstart.md)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)

## 🆘 Помощь
При проблемах с тестами:
1. Проверьте, что все зависимости установлены: `flutter pub get`
2. Перегенерируйте код: `dart run build_runner build --delete-conflicting-outputs`
3. Очистите кэш: `flutter clean && dart test/run_all_tests.dart --clean`
4. Обратитесь к команде разработки

**Цель проекта**: 80%+ покрытие кода тестами ✅