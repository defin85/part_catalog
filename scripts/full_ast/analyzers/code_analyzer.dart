import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart'; // Добавляем импорт для ParseStringResult
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart'; // Добавляем импорт для SimpleAstVisitor
import 'package:logger/logger.dart';

import '../collectors/base_collector.dart';
import '../collectors/class_collector.dart';
import '../collectors/function_collector.dart';
import '../collectors/type_collector.dart';
import '../models/ast_node.dart';
import '../models/class_info.dart';
import '../utils/ast_utils.dart';
import '../utils/logger.dart';

/// Анализатор кода для извлечения структурной информации из Dart файлов
class CodeAnalyzer {
  /// Логгер для класса
  final Logger _logger = setupLogger('CodeAnalyzer');

  /// Коллекторы для анализа различных аспектов кода
  late final List<BaseCollector> _collectors;

  /// Конструктор анализатора кода
  CodeAnalyzer() {
    // Инициализируем коллекторы для разных типов узлов AST
    _collectors = [
      ClassCollector(),
      FunctionCollector(),
      TypeCollector(),
    ];
  }

  /// Анализирует содержимое файла и создает структурированное представление
  Future<FileNode> analyzeFile(
      File file, ParseStringResult? parseResult) async {
    _logger.i('Анализ файла: ${file.path}');

    try {
      // Если результат парсинга не предоставлен, выполняем парсинг
      parseResult ??= await _parseFile(file);

      // Создаем базовую структуру узла файла
      final fileNode = FileNode(
        path: file.path,
        name: file.path.split(Platform.pathSeparator).last,
        size: file.lengthSync(),
        lastModified: file.lastModifiedSync(),
      );

      // Анализируем структуру файла
      _analyzeStructure(fileNode, parseResult);

      // Анализируем импорты и экспорты
      _analyzeImportsExports(fileNode, parseResult);

      // Анализируем ошибки парсинга
      _analyzeErrors(fileNode, parseResult);

      return fileNode;
    } catch (e, stackTrace) {
      _logger.e('Ошибка при анализе файла ${file.path}',
          error: e, stackTrace: stackTrace);

      // Возвращаем узел файла с информацией об ошибке
      return FileNode(
        path: file.path,
        name: file.path.split(Platform.pathSeparator).last,
        hasError: true,
        errorMessage: e.toString(),
        errorStackTrace: stackTrace.toString(),
      );
    }
  }

  /// Парсит файл в AST
  Future<ParseStringResult> _parseFile(File file) async {
    final content = await file.readAsString();
    return parseString(
      content: content,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );
  }

  /// Анализирует структуру файла, применяя все коллекторы
  void _analyzeStructure(FileNode fileNode, ParseStringResult parseResult) {
    // Инициализируем коллекторы перед использованием
    for (final collector in _collectors) {
      collector.initialize();
    }

    // Применяем каждый коллектор для анализа различных аспектов кода
    for (final collector in _collectors) {
      try {
        parseResult.unit.accept(collector);

        // Собираем результаты анализа в соответствующие поля файла
        if (collector is ClassCollector) {
          fileNode.classes = collector.classes;
        } else if (collector is FunctionCollector) {
          fileNode.functions = collector.functions;
        } else if (collector is TypeCollector) {
          fileNode.types = collector.types;
        }

        // Завершаем работу коллектора
        collector.finalize();

        // Также обновляем список всех объявлений в файле
        fileNode.declarations
            .addAll(collector.declarations.cast<DeclarationInfo>());
      } catch (e, stackTrace) {
        _logger.w(
            'Ошибка при применении коллектора ${collector.runtimeType} '
            'к файлу ${fileNode.path}',
            error: e,
            stackTrace: stackTrace);
      }
    }

    // Анализируем топ-уровневые переменные
    _analyzeTopLevelVariables(fileNode, parseResult);

    // Анализируем документацию файла
    _analyzeFileDocumentation(fileNode, parseResult);

    // Рассчитываем метрики сложности кода
    _calculateComplexityMetrics(fileNode, parseResult);
  }

  /// Анализирует импорты и экспорты в файле
  void _analyzeImportsExports(
      FileNode fileNode, ParseStringResult parseResult) {
    fileNode.imports = AstUtils.extractImports(parseResult.unit);
    fileNode.exports = AstUtils.extractExports(parseResult.unit);
    fileNode.parts = AstUtils.extractParts(parseResult.unit);
  }

  /// Анализирует ошибки парсинга
  void _analyzeErrors(FileNode fileNode, ParseStringResult parseResult) {
    if (parseResult.errors.isNotEmpty) {
      fileNode.parseErrors = parseResult.errors
          .map((e) => ParseErrorInfo(
                message: e.message,
                offset: e.offset,
                length: e.length,
                severity: e.severity.name,
              ))
          .toList();
    }
  }

  /// Анализирует топ-уровневые переменные в файле
  void _analyzeTopLevelVariables(
      FileNode fileNode, ParseStringResult parseResult) {
    final visitor = _TopLevelVariableVisitor();
    parseResult.unit.accept(visitor);
    fileNode.topLevelVariables = visitor.variables;
  }

  /// Анализирует документацию файла
  void _analyzeFileDocumentation(
      FileNode fileNode, ParseStringResult parseResult) {
    final unit = parseResult.unit;

    // Извлекаем комментарий из начала файла, если есть
    final firstMember = _getFirstMemberWithComment(unit);
    if (firstMember != null) {
      // Если первый элемент имеет комментарий, используем его как документацию файла
      fileNode.documentation = AstUtils.extractDocumentation(firstMember);
    } else {
      // Проверяем, есть ли комментарии до первого члена
      final firstToken = unit.beginToken;
      if (firstToken.precedingComments != null) {
        final docComment =
            _extractFileDocumentation(firstToken.precedingComments!);
        if (docComment != null && docComment.isNotEmpty) {
          fileNode.documentation = docComment;
        }
      }
    }
  }

  /// Получает первый элемент файла, у которого есть комментарий документации
  AnnotatedNode? _getFirstMemberWithComment(CompilationUnit unit) {
    // Проверяем сначала директивы
    for (final directive in unit.directives) {
      // Удалена избыточная проверка типа, так как все директивы являются AnnotatedNode
      if (directive.documentationComment != null) {
        return directive;
      }
    }

    // Затем проверяем декларации
    if (unit.declarations.isNotEmpty) {
      final firstDeclaration = unit.declarations.first;
      if (firstDeclaration.documentationComment != null) {
        return firstDeclaration;
      }
    }

    return null;
  }

  /// Извлекает документацию из комментариев в начале файла
  String? _extractFileDocumentation(Token commentToken) {
    final buffer = StringBuffer();
    var token = commentToken;

    // Собираем все последовательные комментарии документации (/// или /** */)
    while (true) {
      final commentText = token.lexeme;
      if (commentText.startsWith('///') || commentText.startsWith('/**')) {
        if (buffer.isNotEmpty) {
          buffer.write('\n');
        }

        // Удаляем маркеры комментариев
        final textContent = commentText
            .replaceAll(RegExp(r'^/// ?', multiLine: true), '')
            .replaceAll(RegExp(r'^/\*\* ?| ?\*/$'), '')
            .replaceAll(RegExp(r'^\* ?', multiLine: true), '');

        buffer.write(textContent.trim());
      } else if (!commentText.startsWith('//')) {
        // Прерываем, если это не однострочный комментарий (например, // comment)
        break;
      }

      // Проверяем, есть ли следующий токен, и выходим из цикла, если его нет
      if (token.next == null) {
        break;
      }

      token = token.next!;
    }

    return buffer.toString().trim().isEmpty ? null : buffer.toString().trim();
  }

  /// Рассчитывает метрики сложности кода
  void _calculateComplexityMetrics(
      FileNode fileNode, ParseStringResult parseResult) {
    // Получаем содержимое файла для анализа
    final fileContent = parseResult.content;

    // Рассчитываем базовые метрики
    fileNode.metrics = AstUtils.calculateCodeMetrics(fileContent);

    // Обновляем метрики на основе собранной информации
    fileNode.metrics.classCount = fileNode.classes.length;

    // Исправляем проблему с методами - нужно приведение типов, так как классы в классах имеют тип Object
    fileNode.metrics.methodCount = fileNode.classes.fold<int>(0, (sum, cls) {
      // Используем безопасный доступ, предполагая что класс имеет свойство methods
      final methods = cls is ClassInfo ? cls.methods : null;
      return sum + (methods?.length ?? 0);
    });

    fileNode.metrics.functionCount = fileNode.functions.length;
    fileNode.metrics.maxNestingLevel =
        AstUtils.calculateMaxNestingLevel(parseResult.unit);

    // Рассчитываем среднюю длину методов при наличии методов
    if (fileNode.metrics.methodCount > 0) {
      // Сначала вычисляем общую сложность методов как целое число
      final totalMethodLines = fileNode.classes.fold<int>(
        0,
        (int sum, cls) {
          // Для каждого класса суммируем сложность всех методов
          // Проверяем, является ли объект ClassInfo для доступа к методам
          if (cls is! ClassInfo) return sum;

          final classMethods = cls.methods;
          if (classMethods.isEmpty) {
            return sum;
          }

          // Исправлено: методы должны быть обработаны с проверкой на их тип
          final methodsSum = classMethods.fold<int>(
            0,
            (int methodSum, method) => methodSum + (method.complexity ?? 1),
          );

          return sum + methodsSum;
        },
      );

      // Теперь выполняем деление, чтобы получить среднее значение
      fileNode.metrics.averageMethodLength =
          totalMethodLines / fileNode.metrics.methodCount;
    }

    // Рассчитываем плотность комментариев
    if (fileNode.metrics.codeLines > 0) {
      fileNode.metrics.commentDensity =
          fileNode.metrics.commentLines / fileNode.metrics.codeLines;
    }

    _logger.d(
        'Метрики файла ${fileNode.path}: классы=${fileNode.metrics.classCount}, '
        'методы=${fileNode.metrics.methodCount}, функции=${fileNode.metrics.functionCount}, '
        'сложность=${fileNode.metrics.complexity}');
  }
}

/// Вспомогательный класс для сбора топ-уровневых переменных
class _TopLevelVariableVisitor extends SimpleAstVisitor<void> {
  final List<VariableInfo> variables = [];

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    for (final variable in node.variables.variables) {
      final type = node.variables.type?.toString() ?? 'dynamic';
      variables.add(VariableInfo(
        name: variable.name.lexeme,
        type: type,
        isFinal: node.variables.isFinal,
        isConst: node.variables.isConst,
        isLate: node.variables.isLate,
        documentation: AstUtils.extractDocumentation(node),
        initializer: variable.initializer?.toString(),
        location: AstUtils.createSourceLocation(variable),
      ));
    }
    super.visitTopLevelVariableDeclaration(node);
  }
}
