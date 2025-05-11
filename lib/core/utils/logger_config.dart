import 'package:flutter/foundation.dart'; // Импортируем для kReleaseMode
import 'package:logger/logger.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart'; // Раскомментируйте, если используете Crashlytics

// Определяем уровень по умолчанию в зависимости от режима сборки
final _defaultLogLevel = kReleaseMode ? Level.warning : Level.trace;

// Базовый принтер для консистентности
PrettyPrinter _createPrettyPrinter({
  int methodCount = 1,
  int errorMethodCount = 5,
  int lineLength = 100,
  bool colors = true,
  bool printEmojis = true,
  bool printTime = true, // Включаем время по умолчанию
  DateTimeFormatter dateTimeFormat =
      DateTimeFormat.dateAndTime, // Формат времени
}) {
  return PrettyPrinter(
    methodCount: methodCount,
    errorMethodCount: errorMethodCount,
    lineLength: lineLength,
    colors: colors,
    printEmojis: printEmojis,
    printTime: printTime,
    dateTimeFormat: dateTimeFormat,
    // Можно добавить кастомные цвета и эмодзи, если нужно
  );
}

/// Функция для создания именованного логгера для компонента.
///
/// Пример использования:
/// final _logger = AppLogger('MyClassName');
/// _logger.d('Debug message');
Logger appLogger(String componentName) {
  return Logger(
    printer: _createPrettyPrinter(
        methodCount: 1), // Настройте methodCount по необходимости
    level: _defaultLogLevel,
    // Можно добавить фильтр или вывод, если это глобально для всех компонентных логгеров
    // filter: DevelopmentFilter(),
    // output: MultiOutput([ConsoleOutput(), CrashlyticsOutput()]), // Пример
  );
}

/// Класс для предоставления статических логгеров для общих категорий.
/// Эти логгеры могут быть полезны для логирования событий, не привязанных
/// к конкретному классу, а к более широкой области приложения.
class AppLoggers {
  static final Logger core = Logger(
    printer: _createPrettyPrinter(
        methodCount: 2), // Больше методов для детального лога ядра
    level: _defaultLogLevel,
  );

  static final Logger network = Logger(
    printer: _createPrettyPrinter(methodCount: 1),
    level: kReleaseMode
        ? Level.info
        : Level.debug, // Сеть может быть более многословной в debug
  );

  static final Logger database = Logger(
    printer: _createPrettyPrinter(methodCount: 1),
    level: kReleaseMode ? Level.warning : Level.debug,
  );

  static final Logger ui = Logger(
    printer:
        _createPrettyPrinter(methodCount: 0), // Меньше деталей для UI логов
    level: Level.info, // UI логи обычно менее детальны
  );

  // Логгеры для конкретных модулей/фич, если они нужны как статические
  // В большинстве случаев лучше использовать AppLogger('FeatureNameService')
  static final Logger clients = Logger(
    printer: _createPrettyPrinter(
        methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    level: _defaultLogLevel,
  );

  static final Logger vehicles = Logger(
    printer: _createPrettyPrinter(
        methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    level: _defaultLogLevel,
  );

  static final Logger suppliers = Logger(
    printer: _createPrettyPrinter(
        methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    level: _defaultLogLevel,
  );

  static final Logger orders = Logger(
    printer: _createPrettyPrinter(
        methodCount: 1, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
    level: _defaultLogLevel,
  );

  // Логгер для отправки ошибок в Crashlytics (или другую систему мониторинга)
  // static final Logger crashReporter = Logger(
  //   output: kReleaseMode ? CrashlyticsOutput() : null, // Отправляем только в релизе
  //   // filter: ProductionFilter(), // Можно использовать ProductionFilter, чтобы не дублировать в консоль в релизе, если ConsoleOutput уже есть
  //   level: Level.warning, // Отправляем только предупреждения и выше
  //   printer: _createPrettyPrinter(printTime: true, errorMethodCount: 8), // Больше деталей для ошибок
  // );
}

// Пример кастомного вывода для Crashlytics (нужно реализовать или использовать готовый пакет)
// class CrashlyticsOutput extends LogOutput {
//   @override
//   void output(OutputEvent event) {
//     if (event.level.index >= Level.warning.index) { // Отправляем warning и выше
//       try {
//         final message = event.lines.join('\n');
//         FirebaseCrashlytics.instance.log(message);

//         if (event.origin.error != null) {
//           FirebaseCrashlytics.instance.recordError(
//             event.origin.error,
//             event.origin.stackTrace,
//             reason: 'LOG: $message', // Добавляем сообщение лога как причину
//             fatal: event.level == Level.fatal, // Помечаем как фатальную, если уровень fatal
//           );
//         }
//       } catch (e) {
//         // ignore: avoid_print
//         print('Error sending log to Crashlytics: $e');
//       }
//     }
//   }
// }
