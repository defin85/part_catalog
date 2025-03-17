import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart'; // Добавляем импорт для ParseStringResult
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart'; // Добавляем импорт для SimpleAstVisitor
import 'package:logger/logger.dart';
import 'package:part_catalog/scripts/full_ast/models/declaration_info.dart';
import 'package:part_catalog/scripts/full_ast/models/function_info.dart';
import 'package:part_catalog/scripts/full_ast/models/variable_info.dart';

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
      ClassCollector(collectorName: 'ClassCollector'),
      FunctionCollector(collectorName: 'FunctionCollector'),
      TypeCollector(collectorName: 'TypeCollector'),
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
        size: file.lengthSync(),
        lastModified: file.lastModifiedSync(),
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
  FileNode _analyzeStructure(FileNode fileNode, ParseStringResult parseResult) {
    // Инициализируем коллекторы перед использованием
    for (final collector in _collectors) {
      collector.initialize();
    }

    List<ClassInfo> updatedClasses = fileNode.classes;
    List<FunctionInfo> updatedFunctions = fileNode.functions;
    List<DeclarationInfo> updatedDeclarations =
        List<DeclarationInfo>.from(fileNode.declarations);

    // Применяем каждый коллектор для анализа различных аспектов кода
    for (final collector in _collectors) {
      try {
        parseResult.unit.accept(collector);

        // Собираем результаты анализа во временные переменные
        if (collector is ClassCollector) {
          updatedClasses = collector.classes;
        } else if (collector is FunctionCollector) {
          updatedFunctions = collector.functions;
        } else if (collector is TypeCollector) {
          // TypeInfo должны быть также добавлены в declarations, так как они
          // представляют декларации типов
          updatedDeclarations.addAll(collector.types.cast<DeclarationInfo>());
        }

        // Завершаем работу коллектора
        collector.finalize();

        // Также обновляем список всех объявлений
        updatedDeclarations
            .addAll(collector.declarations.cast<DeclarationInfo>());
      } catch (e, stackTrace) {
        _logger.w(
            'Ошибка при применении коллектора ${collector.runtimeType} '
            'к файлу ${fileNode.path}',
            error: e,
            stackTrace: stackTrace);
      }
    }

    // Создаем новый объект FileNode с обновленными данными
    // Убираем поле types из вызова copyWith
    final updatedFileNode = fileNode.copyWith(
      classes: updatedClasses,
      functions: updatedFunctions,
      declarations: updatedDeclarations,
    );

    // Анализируем топ-уровневые переменные и другие аспекты для обновленного узла
    _analyzeTopLevelVariables(updatedFileNode, parseResult);
    _analyzeFileDocumentation(updatedFileNode, parseResult);
    _calculateComplexityMetrics(updatedFileNode, parseResult);

    return updatedFileNode;
  }

  /// Анализирует импорты и экспорты в файле
  void _analyzeImportsExports(
      FileNode fileNode, ParseStringResult parseResult) {
    final imports = AstUtils.extractImports(parseResult.unit);
    final exports = AstUtils.extractExports(parseResult.unit);
    final partInfos = AstUtils.extractParts(parseResult.unit, fileNode.path);

    // Преобразуем List<PartInfo> в List<String>, извлекая URI из каждого объекта PartInfo
    final parts = partInfos.map((partInfo) => partInfo.uri).toList();

    // Update the fileNode using copyWith instead of direct assignment
    final updatedFileNode = fileNode.copyWith(
      imports: imports,
      exports: exports,
      parts: parts,
    );

    // Copy all updated properties back to the fileNode
    fileNode = updatedFileNode;
  }

  /// Анализирует ошибки парсинга
  void _analyzeErrors(FileNode fileNode, ParseStringResult parseResult) {
    if (parseResult.errors.isNotEmpty) {
      final errors = parseResult.errors
          .map((e) => ParseErrorInfo(
                message: e.message,
                offset: e.offset,
                length: e.length,
                severity: e.severity.name,
              ))
          .toList();

      // Update the fileNode using copyWith instead of direct assignment
      final updatedFileNode = fileNode.copyWith(
        parseErrors: errors,
      );

      // Copy all updated properties back to the fileNode
      fileNode = updatedFileNode;
    }
  }

  /// Анализирует топ-уровневые переменные в файле
  void _analyzeTopLevelVariables(
      FileNode fileNode, ParseStringResult parseResult) {
    final visitor = _TopLevelVariableVisitor();
    parseResult.unit.accept(visitor);

    // Update the fileNode using copyWith instead of direct assignment
    final updatedFileNode = fileNode.copyWith(
      topLevelVariables: visitor.variables,
    );

    // Copy all updated properties back to the fileNode
    fileNode = updatedFileNode;
  }

  /// Анализирует документацию файла
  void _analyzeFileDocumentation(
      FileNode fileNode, ParseStringResult parseResult) {
    final unit = parseResult.unit;

    // Извлекаем комментарий из начала файла, если есть
    final firstMember = _getFirstMemberWithComment(unit);
    if (firstMember != null) {
      // Если первый элемент имеет комментарий, используем его как документацию файла
      final updatedFileNode = fileNode.copyWith(
        documentation: AstUtils.extractDocumentation(firstMember),
      );

      // Copy all updated properties back to the fileNode
      fileNode = updatedFileNode;
    } else {
      // Проверяем, есть ли комментарии до первого члена
      final firstToken = unit.beginToken;
      if (firstToken.precedingComments != null) {
        final docComment =
            _extractFileDocumentation(firstToken.precedingComments!);
        if (docComment != null && docComment.isNotEmpty) {
          final updatedFileNode = fileNode.copyWith(
            documentation: docComment,
          );

          // Copy all updated properties back to the fileNode
          fileNode = updatedFileNode;
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
    var metrics = AstUtils.calculateCodeMetrics(fileContent);

    // Обновляем метрики на основе собранной информации
    metrics = metrics.copyWith(classCount: fileNode.classes.length);

    // Исправляем проблему с методами - нужно приведение типов, так как классы в классах имеют тип Object
    final methodCount = fileNode.classes.fold<int>(0, (sum, cls) {
      // Используем безопасный доступ к методам класса
      return sum + (cls.methods.length);
    });

    // Рассчитываем среднюю длину методов при наличии методов
    double? averageMethodLength;
    if (methodCount > 0) {
      // Сначала вычисляем общую сложность методов как целое число
      final totalMethodLines = fileNode.classes.fold<int>(
        0,
        (int sum, cls) {
          // Для каждого класса суммируем сложность всех методов
          // Проверяем, является ли объект ClassInfo для доступа к методам
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
      averageMethodLength = totalMethodLines / methodCount;
    }

    // Рассчитываем плотность комментариев
    double? commentDensity;
    if (metrics.codeLines > 0) {
      commentDensity = metrics.commentLines / metrics.codeLines;
    }

    // Обновляем метрики с новыми расчетами
    metrics = metrics.copyWith(
      methodCount: methodCount,
      functionCount: fileNode.functions.length,
      maxNestingLevel: AstUtils.calculateMaxNestingLevel(parseResult.unit),
      averageMethodLength: averageMethodLength ?? 0.0,
      commentDensity: commentDensity ?? 0.0,
    );

    // Обновляем fileNode с новыми метриками
    final updatedFileNode = fileNode.copyWith(metrics: metrics);
    fileNode = updatedFileNode;

    _logger.d(
        'Метрики файла ${fileNode.path}: классы=${fileNode.metrics?.classCount ?? 0}, '
        'методы=${fileNode.metrics?.methodCount ?? 0}, функции=${fileNode.metrics?.functionCount ?? 0}, '
        'сложность=${fileNode.metrics?.complexity ?? 0}');
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
        initialValue: variable.initializer
            ?.toString(), // Исправлено с 'initializer' на 'initialValue'
        location: AstUtils.createSourceLocation(variable),
        isPublic: !variable.name.lexeme
            .startsWith('_'), // Добавлена проверка публичности
      ));
    }
    super.visitTopLevelVariableDeclaration(node);
  }
}
