import 'package:logger/logger.dart';

/// Создает настроенный логгер для указанного компонента
Logger setupLogger(String component) {
  return Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      levelColors: {
        Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
        Level.debug: AnsiColor.fg(12), // Светло-синий
        Level.info: AnsiColor.fg(10), // Светло-зеленый
        Level.warning: AnsiColor.fg(208), // Оранжевый
        Level.error: AnsiColor.fg(196), // Красный
        Level.fatal: AnsiColor.fg(199), // Ярко-розовый
      },
    ),
    level: Level.info,
    filter: ProductionFilter(),
    output: ConsoleOutput(),
  )..i('Инициализирован логгер для компонента: $component');
}

/// Настройка глобального уровня логирования
void setLogLevel(Level level) {
  Logger.level = level;
}

/// Класс для группировки уровней логирования AST анализатора
class AstLoggers {
  static final Logger main = setupLogger('AST.Main');
  static final Logger collector = setupLogger('AST.Collector');
  static final Logger analyzer = setupLogger('AST.Analyzer');
  static final Logger reporting = setupLogger('AST.Reporting');
  static final Logger fileSystem = setupLogger('AST.FileSystem');
}
