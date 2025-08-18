# Part Catalog

Flutter‑приложение для управления клиентами, автомобилями, заказ‑нарядами и поиском запчастей. Стек: Flutter, Riverpod, Drift, GoRouter, slang, Dio.

## Быстрый старт
- Установите Flutter (stable) и выполните: `flutter pub get`.
- Запуск (web): `flutter run -d chrome`
- Запуск (desktop): `flutter run -d windows|macos|linux`

## Основные команды
- Анализ: `flutter analyze`
- Форматирование: `dart format .`
- Организация импортов: `dart run scripts/organize_imports.dart lib`
- Генерация кода: `dart run build_runner build --delete-conflicting-outputs`
- Тесты: `flutter test` (покрытие: `flutter test --coverage`)

## Структура проекта
- Код: `lib/` (feature‑first: `lib/features/<feature>/`, общее: `lib/core`, `lib/models`)
- Тесты: `test/unit`, `test/widgets`, `test/integration`
- Ресурсы: `assets/` (объявлены в `pubspec.yaml`)

## Стили и линты
- Правила в `analysis_options.yaml` (+ `flutter_lints`). Используйте 2 пробела, trailing commas, `final`/`const` где возможно, абсолютные импорты из `lib/`.

## CI
GitHub Actions запускает форматирование, анализ, генерацию и тесты с покрытием (см. `.github/workflows/flutter_ci.yml`).

## Вклад и гайды
См. AGENTS.md — короткие правила по структуре, командам, стилю, тестам и PR.

Лицензия: MIT (см. LICENSE).
