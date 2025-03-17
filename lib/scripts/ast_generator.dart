import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

/// Логгер для модуля анализа AST
final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);

/// Инициализация логгера
void _setupLogger() {
  Logger.level = Level.info;
}

/// Класс для сбора информации о структуре Dart файла
class CodeStructureCollector extends SimpleAstVisitor<void> {
  final Map<String, dynamic> structure = {};
  final List<Map<String, dynamic>> classes = [];
  final List<Map<String, dynamic>> functions = [];
  final List<Map<String, dynamic>> enums = [];
  final List<Map<String, dynamic>> extensions = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classInfo = {
      'name': node.name.lexeme,
      'isAbstract': node.abstractKeyword != null,
      'documentation': node.documentationComment?.toString(),
      'methods': <Map<String, dynamic>>[],
      'fields': <Map<String, dynamic>>[],
      'constructors': <Map<String, dynamic>>[],
      'superclass': node.extendsClause?.superclass.name2.lexeme,
      'interfaces': node.implementsClause?.interfaces
              .map((interface) => interface.name2.lexeme)
              .toList() ??
          [],
      'mixins': node.withClause?.mixinTypes
              .map((mixin) => mixin.name2.lexeme)
              .toList() ??
          [],
    };

    for (final member in node.members) {
      if (member is MethodDeclaration) {
        final methodInfo = {
          'name': member.name.lexeme,
          'returnType': member.returnType?.toString() ?? 'dynamic',
          'isStatic': member.isStatic,
          'isGetter': member.isGetter,
          'isSetter': member.isSetter,
          'isAbstract': member.isAbstract,
          'documentation': member.documentationComment?.toString(),
          'parameters': member.parameters?.parameters
                  .map((p) => _processParameter(p))
                  .toList() ??
              [],
        };
        (classInfo['methods'] as List<Map<String, dynamic>>).add(methodInfo);
      } else if (member is FieldDeclaration) {
        for (var field in member.fields.variables) {
          final fieldInfo = {
            'name': field.name.lexeme,
            'type': member.fields.type?.toString() ?? 'dynamic',
            'isStatic': member.isStatic,
            'isFinal': member.fields.isFinal,
            'isConst': member.fields.isConst,
            'documentation': member.documentationComment?.toString(),
          };
          (classInfo['fields'] as List<Map<String, dynamic>>).add(fieldInfo);
        }
      } else if (member is ConstructorDeclaration) {
        final constructorInfo = {
          'name': member.name?.lexeme ?? '',
          'isConst': member.constKeyword != null,
          'isFactory': member.factoryKeyword != null,
          'documentation': member.documentationComment?.toString(),
          'parameters': member.parameters.parameters
              .map((p) => _processParameter(p))
              .toList(),
        };
        (classInfo['constructors'] as List<Map<String, dynamic>>)
            .add(constructorInfo);
      }
    }

    classes.add(classInfo);
    super.visitClassDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final functionInfo = {
      'name': node.name.lexeme,
      'returnType': node.returnType?.toString() ?? 'dynamic',
      'isGetter': node.isGetter,
      'isSetter': node.isSetter,
      'documentation': node.documentationComment?.toString(),
      'parameters': node.functionExpression.parameters?.parameters
              .map((p) => _processParameter(p))
              .toList() ??
          [],
    };
    functions.add(functionInfo);
    super.visitFunctionDeclaration(node);
  }

  // Вспомогательный метод для обработки параметров
  Map<String, dynamic> _processParameter(FormalParameter p) {
    String? paramType;
    if (p is SimpleFormalParameter) {
      paramType = p.type?.toString();
    } else if (p is DefaultFormalParameter) {
      if (p.parameter is SimpleFormalParameter) {
        paramType = (p.parameter as SimpleFormalParameter).type?.toString();
      }
    }

    bool isRequired = false;
    bool isNamed = false;
    bool isPositional = false;

    // Определяем тип параметра
    if (p is DefaultFormalParameter) {
      isNamed = p.isNamed;
      isPositional = p.isPositional && !p.isNamed; // Позиционный, но не named
      isRequired = !p.isOptional; // Если не optional, значит required
    } else {
      isNamed = p.isNamed;
      isPositional = p.isPositional && !p.isNamed;
      isRequired = !p.isOptional;
    }

    return {
      'name': p.name?.lexeme ?? '',
      'type': paramType ?? 'dynamic',
      'isRequired': isRequired,
      'isNamed': isNamed,
      'isPositional': isPositional,
      'defaultValue': p is DefaultFormalParameter && p.defaultValue != null
          ? p.defaultValue.toString()
          : null,
    };
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    final enumInfo = {
      'name': node.name.lexeme,
      'documentation': node.documentationComment?.toString(),
      'values': node.constants.map((c) => c.name.lexeme).toList(),
    };
    enums.add(enumInfo);
    super.visitEnumDeclaration(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    final extensionInfo = {
      'name': node.name?.lexeme ?? 'anonymous',
      'documentation': node.documentationComment?.toString(),
      // Исправление: используем правильное свойство extendedType
      'extendedType': node.onClause?.extendedType.toString(),
      'methods': <Map<String, dynamic>>[],
      'fields': <Map<String, dynamic>>[],
    };

    for (final member in node.members) {
      if (member is MethodDeclaration) {
        final methodInfo = {
          'name': member.name.lexeme,
          'returnType': member.returnType?.toString() ?? 'dynamic',
          'isStatic': member.isStatic,
          'isGetter': member.isGetter,
          'isSetter': member.isSetter,
          'documentation': member.documentationComment?.toString(),
          'parameters': member.parameters?.parameters
                  .map((p) => _processParameter(p))
                  .toList() ??
              [],
        };
        (extensionInfo['methods'] as List<Map<String, dynamic>>)
            .add(methodInfo);
      } else if (member is FieldDeclaration) {
        for (var field in member.fields.variables) {
          final fieldInfo = {
            'name': field.name.lexeme,
            'type': member.fields.type?.toString() ?? 'dynamic',
            'isStatic': member.isStatic,
            'isFinal': member.fields.isFinal,
            'isConst': member.fields.isConst,
            'documentation': member.documentationComment?.toString(),
          };
          (extensionInfo['fields'] as List<Map<String, dynamic>>)
              .add(fieldInfo);
        }
      }
    }

    extensions.add(extensionInfo);
    super.visitExtensionDeclaration(node);
  }

  /// Собирает все структурные элементы в один объект
  Map<String, dynamic> getStructure() {
    structure['classes'] = classes;
    structure['functions'] = functions;
    structure['enums'] = enums;
    structure['extensions'] = extensions;
    return structure;
  }
}

/// Обработка директории и создание AST
Future<Map<String, dynamic>> processDirectory(Directory directory) async {
  final result = <String, dynamic>{
    'path': directory.path,
    'files': <Map<String, dynamic>>[],
    'directories': <Map<String, dynamic>>[],
  };

  try {
    final entities = directory.listSync();

    // Сначала обработаем файлы
    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        try {
          final fileAst = await _processFile(entity);
          result['files'].add(fileAst);
        } catch (e, stackTrace) {
          _logger.w('Ошибка обработки файла ${entity.path}: $e',
              error: e, stackTrace: stackTrace);
        }
      }
    }

    // Затем обработаем поддиректории
    for (var entity in entities) {
      if (entity is Directory && !path.basename(entity.path).startsWith('.')) {
        final dirResult = await processDirectory(entity);
        result['directories'].add(dirResult);
      }
    }
  } catch (e, stackTrace) {
    _logger.e('Ошибка обработки директории ${directory.path}: $e',
        error: e, stackTrace: stackTrace);
  }

  return result;
}

/// Обработка файла и создание AST
Future<Map<String, dynamic>> _processFile(File file) async {
  final collector = CodeStructureCollector();
  try {
    final content = await file.readAsString();
    final parseResult = parseString(
      content: content,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );
    parseResult.unit.accept(collector);

    return {
      'path': file.path,
      'name': path.basename(file.path),
      'structure': collector.getStructure(),
      'imports': parseResult.unit.directives
          .whereType<ImportDirective>()
          .map((d) => {
                'uri': d.uri.stringValue,
                'prefix': d.prefix?.name,
                'combinators': d.combinators.map((c) => c.toString()).toList(),
              })
          .toList(),
    };
  } catch (e, stackTrace) {
    _logger.w('Ошибка AST для ${file.path}: $e',
        error: e, stackTrace: stackTrace);
    return {
      'path': file.path,
      'name': path.basename(file.path),
      'error': e.toString(),
    };
  }
}

/// Сохранить AST в JSON-файл
Future<void> saveAstToJson(Map<String, dynamic> ast, String outputPath) async {
  final file = File(outputPath);
  final encoder = JsonEncoder.withIndent('  ');
  await file.writeAsString(encoder.convert(ast));
  _logger.i('AST сохранен в файл: $outputPath');
}

/// Главная функция анализатора
void main() async {
  _setupLogger();

  final projectDir = Directory('lib');
  final outputFile = '.github/project_ast.json';

  _logger.i('Начало анализа проекта...');
  try {
    final ast = await processDirectory(projectDir);
    await saveAstToJson(ast, outputFile);
    _logger.i('Анализ проекта завершен успешно');
  } catch (e, stackTrace) {
    _logger.e('Ошибка при анализе проекта: $e',
        error: e, stackTrace: stackTrace);
  }
}
