import 'package:logger/logger.dart';

class AppLoggers {
  static final Logger coreLogger =
      Logger(printer: PrettyPrinter(methodCount: 2), level: Level.trace);
  static final Logger networkLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.info);
  static final Logger databaseLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.debug);
  static final Logger uiLogger =
      Logger(printer: PrettyPrinter(methodCount: 0), level: Level.warning);

  // Логгеры для конкретных компонентов
  static Logger clientsLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger vehiclesLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger suppliersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
}
