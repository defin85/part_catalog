import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/utils/file_logger.dart';

import 'app_log_store.dart';
import 'in_memory_log_output.dart';

/// Глобальный, сконфигурированный logger, который пишет и в файл, и в память.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: MultiOutput([
      // В консоль/Debug
      ConsoleOutput(),
      // Во внешний файл (через уже существующий адаптер)
      NamedFileLogOutput('app_logs.log'),
      // В память для экрана журнала
      InMemoryLogOutput(appLogStore),
    ]),
  );

  static Logger get instance => _logger;

  /// Перехватывает debugPrint, чтобы он тоже попадал в журнал.
  static void hookDebugPrint() {
    final original = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) {
        _logger.d(message);
      }
      // Дублируем в оригинальный вывод, чтобы не потерять логи IDE
      original(message, wrapWidth: wrapWidth);
    };
  }
}

/// Удобный короткий аксессор
Logger get appLogger => AppLogger.instance;
