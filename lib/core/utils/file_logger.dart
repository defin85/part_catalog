import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Простой сервис для записи логов в файл.
class FileLogger {
  static String _defaultFileName = 'app_logs.log';
  static String? _baseDirPath; // Папка, куда писать логи
  static final Map<String, IOSink> _sinks = {};

  /// Инициализация директории для логов. Должна быть вызвана один раз при старте.
  static Future<void> init({String? defaultFileName}) async {
    if (defaultFileName != null) {
      _defaultFileName = defaultFileName;
    }

    if (kIsWeb) {
      // На web файловая система недоступна — оставляем как no-op
      _baseDirPath = null;
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      _baseDirPath = dir.path;
    } catch (_) {
      // Fallback: текущая директория процесса
      _baseDirPath = Directory.current.path;
    }

    // Гарантированно создаём файлы логов, чтобы их было легко найти
    try {
      _resolveFile(_defaultFileName).createSync(recursive: true);
      _resolveFile('parts_search.log').createSync(recursive: true);
    } catch (_) {}
  }

  static File _resolveFile([String? fileName]) {
    final name = fileName ?? _defaultFileName;
    final base = _baseDirPath ?? Directory.current.path;
    return File(p.join(base, name));
  }

  static IOSink _sinkFor(String fileName) {
    final key = fileName.isEmpty ? _defaultFileName : fileName;
    final existing = _sinks[key];
    if (existing != null) return existing;
    final sink = _resolveFile(key).openWrite(mode: FileMode.append);
    _sinks[key] = sink;
    return sink;
  }

  /// Записывает сообщение в лог-файл.
  ///
  /// Добавляет временную метку к каждой записи.
  static void write(String message) {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final sink = _sinkFor(_defaultFileName);
      sink.writeln('$timestamp: $message\n');
    } catch (e) {
      // В случае ошибки выводим в консоль, чтобы не потерять информацию
      // ignore: avoid_print
      print('FileLogger Error: $e');
    }
  }

  /// Запись в указанный файл (без изменения базового `_logFile`).
  static void writeTo(String fileName, String message) {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final sink = _sinkFor(fileName);
      sink.writeln('$timestamp: $message');
    } catch (e) {
      // ignore: avoid_print
      print('FileLogger Error(writeTo): $e');
    }
  }

  /// Очищает лог-файл.
  static void clear() {
    try {
      final file = _resolveFile();
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      // ignore: avoid_print
      print('FileLogger Error on clear: $e');
    }
  }

  /// Закрыть все открытые sink'и (например, при завершении приложения)
  static Future<void> dispose() async {
    for (final sink in _sinks.values) {
      await sink.flush();
      await sink.close();
    }
    _sinks.clear();
  }
}

/// LogOutput для `package:logger` с записью в именованный файл.
class NamedFileLogOutput extends LogOutput {
  final String fileName;
  NamedFileLogOutput(this.fileName);
  static const int _maxLine = 50000; // ограничим запись длинных строк

  @override
  void output(OutputEvent event) {
    // `event.lines` уже отформатированы принтером
    for (var line in event.lines) {
      if (line.length > _maxLine) {
        final cut = line.length - _maxLine;
        line = '${line.substring(0, _maxLine)} ... [truncated $cut chars]';
      }
      FileLogger.writeTo(fileName, line);
    }
  }
}
