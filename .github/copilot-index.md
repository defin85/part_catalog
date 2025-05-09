# Part Catalog - Индекс для GitHub Copilot

> Этот индексный файл содержит ключевую информацию о проекте Part Catalog для улучшения контекстного понимания GitHub Copilot при генерации кода. Здесь определены основные концепции, архитектурные паттерны и структура проекта.

## Общие инструкции

- **Форматирование вывода:** При генерации диаграмм (например, архитектурных схем), таблиц или структур каталогов, всегда заключайте их в HTML-тег `<pre>...</pre>` для сохранения форматирования.


## Ключевые концепции

- **ApiConnectionMode**: Режимы подключения к API поставщиков (direct/proxy/hybrid)
- **SupplierApiClient**: Базовый интерфейс для всех клиентов API поставщиков
- **Адаптивная архитектура API**: Подход к взаимодействию с API поставщиков через прямое подключение или прокси
- **Двухуровневая архитектура моделей**: Разделение на модели таблиц БД и бизнес-модели

## Архитектурные паттерны

- **Repository Pattern**: Для доступа к данным
- **Service Layer**: Для бизнес-логики
- **Factory Pattern**: Для создания клиентов API и других компонентов
- **Adapter Pattern**: Для работы с разными API поставщиков
- **Proxy Pattern**: Для организации взаимодействия через прокси-сервер

## Структура проекта
```
lib/
  features/
    suppliers/
      api/
        base_supplier_api_client.dart  # Общий интерфейс для клиента и сервера
        implementations/               # Общие реализации
          autodoc_api_client.dart
          exist_api_client.dart
          emex_api_client.dart
      models/                         # Общие модели данных
        base/
          part_price_response.dart
      repositories/                   # Общие репозитории
        supplier_repository.dart
  core/
    config/
      app_config.dart                 # Общая конфигурация
    utils/
      logger_config.dart              # Общее логирование
  client/                             # Код только для клиента
    client_service_locator.dart
    ui/
      screens/
        supplier_screen.dart
  server/                             # Код только для сервера
    proxy_server.dart
    server_service_locator.dart
    cache/
      redis_cache_manager.dart
```


## Связь между модулями

- **Клиенты → Автомобили**: Клиент владеет автомобилями (один-ко-многим)
- **Клиенты → Заказ-наряды**: Клиент связан с заказ-нарядами (один-ко-многим)
- **Автомобили → Заказ-наряды**: Автомобиль связан с заказ-нарядами (один-ко-многим)
- **Заказ-наряды → Поставщики**: Заказ-наряд использует API поставщиков

## Технологический стек

- **Frontend**: Flutter, Dart
- **Локальная БД**: Drift (SQLite) + Supabase для облачной синхронизации
- **Сетевые запросы**: Dio
- **Управление состоянием**: Provider
- **Внедрение зависимостей**: get_it
- **Сервер**: Dart (shelf)