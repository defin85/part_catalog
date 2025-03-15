import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import 'analyzers/code_analyzer.dart';
import 'analyzers/dependency_analyzer.dart';
import 'analyzers/metrics_analyzer.dart';
import 'models/ast_node.dart';
import 'utils/file_utils.dart';
import 'utils/logger.dart';

/// Логгер для основного модуля
final _logger = setupLogger('MainAnalyzer');

/// Точка входа в программу анализа AST
void main(List<String> args) async {
  try {
    // Обработка аргументов командной строки
    final config = _parseArguments(args);

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

  const AnalyzerConfig({
    required this.targetPath,
    required this.outputPath,
    this.generateReports = true,
    this.logLevel = Level.info,
  });
}

/// Обработка аргументов командной строки
AnalyzerConfig _parseArguments(List<String> args) {
  String targetPath = 'lib';
  String outputPath = '.github/detailed_project_ast.json';
  bool generateReports = true;
  Level logLevel = Level.info;

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
    }
  }

  return AnalyzerConfig(
    targetPath: targetPath,
    outputPath: outputPath,
    generateReports: generateReports,
    logLevel: logLevel,
  );
}

/// Добавляет узел файла в дерево проекта
void _addFileNodeToTree(ProjectNode rootNode, FileNode fileNode) {
  final relativePath = path.relative(fileNode.path, from: rootNode.path);
  final pathSegments = path.split(relativePath);

  DirectoryNode currentNode = rootNode;

  // Создаем цепочку директорий
  for (int i = 0; i < pathSegments.length - 1; i++) {
    final segment = pathSegments[i];

    // Поиск существующего узла директории
    DirectoryNode? nextNode = currentNode.directories
        .cast<DirectoryNode?>()
        .firstWhere((node) => node!.name == segment, orElse: () => null);

    // Создание нового узла, если он не существует
    if (nextNode == null) {
      nextNode = DirectoryNode(
        path: path.join(currentNode.path, segment),
        name: segment,
      );
      currentNode.directories.add(nextNode);
    }

    currentNode = nextNode;
  }

  // Добавляем файл в последнюю директорию
  currentNode.files.add(fileNode);
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
  final jsonData = rootNode.toJson();
  await outputFile.writeAsString(jsonData);

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
