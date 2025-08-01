import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/utils/context_logger.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_providers.g.dart';

/// Провайдер для получения базового логгера по категории
@riverpod
Logger categoryLogger(Ref ref, String category) {
  switch (category.toLowerCase()) {
    case 'core':
      return AppLoggers.core;
    case 'network':
      return AppLoggers.network;
    case 'database':
      return AppLoggers.database;
    case 'ui':
      return AppLoggers.ui;
    case 'clients':
      return AppLoggers.clients;
    case 'vehicles':
      return AppLoggers.vehicles;
    case 'suppliers':
      return AppLoggers.suppliers;
    case 'orders':
      return AppLoggers.orders;
    default:
      return appLogger(category);
  }
}

/// Провайдер для контекстного логгера
@riverpod
ContextLogger contextLogger(Ref ref, String context, {
  Map<String, dynamic>? metadata,
}) {
  // Получаем базовый логгер для контекста
  final baseLogger = ref.watch(categoryLoggerProvider(context.split('.').first));
  
  return ContextLogger(
    context: context,
    logger: baseLogger,
    metadata: metadata,
  );
}

/// Провайдер для логгера класса
@riverpod
ContextLogger classLogger(Ref ref, Type classType, {
  Map<String, dynamic>? metadata,
}) {
  return ref.watch(contextLoggerProvider(
    classType.toString(),
    metadata: metadata,
  ));
}

/// Синглтон для управления глобальными настройками логирования
@Riverpod(keepAlive: true)
class LoggingConfiguration extends _$LoggingConfiguration {
  @override
  LoggingConfig build() {
    return LoggingConfig(
      level: Level.debug,
      enableColors: true,
      enableEmojis: true,
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 100,
    );
  }

  void updateLevel(Level level) {
    state = state.copyWith(level: level);
    _updateAllLoggers();
  }

  void updateConfig(LoggingConfig config) {
    state = config;
    _updateAllLoggers();
  }

  void _updateAllLoggers() {
    // Обновляем уровень для всех логгеров
    Logger.level = state.level;
  }
}

/// Конфигурация логирования
class LoggingConfig {
  final Level level;
  final bool enableColors;
  final bool enableEmojis;
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;

  const LoggingConfig({
    required this.level,
    required this.enableColors,
    required this.enableEmojis,
    required this.methodCount,
    required this.errorMethodCount,
    required this.lineLength,
  });

  LoggingConfig copyWith({
    Level? level,
    bool? enableColors,
    bool? enableEmojis,
    int? methodCount,
    int? errorMethodCount,
    int? lineLength,
  }) {
    return LoggingConfig(
      level: level ?? this.level,
      enableColors: enableColors ?? this.enableColors,
      enableEmojis: enableEmojis ?? this.enableEmojis,
      methodCount: methodCount ?? this.methodCount,
      errorMethodCount: errorMethodCount ?? this.errorMethodCount,
      lineLength: lineLength ?? this.lineLength,
    );
  }
}

/// Extension для удобного доступа к логгерам через Ref
extension LoggerRefExtension on Ref {
  /// Получает контекстный логгер для текущего провайдера
  ContextLogger get logger {
    // Пытаемся определить контекст из стека вызовов
    final stackTrace = StackTrace.current.toString();
    final lines = stackTrace.split('\n');
    
    // Ищем имя провайдера в стеке
    String context = 'Unknown';
    for (final line in lines) {
      if (line.contains('Provider') && !line.contains('LoggerRefExtension')) {
        final match = RegExp(r'(\w+Provider)').firstMatch(line);
        if (match != null) {
          context = match.group(1)!;
          break;
        }
      }
    }
    
    return watch(contextLoggerProvider(context));
  }

  /// Получает логгер для конкретной категории
  Logger categoryLog(String category) {
    return watch(categoryLoggerProvider(category));
  }

  /// Получает контекстный логгер с метаданными
  ContextLogger contextLog(String context, [Map<String, dynamic>? metadata]) {
    return watch(contextLoggerProvider(context, metadata: metadata));
  }
}