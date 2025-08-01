# Руководство по системе логирования

## Обзор

Проект использует оптимизированную систему логирования на основе пакета `logger` с дополнительными расширениями и контекстным логированием.

## Основные компоненты

### 1. Logger Extensions (`logger_extensions.dart`)

Предоставляет удобные методы для унифицированного логирования:

```dart
logger.logInfo('Информационное сообщение');
logger.logWarning('Предупреждение');
logger.logError('Ошибка', error: exception, stackTrace: stack);
```

Дополнительные методы:
- `logTimed()` - логирование с замером времени
- `logMethodEntry()` / `logMethodExit()` - трассировка методов
- `logStateChange()` - логирование изменений состояния
- `logNetworkRequest()` / `logNetworkResponse()` - сетевые операции
- `logDatabaseOperation()` - операции с БД

### 2. Context Logger (`context_logger.dart`)

Структурированное логирование с контекстом и метаданными:

```dart
final logger = ContextLogger(
  context: 'OrderService',
  metadata: {'version': '1.0.0'},
);

logger.i('Обработка заказа', metadata: {'orderId': '12345'});
```

Возможности:
- Иерархический контекст через `child()`
- Персистентные метаданные
- Автоматическое форматирование сообщений
- Измерение производительности через `timed()`

### 3. Logger Providers (`logger_providers.dart`)

Интеграция с Riverpod для централизованного управления:

```dart
// В провайдере
final logger = ref.watch(contextLoggerProvider('MyService'));

// Через extension
ref.logger.i('Сообщение');
ref.contextLog('MyContext').d('Отладка');
```

## Настройка

### Глобальная конфигурация

```dart
ref.read(loggingConfigurationProvider.notifier).updateConfig(
  LoggingConfig(
    level: Level.debug,
    enableColors: true,
    enableEmojis: true,
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 100,
  ),
);
```

### Категории логгеров

Предопределенные категории в `AppLoggers`:
- `core` - основная функциональность
- `network` - сетевые операции
- `database` - работа с БД
- `ui` - пользовательский интерфейс
- `clients` - модуль клиентов
- `vehicles` - модуль автомобилей
- `suppliers` - модуль поставщиков
- `orders` - модуль заказов

## Примеры использования

### В сервисе

```dart
class ClientService {
  final _logger = AppLoggers.clients;
  
  Future<void> updateClient(String id) async {
    _logger.logMethodEntry('updateClient', {'id': id});
    
    try {
      await _logger.logTimed('Обновление клиента', () async {
        // логика обновления
      });
      
      _logger.logMethodExit('updateClient', true);
    } catch (e, s) {
      _logger.logError('Ошибка обновления', error: e, stackTrace: s);
      rethrow;
    }
  }
}
```

### С миксином

```dart
class OrderService with ContextLoggerMixin {
  void processOrder(String orderId) {
    logger.i('Обработка заказа', metadata: {'orderId': orderId});
    
    final methodLog = methodLogger('processOrder');
    methodLog.d('Валидация');
    // ...
  }
}
```

### В Riverpod провайдере

```dart
@riverpod
Future<List<Order>> orders(Ref ref) async {
  final logger = ref.contextLog('OrdersProvider');
  
  return logger.timed('Загрузка заказов', () async {
    final service = ref.watch(orderServiceProvider);
    return service.getOrders();
  });
}
```

## Лучшие практики

1. **Используйте правильный уровень**:
   - `debug` - детальная отладочная информация
   - `info` - важные события бизнес-логики
   - `warning` - потенциальные проблемы
   - `error` - ошибки, требующие внимания

2. **Добавляйте контекст**:
   - Используйте метаданные для структурированных данных
   - Создавайте дочерние логгеры для вложенных операций

3. **Измеряйте производительность**:
   - Используйте `timed()` для критичных операций
   - Логируйте метрики производительности

4. **Обрабатывайте ошибки**:
   - Всегда передавайте `error` и `stackTrace`
   - Используйте `exception()` для автоматического определения уровня

5. **Оптимизация**:
   - В production используйте `Level.warning` или выше
   - Отключайте цвета и эмодзи для логов в файлы

## Миграция существующего кода

### Было:
```dart
_logger.logWarning('Сообщение');
_logger.i('Информация');
```

### Стало:
```dart
// С extension методами
_logger.logWarning('Сообщение');
_logger.logInfo('Информация');

// С контекстным логгером
final logger = ContextLogger(context: 'MyService');
logger.w('Сообщение');
logger.i('Информация');
```

## Интеграция с внешними системами

Для отправки логов во внешние системы (Crashlytics, Sentry):

```dart
class RemoteLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (event.level.index >= Level.warning.index) {
      // Отправка во внешнюю систему
    }
  }
}
```

## Производительность

- Логгеры кешируются в `ContextLoggerFactory`
- Метаданные форматируются лениво
- В production автоматически отключаются debug логи

## Отладка

Для временного изменения уровня логирования:

```dart
// В debug консоли
Logger.level = Level.trace;

// Или через провайдер
ref.read(loggingConfigurationProvider.notifier).updateLevel(Level.trace);
```