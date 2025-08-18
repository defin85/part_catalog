import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/extensions/logger_extensions.dart';
import 'package:part_catalog/core/providers/logger_providers.dart';
import 'package:part_catalog/core/utils/context_logger.dart';
import 'package:part_catalog/core/utils/logger_config.dart';

// ignore_for_file: unused_local_variable, avoid_print


/// Примеры использования оптимизированной системы логирования
class LoggingExamples {
  /// 1. Базовое использование Logger с extension методами
  void basicLoggingExample() {
    final logger = AppLoggers.orders;

    // Использование extension методов
    logger.logInfo('Заказ создан', error: null, stackTrace: null);
    logger.logWarning('Низкий остаток товара');
    logger.logError('Ошибка при сохранении заказа',
        error: Exception('DB Error'));

    // Логирование с замером времени
    logger.logTimed('Загрузка заказов', () async {
      await Future.delayed(const Duration(seconds: 1));
      return ['Order1', 'Order2'];
    });

    // Структурированное логирование
    logger.logStructured(
      Level.info,
      'Заказ обработан',
      metadata: {
        'orderId': '12345',
        'amount': 1500.00,
        'currency': 'RUB',
      },
    );
  }

  /// 2. Использование ContextLogger для структурированного логирования
  void contextLoggingExample() {
    // Создание логгера с контекстом
    final serviceLogger = ContextLogger(
      context: 'OrderService',
      metadata: {'version': '1.0.0'},
    );

    // Добавление метаданных
    serviceLogger.addMetadata({
      'userId': 'user123',
      'sessionId': 'session456',
    });

    // Логирование с контекстом
    serviceLogger.i('Начало обработки заказа');

    // Создание дочернего логгера для метода
    final methodLogger = serviceLogger.child('createOrder', {
      'orderId': 'order789',
    });

    methodLogger.d('Валидация данных заказа');
    methodLogger.i('Заказ успешно создан');

    // Логирование с замером времени
    methodLogger.timed('Сохранение в БД', () async {
      await Future.delayed(const Duration(milliseconds: 500));
    });
  }

  /// 3. Использование в классе с миксином
  void mixinExample() {
    final service = OrderServiceWithLogging();
    service.processOrder('order123');
  }

  /// 4. Использование через Riverpod провайдеры
  void riverpodLoggingExample(Ref ref) {
    // Получение логгера через провайдер
    final logger = ref.watch(categoryLoggerProvider('orders'));
    logger.i('Обработка заказа через провайдер');

    // Получение контекстного логгера
    final contextLogger = ref.watch(contextLoggerProvider(
      'OrderProcessor',
      metadata: {'module': 'orders'},
    ));

    contextLogger.i('Начало обработки');

    // Использование extension для Ref
    ref.logger.i('Логирование через extension');
    ref.contextLog('OrderValidator').d('Валидация заказа');
  }

  /// 5. Централизованная настройка логирования
  void configurationExample(Ref ref) {
    // Изменение уровня логирования глобально
    ref.read(loggingConfigurationProvider.notifier).updateLevel(Level.warning);

    // Обновление конфигурации
    ref.read(loggingConfigurationProvider.notifier).updateConfig(
          const LoggingConfig(
            level: Level.debug,
            enableColors: true,
            enableEmojis: false,
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
          ),
        );
  }

  /// 6. Продвинутые сценарии использования
  void advancedExample() {
    final logger = ContextLogger(
      context: 'PaymentProcessor',
      metadata: {'service': 'stripe'},
    );

    // Логирование исключений с автоматическим определением уровня
    try {
      throw ArgumentError('Invalid payment amount');
    } catch (e, s) {
      logger.exception(e, s, {'amount': -100});
    }

    // Использование фабрики для получения кешированных логгеров
    final cachedLogger = ContextLoggerFactory.forClass(OrderServiceWithLogging);
    cachedLogger.i('Использование кешированного логгера');

    // Логирование для модуля
    final moduleLogger = ContextLoggerFactory.forModule('payments');
    moduleLogger.w('Превышен лимит попыток оплаты');
  }
}

/// Пример класса с использованием ContextLoggerMixin
class OrderServiceWithLogging with ContextLoggerMixin {
  void processOrder(String orderId) {
    // Автоматически создается logger с контекстом 'OrderServiceWithLogging'
    logger.i('Начало обработки заказа', metadata: {'orderId': orderId});

    // Создание логгера для метода
    final methodLog = methodLogger('processOrder', {'orderId': orderId});

    methodLog.d('Проверка наличия товара');
    methodLog.i('Расчет стоимости доставки');

    // Симуляция ошибки
    try {
      throw Exception('Недостаточно средств');
    } catch (e, s) {
      methodLog.e('Ошибка при обработке платежа', error: e, stackTrace: s);
    }

    logger.i('Завершение обработки заказа');
  }
}

/// Пример интеграции с существующими сервисами
class EnhancedClientService {
  final ContextLogger _logger;

  EnhancedClientService()
      : _logger = ContextLogger(
          context: 'ClientService',
          logger: AppLoggers.clients,
        );

  Future<void> updateClient(String clientId, Map<String, dynamic> data) async {
    final operationLogger = _logger.child('updateClient', {
      'clientId': clientId,
    });

    operationLogger.i('Начало обновления клиента');

    await operationLogger.timed('Валидация данных', () async {
      // Валидация
      await Future.delayed(const Duration(milliseconds: 100));
    });

    await operationLogger.timed('Сохранение в БД', () async {
      // Сохранение
      await Future.delayed(const Duration(milliseconds: 200));
    }, metadata: {
      'fields': data.keys.toList(),
    });

    operationLogger.i('Клиент успешно обновлен');
  }
}