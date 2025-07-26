# Унифицированная система конфигурации API поставщиков

## Обзор

Создана гибкая и расширяемая система для управления конфигурациями различных поставщиков запчастей. Система позволяет легко добавлять новых поставщиков и управлять их настройками через единый интерфейс.

## Архитектура

### 1. Модель конфигурации (`SupplierConfig`)

```dart
SupplierConfig
├── supplierCode         // Уникальный код (armtek, autotrade)
├── displayName          // Отображаемое название
├── isEnabled            // Статус активности
├── apiConfig            // Настройки API
│   ├── baseUrl          // Основной URL
│   ├── proxyUrl         // URL прокси (опционально)
│   ├── authType         // Тип аутентификации
│   ├── credentials      // Учетные данные
│   ├── timeout          // Таймаут запросов
│   ├── maxRetries       // Количество повторов
│   └── rateLimit        // Лимиты использования
└── businessConfig       // Бизнес-параметры
    ├── customerCode     // Код клиента
    ├── contractNumber   // Номер договора
    └── другие параметры // Специфичные для поставщика
```

### 2. Типы аутентификации

- **Basic Auth**: Логин/пароль (Armtek)
- **API Key**: Ключ API (Autotrade)
- **Bearer Token**: OAuth токены
- **Custom**: Кастомная аутентификация

### 3. Компоненты системы

1. **SupplierConfigService** - управление конфигурациями
2. **ApiClientFactory** - создание API клиентов
3. **Провайдеры Riverpod** - управление состоянием
4. **Интерсепторы Dio** - retry, rate limiting

## Примеры использования

### Создание конфигурации для Armtek

```dart
final armtekConfig = SupplierConfigFactories.createArmtekConfig(
  username: 'user@example.com',
  password: 'password123',
  vkorg: '1000',
  customerCode: 'CUST001',
  contractNumber: 'CONTRACT001',
  useProxy: false,
);
```

### Создание конфигурации для Autotrade

```dart
final autotradeConfig = SupplierConfigFactories.createAutotradeConfig(
  apiKey: 'your-api-key-here',
  customerCode: 'CUST001',
  useProxy: false,
);
```

### Сохранение конфигурации

```dart
// Через провайдер
await ref.read(supplierConfigsProvider.notifier).saveConfig(config);

// Через сервис напрямую
await supplierConfigService.saveConfig(config);
```

### Создание API клиента

```dart
final config = supplierConfigService.getConfig('armtek');
final client = ApiClientFactory.createClient(config, dio);
```

## Добавление нового поставщика

1. **Создать API клиент** в `lib/features/suppliers/api/implementations/`:
```dart
class NewSupplierApiClient implements BaseSupplierApiClient {
  // Реализация методов интерфейса
}
```

2. **Добавить в фабрику** `ApiClientFactory`:
```dart
case 'newsupplier':
  return _createNewSupplierClient(config, dio, baseUrl, useProxy);
```

3. **Создать фабричный метод** в `SupplierConfigFactories`:
```dart
static SupplierConfig createNewSupplierConfig({
  required String apiKey,
  // другие параметры
}) {
  return SupplierConfig(
    supplierCode: 'newsupplier',
    displayName: 'New Supplier',
    // ...
  );
}
```

4. **Добавить в enum** `SupplierCode`:
```dart
enum SupplierCode {
  armtek,
  autodoc,
  newsupplier, // Новый поставщик
}
```

## Особенности реализации

### Контроль лимитов API

Система автоматически отслеживает использование API:
- Дневные лимиты
- Часовые лимиты
- Статистика использования

### Повторные попытки

Автоматические повторные попытки при ошибках:
- Таймауты соединения
- Ошибки сервера (5xx)
- Настраиваемые задержки между попытками

### Безопасность

- Учетные данные хранятся в SharedPreferences
- При экспорте конфигураций пароли удаляются
- Поддержка прокси для дополнительной безопасности

### Валидация

Встроенная валидация конфигураций:
- Обязательные поля
- Специфичные требования поставщиков
- Проверка перед сохранением

## Преимущества системы

1. **Единообразие**: Все поставщики настраиваются одинаково
2. **Расширяемость**: Легко добавлять новых поставщиков
3. **Гибкость**: Поддержка различных типов аутентификации
4. **Безопасность**: Шифрование, прокси, контроль доступа
5. **Мониторинг**: Отслеживание использования и лимитов
6. **Надежность**: Повторные попытки, обработка ошибок

## Дальнейшие улучшения

1. **UI для настроек**: Создать экраны для управления конфигурациями
2. **Миграции**: Система миграций при изменении структуры конфигураций
3. **Облачная синхронизация**: Синхронизация настроек между устройствами
4. **Метрики**: Детальная статистика по каждому поставщику
5. **Автоматическое обновление токенов**: Для OAuth2 провайдеров