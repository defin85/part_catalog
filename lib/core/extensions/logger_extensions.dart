import 'package:logger/logger.dart';

/// Extension методы для унификации логирования в проекте
extension EnhancedLoggerExtensions on Logger {
  /// Логирование отладочной информации
  void logDebug(String message, {dynamic error, StackTrace? stackTrace}) {
    d(message, error: error, stackTrace: stackTrace);
  }

  /// Логирование информационных сообщений
  void logInfo(String message, {dynamic error, StackTrace? stackTrace}) {
    i(message, error: error, stackTrace: stackTrace);
  }

  /// Логирование предупреждений
  void logWarning(String message, {dynamic error, StackTrace? stackTrace}) {
    w(message, error: error, stackTrace: stackTrace);
  }

  /// Логирование ошибок
  void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    e(message, error: error, stackTrace: stackTrace);
  }

  /// Логирование критических ошибок
  void logFatal(String message, {dynamic error, StackTrace? stackTrace}) {
    f(message, error: error, stackTrace: stackTrace);
  }

  /// Логирование с замером времени выполнения
  Future<T> logTimed<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      i('$operationName completed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (error, stackTrace) {
      stopwatch.stop();
      e('$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Логирование входа в метод
  void logMethodEntry(String methodName, [Map<String, dynamic>? parameters]) {
    final params = parameters?.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ') ?? '';
    d('→ $methodName($params)');
  }

  /// Логирование выхода из метода
  void logMethodExit(String methodName, [dynamic result]) {
    d('← $methodName${result != null ? ' = $result' : ''}');
  }

  /// Логирование изменения состояния
  void logStateChange(String stateName, dynamic oldValue, dynamic newValue) {
    i('State [$stateName] changed: $oldValue → $newValue');
  }

  /// Логирование событий пользовательского интерфейса
  void logUIEvent(String eventName, [Map<String, dynamic>? details]) {
    final detailsStr = details?.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ') ?? '';
    d('UI Event: $eventName${detailsStr.isNotEmpty ? ' [$detailsStr]' : ''}');
  }

  /// Логирование сетевых запросов
  void logNetworkRequest(String method, String url, [Map<String, dynamic>? headers]) {
    i('→ $method $url${headers != null ? '\nHeaders: $headers' : ''}');
  }

  /// Логирование сетевых ответов
  void logNetworkResponse(String method, String url, int statusCode, [dynamic body]) {
    final level = statusCode >= 400 ? Level.warning : Level.info;
    log(level, '← $method $url [$statusCode]${body != null ? '\nBody: $body' : ''}');
  }

  /// Логирование операций с базой данных
  void logDatabaseOperation(String operation, String table, [Map<String, dynamic>? data]) {
    d('DB: $operation on $table${data != null ? ' with data: $data' : ''}');
  }

  /// Логирование валидации
  void logValidation(String fieldName, bool isValid, [String? reason]) {
    if (isValid) {
      d('Validation passed for $fieldName');
    } else {
      w('Validation failed for $fieldName${reason != null ? ': $reason' : ''}');
    }
  }

  /// Логирование производительности
  void logPerformance(String metric, double value, String unit) {
    i('Performance: $metric = $value $unit');
  }

  /// Структурированное логирование с метаданными
  void logStructured(
    Level level,
    String message, {
    Map<String, dynamic>? metadata,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final metaStr = metadata?.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ') ?? '';
    log(
      level,
      '$message${metaStr.isNotEmpty ? '\nMetadata: {$metaStr}' : ''}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Extension для упрощения создания логгеров
extension LoggerFactory on Never {
  /// Создает логгер для класса
  static Logger forClass(Type type) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: DevelopmentFilter(),
    );
  }

  /// Создает логгер для функции
  static Logger forFunction(String functionName) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 100,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: DevelopmentFilter(),
    );
  }
}