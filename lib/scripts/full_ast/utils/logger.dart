import 'dart:io';
import 'package:logger/logger.dart';

/// Настраивает и возвращает логгер с указанным именем
Logger setupLogger(String name, {String? logFilePath, Level? level}) {
  final outputs = <LogOutput>[ConsoleOutput()];

  // Если указан путь к файлу логов, добавляем вывод в файл
  if (logFilePath != null) {
    final logFile = File(logFilePath);
    // Создаем директорию для файла логов, если она не существует
    if (!logFile.parent.existsSync()) {
      logFile.parent.createSync(recursive: true);
    }
    outputs.add(FileOutput(file: logFile));
  }

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
    level: level ??
        Level.info, // Используем переданный уровень или Level.info по умолчанию
    filter: ProductionFilter(),
    output: MultiOutput(outputs), // Используем подготовленный список выводов
  );
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

/// Класс для вывода логов в файл
class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  IOSink? _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
  });

  @override
  Future<void> init() async {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
    );
  }

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      _sink?.writeln(line);
    }
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
  }
}
