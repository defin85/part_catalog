import 'package:analyzer/dart/ast/ast.dart';

import '../models/class_info.dart';
import '../models/declaration_info.dart';
import 'base_collector.dart';

/// Коллектор для сбора информации о классах в AST.
///
/// Отвечает за извлечение информации о классах, их методах, полях,
/// конструкторах и других членах.
class ClassCollector extends BaseCollector {
  /// Список собранных классов
  final List<ClassInfo> _classes = [];

  /// Текущий анализируемый класс
  ClassInfo? _currentClass;

  // Создаёт экземпляр коллектора функций
  ClassCollector({required super.collectorName});

  /// Возвращает список собранных классов
  List<ClassInfo> get classes => List.unmodifiable(_classes);

  @override
  void initialize() {
    super.initialize();
    _classes.clear();
    _currentClass = null;
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    // Извлекаем информацию о классе
    final className = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);
    final superclass = node.extendsClause?.superclass.name2.lexeme;

    // Извлекаем интерфейсы, которые класс реализует
    final interfaces = node.implementsClause?.interfaces
            .map((interface) => interface.name2.lexeme)
            .toList() ??
        <String>[];

    // Извлекаем миксины, которые класс использует
    final mixins = node.withClause?.mixinTypes
            .map((mixin) => mixin.name2.lexeme)
            .toList() ??
        <String>[];

    // Извлекаем параметры типа (generic-параметры)
    final typeParameters = node.typeParameters?.typeParameters
            .map((param) => param.name.lexeme)
            .toList() ??
        <String>[];

    // Собираем модификаторы класса
    final modifiers = <String>[];
    if (node.abstractKeyword != null) modifiers.add('abstract');
    if (node.finalKeyword != null) modifiers.add('final');
    if (node.sealedKeyword != null) modifiers.add('sealed');
    if (node.interfaceKeyword != null) modifiers.add('interface');
    if (node.mixinKeyword != null) modifiers.add('mixin');
    if (node.baseKeyword != null) modifiers.add('base');

    // Создаем объект для информации о классе
    _currentClass = ClassInfo(
      name: className,
      documentation: documentation,
      isAbstract: node.abstractKeyword != null,
      superclass: superclass,
      interfaces: interfaces,
      mixins: mixins,
      typeParameters: typeParameters,
      modifiers: modifiers,
      fields: [],
      methods: [],
      constructors: [],
      location: location,
    );

    // Посещаем все члены класса
    super.visitClassDeclaration(node);

    // Если класс имеет ненулевое имя, добавляем его в список
    if (className.isNotEmpty) {
      _classes.add(_currentClass!);

      // Добавляем класс в общий список деклараций
      addDeclaration(DeclarationInfo(
        name: className,
        type: 'class',
        isPublic: !className.startsWith('_'), // Определяем публичность по имени
        location: location,
      ));

      // Очищаем текущий класс
      _currentClass = null;
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Проверяем, что мы внутри класса
    if (_currentClass == null) {
      super.visitMethodDeclaration(node);
      return;
    }

    // Извлекаем информацию о методе
    final methodName = node.name.lexeme;
    final returnType = formatTypeAsString(node.returnType);
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);
    final isStatic = node.isStatic;

    // Собираем параметры метода
    final parameters = <ParameterInfo>[];
    if (node.parameters != null) {
      for (final parameter in node.parameters!.parameters) {
        parameters.add(_extractParameterInfo(parameter));
      }
    }

    // Получаем тело метода (если есть)
    final body = node.body.toString();

    // Вычисляем сложность метода
    final complexity = calculateComplexity(node.body);

    // Собираем модификаторы метода
    final modifiers = <String>[];
    if (node.isStatic) modifiers.add('static');
    if (node.isAbstract) modifiers.add('abstract');
    if (node.isGetter) modifiers.add('getter');
    if (node.isSetter) modifiers.add('setter');
    if (node.externalKeyword != null) modifiers.add('external');

    // Определяем, является ли метод переопределенным
    final isOverride =
        node.metadata.any((meta) => meta.name.name == 'override');

    // Создаем объект для информации о методе
    final methodInfo = MethodInfo(
      name: methodName,
      returnType: returnType,
      parameters: parameters,
      isStatic: isStatic,
      isGetter: node.isGetter,
      isSetter: node.isSetter,
      isAbstract: node.isAbstract,
      isExternal: node.externalKeyword != null,
      isAsynchronous: node.body.isAsynchronous,
      isGenerator: node.body.isGenerator,
      complexity: complexity,
      documentation: documentation,
      body: body,
      modifiers: modifiers,
      isOverride: isOverride,
      typeParameters: node.typeParameters?.typeParameters
          .map((param) => param.name.lexeme)
          .toList(),
      location: location,
    );

    // Правильный подход с сохранением иммутабельности
    final updatedMethods = List<MethodInfo>.from(_currentClass!.methods)
      ..add(methodInfo);
    _currentClass = _currentClass!.copyWith(methods: updatedMethods);

    // Посещаем тело метода
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    // Проверяем, что мы внутри класса
    if (_currentClass == null) {
      super.visitFieldDeclaration(node);
      return;
    }

    // Получаем тип поля
    final type = formatTypeAsString(node.fields.type);
    final documentation = extractDocumentation(node);
    final isStatic = node.isStatic;

    // Обрабатываем каждую переменную в объявлении поля
    List<FieldInfo> updatedFields = List<FieldInfo>.from(_currentClass!.fields);
    for (final variable in node.fields.variables) {
      final fieldName = variable.name.lexeme;
      final location = createSourceLocation(variable);

      // Собираем модификаторы поля
      final modifiers = <String>[];
      if (node.isStatic) modifiers.add('static');
      if (node.fields.isFinal) modifiers.add('final');
      if (node.fields.isConst) modifiers.add('const');
      if (node.fields.isLate) modifiers.add('late');
      if (node.externalKeyword != null) {
        modifiers.add('external'); // Исправляем здесь
      }

      // Получаем инициализатор поля, если есть
      final initializer = variable.initializer?.toString();

      // Определяем, является ли поле публичным
      final isPublic = !fieldName.startsWith('_');

      // Создаем объект для информации о поле
      final fieldInfo = FieldInfo(
        name: fieldName,
        type: type,
        isStatic: isStatic,
        isFinal: node.fields.isFinal,
        isConst: node.fields.isConst,
        isLate: node.fields.isLate,
        documentation: documentation,
        initializer: initializer,
        modifiers: modifiers,
        isPublic: isPublic,
        location: location,
      );

      // Добавляем в новый список
      updatedFields.add(fieldInfo);
    }

    // Обновляем _currentClass атомарно
    _currentClass = _currentClass!.copyWith(fields: updatedFields);

    // Посещаем поле для дальнейшего анализа
    super.visitFieldDeclaration(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    // Проверяем, что мы внутри класса
    if (_currentClass == null) {
      super.visitConstructorDeclaration(node);
      return;
    }

    // Извлекаем имя конструктора
    final name = node.name?.lexeme ?? '';
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Собираем параметры конструктора
    final parameters = <ParameterInfo>[];
    for (final parameter in node.parameters.parameters) {
      parameters.add(_extractParameterInfo(parameter));
    }

    // Собираем инициализаторы конструктора
    final initializers =
        node.initializers.map((initializer) => initializer.toString()).toList();

    // Собираем модификаторы конструктора
    final modifiers = <String>[];
    if (node.constKeyword != null) modifiers.add('const');
    if (node.factoryKeyword != null) modifiers.add('factory');
    if (node.externalKeyword != null) modifiers.add('external');

    // Получаем тело конструктора
    final body = node.body.toString();

    // Определяем, является ли конструктор перенаправляющим
    final redirectedConstructor = node.redirectedConstructor?.toString();

    // Создаем объект для информации о конструкторе
    final constructorInfo = ConstructorInfo(
      name: name,
      parameters: parameters,
      initializers: initializers,
      isConst: node.constKeyword != null,
      isFactory: node.factoryKeyword != null,
      isExternal: node.externalKeyword != null,
      documentation: documentation,
      body: body,
      modifiers: modifiers,
      redirectedConstructor: redirectedConstructor,
      location: location,
    );

    // Добавляем конструктор в текущий класс
    final updatedConstructors =
        List<ConstructorInfo>.from(_currentClass!.constructors)
          ..add(constructorInfo);
    _currentClass = _currentClass!.copyWith(constructors: updatedConstructors);

    // Посещаем тело конструктора
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    // Извлекаем информацию об enum
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Извлекаем константы enum и преобразуем их в EnumConstantInfo
    final constants = node.constants.map((constant) {
      return ClassEnumConstInfo(
        name: constant.name.lexeme,
        documentation: extractDocumentation(constant),
        location: createSourceLocation(constant),
        constructorArguments: constant.arguments?.toString(),
      );
    }).toList();

    // Извлекаем интерфейсы, которые enum реализует
    final interfaces = node.implementsClause?.interfaces
            .map((interface) => interface.name2.lexeme)
            .toList() ??
        <String>[];

    // Извлекаем миксины, которые enum использует
    final mixins = node.withClause?.mixinTypes
            .map((mixin) => mixin.name2.lexeme)
            .toList() ??
        <String>[];

    // Создаем объект для информации о классе (enum - это специальный вид класса)
    _currentClass = ClassInfo(
      name: name,
      documentation: documentation,
      isAbstract: false,
      isEnum: true, // Помечаем как enum
      enumConstants: constants, // Теперь constants имеет правильный тип
      interfaces: interfaces,
      mixins: mixins,
      fields: [],
      methods: [],
      constructors: [],
      location: location,
    );

    // Посещаем все члены enum
    super.visitEnumDeclaration(node);

    // Добавляем enum в список классов
    _classes.add(_currentClass!);

    // Добавляем enum в общий список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'enum',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Очищаем текущий класс
    _currentClass = null;
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    // Извлекаем информацию о миксине
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Извлекаем ограничения типа "on"
    final onTypes = node.onClause?.superclassConstraints
            .map((constraint) => constraint.name2.lexeme)
            .toList() ??
        <String>[];

    // Извлекаем интерфейсы, которые миксин реализует
    final interfaces = node.implementsClause?.interfaces
            .map((interface) => interface.name2.lexeme)
            .toList() ??
        <String>[];

    // Извлекаем параметры типа
    final typeParameters = node.typeParameters?.typeParameters
            .map((param) => param.name.lexeme)
            .toList() ??
        <String>[];

    // Создаем объект для информации о классе (миксин обрабатываем как специальный класс)
    _currentClass = ClassInfo(
      name: name,
      documentation: documentation,
      isMixin: true, // Помечаем как миксин
      onTypes: onTypes,
      interfaces: interfaces,
      typeParameters: typeParameters,
      fields: [],
      methods: [],
      constructors: [],
      location: location,
    );

    // Посещаем все члены миксина
    super.visitMixinDeclaration(node);

    // Добавляем миксин в список классов
    _classes.add(_currentClass!);

    // Добавляем миксин в общий список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'mixin',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Очищаем текущий класс
    _currentClass = null;
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    // Извлекаем имя расширения
    final name = node.name?.lexeme ?? 'anonymous_extension';
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Извлекаем тип, для которого создано расширение
    // Исправляем здесь: используем node.onClause?.extendedType вместо node.onClause?.type
    final onType = node.onClause?.extendedType.toString() ?? 'dynamic';

    // Извлекаем параметры типа
    final typeParameters = node.typeParameters?.typeParameters
            .map((param) => param.name.lexeme)
            .toList() ??
        <String>[];

    // Создаем объект для информации о классе (расширение обрабатываем как специальный класс)
    _currentClass = ClassInfo(
      name: name,
      documentation: documentation,
      isExtension: true, // Помечаем как расширение
      onType: onType,
      typeParameters: typeParameters,
      fields: [],
      methods: [],
      constructors: [],
      location: location,
    );

    // Посещаем все члены расширения
    super.visitExtensionDeclaration(node);

    // Добавляем расширение в список классов
    _classes.add(_currentClass!);

    // Добавляем расширение в общий список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'extension',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Очищаем текущий класс
    _currentClass = null;
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
      type = parameter.type?.toString() ?? 'dynamic';
      isNamed = parameter.isNamed;
      isRequired = !parameter.isOptional;
      isPositional = parameter.isPositional && !parameter.isNamed;
    } else if (parameter is DefaultFormalParameter) {
      if (parameter.parameter is SimpleFormalParameter) {
        final simpleParam = parameter.parameter as SimpleFormalParameter;
        name = simpleParam.name?.lexeme ?? '';
        type = simpleParam.type?.toString() ?? 'dynamic';
      } else {
        name = parameter.parameter.name?.lexeme ?? '';
      }
      defaultValue = parameter.defaultValue?.toString();
      isNamed = parameter.isNamed;
      isRequired = parameter.requiredKeyword != null;
      isPositional = parameter.isPositional && !parameter.isNamed;
    } else if (parameter is FieldFormalParameter) {
      name = parameter.name.lexeme;
      type = parameter.type?.toString() ?? 'dynamic';
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
}
