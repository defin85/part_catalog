import 'package:analyzer/dart/ast/ast.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/scripts/full_ast/utils/logger.dart';

import '../models/declaration_info.dart';
import '../models/function_info.dart';
import 'base_collector.dart';

/// Коллектор для сбора информации о функциях и методах в AST.
///
/// Отвечает за извлечение информации о функциях, их параметрах,
/// возвращаемых типах и других характеристиках.
class FunctionCollector extends BaseCollector {
  /// Логгер для класса
  final Logger _logger;

  /// Список собранных функций
  final List<FunctionInfo> _functions = [];

  /// Текущая область видимости (контекст класса, если внутри класса)
  String? _currentClass;

  // Создаёт экземпляр коллектора функций
  FunctionCollector({required super.collectorName})
      : _logger = setupLogger('AST.$collectorName');

  /// Возвращает список собранных функций
  List<FunctionInfo> get functions => List.unmodifiable(_functions);

  @override
  void initialize() {
    super.initialize();
    _functions.clear();
    _currentClass = null;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    // Извлекаем информацию о функции
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Получаем возвращаемый тип (если указан)
    final returnType = formatTypeAsString(node.returnType);

    // Собираем параметры функции
    final parameters = <ParameterInfo>[];
    if (node.functionExpression.parameters != null) {
      for (final parameter in node.functionExpression.parameters!.parameters) {
        parameters.add(_extractParameterInfo(parameter));
      }
    }

    // Определяем, является ли функция асинхронной/генератором
    final FunctionBody body = node.functionExpression.body;
    final isAsync = body.isAsynchronous;
    final isGenerator = body.isGenerator;

    // Получаем текст тела функции для анализа
    final bodyText = node.functionExpression.body.toString();

    // Вычисляем сложность функции
    final complexity = calculateComplexity(node.functionExpression.body);

    // Определяем модификаторы функции
    final modifiers = <String>[];
    if (node.externalKeyword != null) modifiers.add('external');
    if (node.isGetter) modifiers.add('getter');
    if (node.isSetter) modifiers.add('setter');

    // Создаем объект для информации о функции
    final functionInfo = FunctionInfo(
      name: name,
      returnType: returnType,
      parameters: parameters,
      isAsync: isAsync,
      isGenerator: isGenerator,
      isGetter: node.isGetter,
      isSetter: node.isSetter,
      complexity: complexity,
      documentation: documentation,
      body: bodyText,
      isExternal: node.externalKeyword != null,
      isStatic: false, // Топ-уровневые функции не могут быть статическими
      classContext: _currentClass,
      typeParameters: node.functionExpression.typeParameters?.typeParameters
          .map((param) => param.name.lexeme)
          .toList(),
      modifiers: modifiers,
      location: location,
    );

    // Добавляем функцию в список
    _functions.add(functionInfo);

    // Добавляем функцию в список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'function',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Посещаем тело функции
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Проверяем, что мы знаем контекст класса
    // Если нет, значит это метод внутри не-класса (расширение, миксин)
    final classContext = _currentClass ?? 'unknown';

    // Извлекаем информацию о методе
    final methodName = node.name.lexeme;
    final returnType = formatTypeAsString(node.returnType);
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Собираем параметры метода
    final parameters = <ParameterInfo>[];
    if (node.parameters != null) {
      for (final parameter in node.parameters!.parameters) {
        parameters.add(_extractParameterInfo(parameter));
      }
    }

    // Определяем модификаторы метода
    final modifiers = <String>[];
    if (node.isStatic) modifiers.add('static');
    if (node.isAbstract) modifiers.add('abstract');
    if (node.isGetter) modifiers.add('getter');
    if (node.isSetter) modifiers.add('setter');
    if (node.externalKeyword != null) modifiers.add('external');

    // Определяем, является ли метод переопределенным или приватным
    final isOverride =
        node.metadata.any((meta) => meta.name.name == 'override');
    final isPrivate = methodName.startsWith('_');

    // Получаем текст тела метода
    final bodyText = node.body.toString();

    // Вычисляем сложность метода
    final complexity = calculateComplexity(node.body);

    // Создаем объект для информации о методе (как функция в контексте класса)
    final methodInfo = FunctionInfo(
      name: methodName,
      returnType: returnType,
      parameters: parameters,
      isAsync: node.body.isAsynchronous,
      isGenerator: node.body.isGenerator,
      isGetter: node.isGetter,
      isSetter: node.isSetter,
      complexity: complexity,
      documentation: documentation,
      body: bodyText,
      isAbstract: node.isAbstract,
      isExternal: node.externalKeyword != null,
      isStatic: node.isStatic,
      classContext: classContext,
      isOverride: isOverride,
      typeParameters: node.typeParameters?.typeParameters
          .map((param) => param.name.lexeme)
          .toList(),
      modifiers: modifiers,
      location: location,
    );

    // Добавляем метод в список функций
    _functions.add(methodInfo);

    // Добавляем метод в список деклараций со ссылкой на класс
    addDeclaration(DeclarationInfo(
      name: '$classContext.$methodName',
      type: 'method',
      isPublic: !isPrivate,
      location: location,
    ));

    // Посещаем тело метода
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    // Обрабатываем анонимные функции, если не являются частью объявления функции
    if (node.parent is! FunctionDeclaration &&
        node.parent is! MethodDeclaration) {
      // Анонимные функции не имеют имён, поэтому генерируем синтетическое имя
      final syntheticName = 'anonymous_${node.offset}';
      final location = createSourceLocation(node);

      // Собираем параметры анонимной функции
      final parameters = <ParameterInfo>[];
      if (node.parameters != null) {
        for (final parameter in node.parameters!.parameters) {
          parameters.add(_extractParameterInfo(parameter));
        }
      }

      // Получаем текст тела функции
      final bodyText = node.body.toString();

      // Вычисляем сложность функции
      final complexity = calculateComplexity(node.body);

      // Создаем объект для информации об анонимной функции
      final functionInfo = FunctionInfo(
        name: syntheticName,
        returnType:
            'dynamic', // Анонимные функции часто не имеют явного типа возврата
        parameters: parameters,
        isAsync: node.body.isAsynchronous,
        isGenerator: node.body.isGenerator,
        isAnonymous: true,
        complexity: complexity,
        body: bodyText,
        classContext: _currentClass,
        location: location,
      );

      // Добавляем анонимную функцию в список
      _functions.add(functionInfo);
    }

    // Посещаем тело выражения-функции
    super.visitFunctionExpression(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Сохраняем контекст класса для методов
    final previousClass = _currentClass;
    _currentClass = node.name.lexeme;

    // Посещаем все члены класса
    super.visitClassDeclaration(node);

    // Восстанавливаем предыдущий контекст
    _currentClass = previousClass;
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    // Сохраняем контекст миксина для методов
    final previousClass = _currentClass;
    _currentClass = 'mixin:${node.name.lexeme}';

    // Посещаем все члены миксина
    super.visitMixinDeclaration(node);

    // Восстанавливаем предыдущий контекст
    _currentClass = previousClass;
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    // Сохраняем контекст расширения для методов
    final previousClass = _currentClass;
    _currentClass = 'extension:${node.name?.lexeme ?? 'anonymous'}';

    // Посещаем все члены расширения
    super.visitExtensionDeclaration(node);

    // Восстанавливаем предыдущий контекст
    _currentClass = previousClass;
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    // Проверяем, что мы знаем контекст класса
    if (_currentClass != null) {
      final className = _currentClass!;
      // Извлекаем имя конструктора
      final constructorName = node.name?.lexeme ?? '';
      // Формируем полное имя конструктора
      final fullName =
          constructorName.isEmpty ? className : '$className.$constructorName';

      final documentation = extractDocumentation(node);
      final location = createSourceLocation(node);

      // Собираем параметры конструктора
      final parameters = <ParameterInfo>[];
      for (final parameter in node.parameters.parameters) {
        parameters.add(_extractParameterInfo(parameter));
      }

      // Собираем инициализаторы и редиректы
      final initializers =
          node.initializers.map((init) => init.toString()).toList();
      final redirectedConstructor = node.redirectedConstructor?.toString();

      // Определяем модификаторы конструктора
      final modifiers = <String>[];
      if (node.constKeyword != null) modifiers.add('const');
      if (node.factoryKeyword != null) modifiers.add('factory');
      if (node.externalKeyword != null) modifiers.add('external');

      // Получаем тело конструктора
      final bodyText = node.body.toString();

      // Вычисляем сложность конструктора
      final complexity = calculateComplexity(node.body);

      // Создаем объект для информации о конструкторе (специальный вид функции)
      final constructorInfo = FunctionInfo(
        name: fullName,
        returnType: className, // Конструкторы возвращают экземпляр класса
        parameters: parameters,
        documentation: documentation,
        body: bodyText,
        isConstructor: true,
        isConst: node.constKeyword != null,
        isFactory: node.factoryKeyword != null,
        isExternal: node.externalKeyword != null,
        classContext: className,
        complexity: complexity,
        initializers: initializers,
        redirectedConstructor: redirectedConstructor,
        modifiers: modifiers,
        location: location,
      );

      // Добавляем конструктор в список функций
      _functions.add(constructorInfo);

      // Добавляем конструктор в список деклараций
      addDeclaration(DeclarationInfo(
        name: fullName,
        type: 'constructor',
        isPublic: !constructorName.startsWith('_'),
        location: location,
      ));
    }

    // Посещаем тело конструктора
    super.visitConstructorDeclaration(node);
  }

  /// Извлекает информацию о параметре функции или метода
  ParameterInfo _extractParameterInfo(FormalParameter parameter) {
    String name = '';
    String type = 'dynamic';
    String? defaultValue;
    bool isNamed = false;
    bool isRequired = false;
    bool isPositional = false;

    // Обработка разных видов параметров
    if (parameter is SimpleFormalParameter) {
      name = parameter.name?.lexeme ?? '';
      type = formatTypeAsString(parameter.type);
      isNamed = parameter.isNamed;
      isRequired = !parameter.isOptional;
      isPositional = parameter.isPositional && !parameter.isNamed;
    } else if (parameter is DefaultFormalParameter) {
      if (parameter.parameter is SimpleFormalParameter) {
        final simpleParam = parameter.parameter as SimpleFormalParameter;
        name = simpleParam.name?.lexeme ?? '';
        type = formatTypeAsString(simpleParam.type);
      } else {
        name = parameter.parameter.name?.lexeme ?? '';
      }
      defaultValue = parameter.defaultValue?.toString();
      isNamed = parameter.isNamed;
      isRequired = parameter.requiredKeyword != null;
      isPositional = parameter.isPositional && !parameter.isNamed;
    } else if (parameter is FieldFormalParameter) {
      name = parameter.name.lexeme;
      type = formatTypeAsString(parameter.type);
      isNamed = parameter.isNamed;
      isRequired = !parameter.isOptional;
      isPositional = parameter.isPositional && !parameter.isNamed;
    }

    // Создаем объект для информации о параметре
    return ParameterInfo(
      name: name,
      type: type,
      defaultValue: defaultValue,
      isNamed: isNamed,
      isRequired: isRequired,
      isPositional: isPositional,
      location: createSourceLocation(parameter),
    );
  }

  @override
  void finalize() {
    _logger.d('Собрано ${_functions.length} функций/методов');
    super.finalize();
  }
}
