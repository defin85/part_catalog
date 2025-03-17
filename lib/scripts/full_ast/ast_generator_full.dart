import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'analyzers/code_analyzer.dart';
import 'analyzers/dependency_analyzer.dart';
import 'analyzers/metrics_analyzer.dart';
import 'models/ast_node.dart';
import 'utils/file_utils.dart';
import 'utils/logger.dart';

// Объявление логгера как глобальной переменной
late Logger _logger;

/// Точка входа в программу анализа AST
void main(List<String> args) async {
  try {
    // Обработка аргументов командной строки
    final config = _parseArguments(args);

    // Настройка логгера
    _logger = setupLogger(
      'MainAnalyzer',
      level: config.logLevel,
      logFilePath: config.logFilePath,
    );

    _logger.i('Начало анализа проекта: ${config.targetPath}');

    // Получение списка файлов для анализа
    final files = await FileUtils.getDartFiles(Directory(config.targetPath));
    _logger.i('Найдено ${files.length} Dart файлов для анализа');

    // Инициализация анализаторов
    final codeAnalyzer = CodeAnalyzer();
    final dependencyAnalyzer = DependencyAnalyzer();
    final metricsAnalyzer = MetricsAnalyzer();

    // Создание корневого узла AST
    final rootNode = ProjectNode(
      path: config.targetPath,
      name: path.basename(config.targetPath),
    );

    // Анализ всех файлов
    for (final file in files) {
      _logger.d('Анализ файла: ${file.path}');

      try {
        // Чтение содержимого файла
        final content = await file.readAsString();

        // Разбор файла в AST
        final parseResult = parseString(
          content: content,
          featureSet: FeatureSet.latestLanguageVersion(),
          throwIfDiagnostics: false,
        );

        // Анализ кода
        final fileNode = await codeAnalyzer.analyzeFile(file, parseResult);

        // Анализ зависимостей
        await dependencyAnalyzer.analyzeFile(fileNode, parseResult);

        // Анализ метрик
        await metricsAnalyzer.analyzeFile(fileNode, parseResult);

        // Добавление результата анализа в общее дерево
        _addFileNodeToTree(rootNode, fileNode);
      } catch (e, stackTrace) {
        _logger.e('Ошибка при анализе файла ${file.path}',
            error: e, stackTrace: stackTrace);
      }
    }

    // Сохранение результатов анализа
    await _saveResults(rootNode, config);

    // Генерация отчетов
    if (config.generateReports) {
      await _generateReports(rootNode, config);
    }

    _logger.i('Анализ успешно завершен');
  } catch (e, stackTrace) {
    _logger.e('Ошибка при выполнении анализа',
        error: e, stackTrace: stackTrace);
    exit(1);
  }
}

/// Конфигурация программы анализа
class AnalyzerConfig {
  /// Путь к анализируемому проекту
  final String targetPath;

  /// Путь для сохранения результата
  final String outputPath;

  /// Генерировать ли отчеты
  final bool generateReports;

  /// Уровень логирования
  final Level logLevel;

  /// Путь к файлу логов (null - если логи только в консоль)
  final String? logFilePath;

  const AnalyzerConfig({
    required this.targetPath,
    required this.outputPath,
    this.generateReports = true,
    this.logLevel = Level.info,
    this.logFilePath,
  });
}

/// Обработка аргументов командной строки
AnalyzerConfig _parseArguments(List<String> args) {
  String targetPath = 'lib';
  String outputPath = '.github/detailed_project_ast.json';
  bool generateReports = true;
  Level logLevel = Level.info;
  String? logFilePath;

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--target':
      case '-t':
        if (i + 1 < args.length) {
          targetPath = args[++i];
        }
        break;
      case '--output':
      case '-o':
        if (i + 1 < args.length) {
          outputPath = args[++i];
        }
        break;
      case '--no-reports':
        generateReports = false;
        break;
      case '--verbose':
        logLevel = Level.debug;
        break;
      case '--quiet':
        logLevel = Level.warning;
        break;
      case '--log-file':
      case '-l':
        if (i + 1 < args.length) {
          logFilePath = args[++i];
        }
        break;
    }
  }

  return AnalyzerConfig(
    targetPath: targetPath,
    outputPath: outputPath,
    generateReports: generateReports,
    logLevel: logLevel,
    logFilePath: logFilePath,
  );
}

extension ProjectNodeExtension on ProjectNode {
  ProjectNode addFile(FileNode file) {
    return copyWith(files: List<FileNode>.from(files)..add(file));
  }

  ProjectNode addOrUpdateDirectory(DirectoryNode dir) {
    final index =
        directories.indexWhere((d) => d.name == dir.name && d.path == dir.path);
    if (index >= 0) {
      final newDirs = List<DirectoryNode>.from(directories);
      newDirs[index] = dir;
      return copyWith(directories: newDirs);
    } else {
      return copyWith(
          directories: List<DirectoryNode>.from(directories)..add(dir));
    }
  }
}

extension DirectoryNodeExtension on DirectoryNode {
  DirectoryNode addFile(FileNode file) {
    return copyWith(files: List<FileNode>.from(files)..add(file));
  }

  DirectoryNode addOrUpdateDirectory(DirectoryNode dir) {
    final index =
        directories.indexWhere((d) => d.name == dir.name && d.path == dir.path);
    if (index >= 0) {
      final newDirs = List<DirectoryNode>.from(directories);
      newDirs[index] = dir;
      return copyWith(directories: newDirs);
    } else {
      return copyWith(
          directories: List<DirectoryNode>.from(directories)..add(dir));
    }
  }
}

/// Добавляет узел файла в дерево проекта
void _addFileNodeToTree(ProjectNode rootNode, FileNode fileNode) {
  final relativePath = path.relative(fileNode.path, from: rootNode.path);
  final pathSegments = path.split(relativePath);

  // Ничего не делаем, если путь пустой
  if (pathSegments.isEmpty ||
      (pathSegments.length == 1 && pathSegments[0].isEmpty)) {
    rootNode = rootNode.addFile(fileNode);
    return;
  }

  // Обработка иерархии директорий
  var currentPath = rootNode.path;
  dynamic currentNode = rootNode; // Изменили тип с ProjectNode на dynamic

  // Создаем цепочку директорий
  for (int i = 0; i < pathSegments.length - 1; i++) {
    final segment = pathSegments[i];
    if (segment.isEmpty) continue;

    currentPath = path.join(currentPath, segment);

    // Поиск или создание директории
    DirectoryNode? nextNode;
    if (currentNode is ProjectNode) {
      nextNode = currentNode.directories
          .firstWhereOrNull((dir) => dir.name == segment);
    } else if (currentNode is DirectoryNode) {
      nextNode = currentNode.directories
          .firstWhereOrNull((dir) => dir.name == segment);
    }

    if (nextNode == null) {
      nextNode = DirectoryNode(path: currentPath, name: segment);
      if (currentNode is ProjectNode) {
        currentNode = currentNode.addOrUpdateDirectory(nextNode);
      } else if (currentNode is DirectoryNode) {
        currentNode = currentNode.addOrUpdateDirectory(nextNode);
      }
    } else {
      currentNode = nextNode;
    }
  }

  // Добавляем файл в последнюю директорию
  if (pathSegments.last.isNotEmpty) {
    if (currentNode is ProjectNode) {
      currentNode = currentNode.addFile(fileNode);
    } else if (currentNode is DirectoryNode) {
      currentNode = currentNode.addFile(fileNode);
    }
  }
}

/// Сохранение результатов анализа
Future<void> _saveResults(ProjectNode rootNode, AnalyzerConfig config) async {
  _logger.i('Сохранение результатов анализа в ${config.outputPath}');

  // Подготовка директории для выходного файла
  final outputFile = File(config.outputPath);
  final outputDir = path.dirname(outputFile.path);
  if (!await Directory(outputDir).exists()) {
    await Directory(outputDir).create(recursive: true);
  }

  // Сериализация и сохранение результатов
  final jsonMap = rootNode.toJson();
  final jsonString = jsonEncode(jsonMap); // Преобразуем Map в строку JSON
  await outputFile.writeAsString(jsonString);

  _logger.i('Результаты успешно сохранены');
}

/// Генерация отчетов
Future<void> _generateReports(
    ProjectNode rootNode, AnalyzerConfig config) async {
  final reportsDir = path.join(path.dirname(config.outputPath), 'reports');

  _logger.i('Генерация отчетов в директории $reportsDir');

  // Создание директории для отчетов
  if (!await Directory(reportsDir).exists()) {
    await Directory(reportsDir).create(recursive: true);
  }

  // Генерация отчетов о зависимостях
  await _generateDependencyReport(
      rootNode, path.join(reportsDir, 'dependencies.md'));

  // Генерация отчетов о метриках
  await _generateMetricsReport(rootNode, path.join(reportsDir, 'metrics.md'));

  // Генерация отчета о структуре проекта
  await _generateStructureReport(
      rootNode, path.join(reportsDir, 'structure.md'));

  _logger.i('Отчеты успешно сгенерированы');
}

/// Генерация отчета о зависимостях
Future<void> _generateDependencyReport(
    ProjectNode rootNode, String outputPath) async {
  // Реализация генерации отчета о зависимостях
  _logger.d('Генерация отчета о зависимостях');
  final report = StringBuffer();

  report.writeln('# Отчет о зависимостях проекта');
  report.writeln('\nСгенерировано: ${DateTime.now()}');

  // TODO: Реализовать формирование отчета о зависимостях

  await File(outputPath).writeAsString(report.toString());
}

/// Генерация отчета о метриках кода
Future<void> _generateMetricsReport(
    ProjectNode rootNode, String outputPath) async {
  // Реализация генерации отчета о метриках
  _logger.d('Генерация отчета о метриках кода');
  final report = StringBuffer();

  report.writeln('# Отчет о метриках кода');
  report.writeln('\nСгенерировано: ${DateTime.now()}');

  // TODO: Реализовать формирование отчета о метриках

  await File(outputPath).writeAsString(report.toString());
}

/// Генерация отчета о структуре проекта
Future<void> _generateStructureReport(
    ProjectNode rootNode, String outputPath) async {
  // Реализация генерации отчета о структуре
  _logger.d('Генерация отчета о структуре проекта');
  final report = StringBuffer();

  report.writeln('# Структура проекта');
  report.writeln('\nСгенерировано: ${DateTime.now()}');

  // TODO: Реализовать формирование отчета о структуре

  await File(outputPath).writeAsString(report.toString());
}
