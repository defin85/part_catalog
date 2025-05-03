import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // Импортируем для kReleaseMode

class AppLoggers {
  // Определяем уровень по умолчанию в зависимости от режима сборки
  static final _defaultLevel = kReleaseMode ? Level.warning : Level.trace;

  static final Logger coreLogger = Logger(
      printer: PrettyPrinter(methodCount: 2),
      level: _defaultLevel // Используем уровень по умолчанию
      );
  static final Logger networkLogger = Logger(
      printer: PrettyPrinter(methodCount: 1),
      level: kReleaseMode ? Level.warning : Level.info // Пример разного уровня
      );
  static final Logger databaseLogger = Logger(
      printer: PrettyPrinter(methodCount: 1),
      level: kReleaseMode ? Level.warning : Level.debug // Пример разного уровня
      );
  static final Logger uiLogger =
      Logger(printer: PrettyPrinter(methodCount: 0), level: Level.warning);

  // Логгеры для конкретных компонентов
  static Logger clientsLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
      level: _defaultLevel // Используем уровень по умолчанию
      );
  static Logger vehiclesLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
      level: _defaultLevel // Используем уровень по умолчанию
      );
  static Logger suppliersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
      level: _defaultLevel // Используем уровень по умолчанию
      );
  static Logger ordersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
      level: _defaultLevel // Используем уровень по умолчанию
      );

  // Можно добавить специальный логгер для отправки ошибок в Crashlytics в релизе
  // static Logger crashlyticsLogger = Logger(
  //   output: kReleaseMode ? CrashlyticsOutput() : ConsoleOutput(),
  //   level: Level.warning,
  // );
}

// Пример кастомного вывода для Crashlytics (нужно реализовать)
// class CrashlyticsOutput extends LogOutput {
//   @override
//   void output(OutputEvent event) {
//     if (event.level.index >= Level.warning.index) {
//       FirebaseCrashlytics.instance.log(event.lines.join('\n'));
//       if (event.level.index >= Level.error.index && event.origin.error != null) {
//         FirebaseCrashlytics.instance.recordError(
//           event.origin.error,
//           event.origin.stackTrace,
//           reason: event.lines.join('\n'),
//         );
//       }
//     }
//   }
// }
