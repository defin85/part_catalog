import 'package:logger/logger.dart';

import 'package:part_catalog/core/utils/logger_config.dart';

/// Логгер с поддержкой контекста для структурированного логирования
class ContextLogger {
  final Logger _logger;
  final String _context;
  final Map<String, dynamic> _persistentMetadata;

  ContextLogger({
    required String context,
    Logger? logger,
    Map<String, dynamic>? metadata,
  })  : _context = context,
        _logger = logger ?? AppLoggers.core,
        _persistentMetadata = metadata ?? {};

  /// Создает дочерний логгер с дополнительным контекстом
  ContextLogger child(String childContext,
      [Map<String, dynamic>? additionalMetadata]) {
    return ContextLogger(
      context: '$_context.$childContext',
      logger: _logger,
      metadata: {
        ..._persistentMetadata,
        ...?additionalMetadata,
      },
    );
  }

  /// Добавляет метаданные к текущему контексту
  void addMetadata(Map<String, dynamic> metadata) {
    _persistentMetadata.addAll(metadata);
  }

  /// Удаляет метаданные из контекста
  void removeMetadata(List<String> keys) {
    for (final key in keys) {
      _persistentMetadata.remove(key);
    }
  }

  /// Форматирует сообщение с контекстом
  String _formatMessage(String message, [Map<String, dynamic>? metadata]) {
    final allMetadata = {
      ..._persistentMetadata,
      ...?metadata,
    };

    final metaStr = allMetadata.isNotEmpty
        ? ' [${allMetadata.entries.map((e) => '${e.key}: ${e.value}').join(', ')}]'
        : '';

    return '[$_context] $message$metaStr';
  }

  // Методы логирования
  void d(String message,
      {Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.d(_formatMessage(message, metadata),
        error: error, stackTrace: stackTrace);
  }

  void i(String message,
      {Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.i(_formatMessage(message, metadata),
        error: error, stackTrace: stackTrace);
  }

  void w(String message,
      {Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.w(_formatMessage(message, metadata),
        error: error, stackTrace: stackTrace);
  }

  void e(String message,
      {Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.e(_formatMessage(message, metadata),
        error: error, stackTrace: stackTrace);
  }

  void f(String message,
      {Map<String, dynamic>? metadata, dynamic error, StackTrace? stackTrace}) {
    _logger.f(_formatMessage(message, metadata),
        error: error, stackTrace: stackTrace);
  }

  /// Логирование операции с измерением времени
  Future<T> timed<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    final operationId = DateTime.now().millisecondsSinceEpoch;

    i('Starting $operationName', metadata: {
      ...?metadata,
      'operationId': operationId,
    });

    try {
      final result = await operation();
      stopwatch.stop();

      i('Completed $operationName', metadata: {
        ...?metadata,
        'operationId': operationId,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });

      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();

      e(
        'Failed $operationName',
        metadata: {
          ...?metadata,
          'operationId': operationId,
          'duration': '${stopwatch.elapsedMilliseconds}ms',
        },
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  /// Логирование с автоматическим определением уровня по типу исключения
  void exception(dynamic exception, StackTrace? stackTrace,
      [Map<String, dynamic>? metadata]) {
    final level = _getLogLevelForException(exception);

    switch (level) {
      case Level.debug:
        d('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
        break;
      case Level.info:
        i('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
        break;
      case Level.warning:
        w('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
        break;
      case Level.error:
        e('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
        break;
      case Level.fatal:
        f('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
        break;
      default:
        e('Exception occurred',
            metadata: metadata, error: exception, stackTrace: stackTrace);
    }
  }

  Level _getLogLevelForException(dynamic exception) {
    // Можно настроить маппинг типов исключений на уровни логирования
    if (exception is AssertionError) return Level.fatal;
    if (exception is StateError) return Level.error;
    if (exception is ArgumentError) return Level.warning;
    if (exception is FormatException) return Level.warning;

    return Level.error;
  }
}

/// Миксин для добавления контекстного логгера в классы
mixin ContextLoggerMixin {
  late final ContextLogger logger = ContextLogger(
    context: runtimeType.toString(),
  );

  /// Создает логгер для метода
  ContextLogger methodLogger(String methodName,
      [Map<String, dynamic>? metadata]) {
    return logger.child(methodName, metadata);
  }
}

/// Фабрика для создания контекстных логгеров
class ContextLoggerFactory {
  static final Map<String, ContextLogger> _loggers = {};

  /// Получает или создает логгер для контекста
  static ContextLogger getLogger(
    String context, {
    Logger? baseLogger,
    Map<String, dynamic>? metadata,
  }) {
    return _loggers.putIfAbsent(
      context,
      () => ContextLogger(
        context: context,
        logger: baseLogger,
        metadata: metadata,
      ),
    );
  }

  /// Создает логгер для класса
  static ContextLogger forClass(Type type, [Map<String, dynamic>? metadata]) {
    return getLogger(type.toString(), metadata: metadata);
  }

  /// Создает логгер для модуля
  static ContextLogger forModule(String moduleName,
      [Map<String, dynamic>? metadata]) {
    return getLogger(moduleName, metadata: metadata);
  }

  /// Очищает кеш логгеров
  static void clearCache() {
    _loggers.clear();
  }
}
