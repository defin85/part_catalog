import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/ast_node.dart';
import '../models/declaration_info.dart';
import '../models/type_info.dart';
import 'base_collector.dart';

/// Коллектор для сбора информации о типах данных в AST.
///
/// Отвечает за извлечение информации о перечислениях (enum),
/// определениях типов (typedef) и других типовых определениях.
class TypeCollector extends BaseCollector {
  /// Список собранных информаций о типах
  final List<TypeInfo> _types = [];

  /// Создаёт экземпляр коллектора типов
  TypeCollector() : super(collectorName: 'TypeCollector');

  /// Возвращает список собранных типов
  List<TypeInfo> get types => List.unmodifiable(_types);

  @override
  void initialize() {
    super.initialize();
    _types.clear();
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    // Извлекаем информацию об enum
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Извлекаем константы enum
    final constants = node.constants
        .map((constant) => EnumConstantInfo(
              name: constant.name.lexeme,
              documentation: extractDocumentation(constant),
              annotations: collectAnnotations(constant.metadata),
              location: createSourceLocation(constant),
              constructorArguments: constant.arguments?.toString(),
            ))
        .toList();

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

    // Создаем объект для информации о типе enum
    final enumInfo = TypeInfo(
      name: name,
      kind: 'enum',
      isPublic: !name.startsWith('_'),
      documentation: documentation,
      annotations: collectAnnotations(node.metadata),
      enumConstants: constants,
      interfaces: interfaces,
      mixins: mixins,
      location: location,
    );

    // Добавляем enum в список типов
    _types.add(enumInfo);

    // Добавляем enum в список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'enum',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Посещаем все члены enum для поиска вложенных типов
    super.visitEnumDeclaration(node);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    // Извлекаем информацию о типе-алиасе
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Получаем параметры типа
    final typeParameters = node.typeParameters?.typeParameters
        .map((param) => param.name.lexeme)
        .toList();

    // Получаем определение типа
    String typeDefinition;
    if (node.functionType != null) {
      typeDefinition = node.functionType.toString();
    } else if (node.type != null) {
      typeDefinition = node.type.toString();
    } else {
      typeDefinition = 'dynamic';
    }

    // Создаем объект для информации о типе-алиасе
    final typedefInfo = TypeInfo(
      name: name,
      kind: 'typedef',
      isPublic: !name.startsWith('_'),
      documentation: documentation,
      annotations: collectAnnotations(node.metadata),
      typeParameters: typeParameters,
      typeDefinition: typeDefinition,
      location: location,
    );

    // Добавляем typedef в список типов
    _types.add(typedefInfo);

    // Добавляем typedef в список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'typedef',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Посещаем тип для поиска вложенных типов
    super.visitGenericTypeAlias(node);
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    // Извлекаем информацию о функциональном типе-алиасе
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Получаем параметры функционального типа
    final parameters =
        node.parameters.parameters.map((p) => p.toString()).toList();

    // Получаем параметры типа
    final typeParameters = node.typeParameters?.typeParameters
        .map((param) => param.name.lexeme)
        .toList();

    // Получаем возвращаемый тип
    final returnType = node.returnType?.toString() ?? 'dynamic';

    // Создаем объект для информации о функциональном типе-алиасе
    final functionTypedefInfo = TypeInfo(
      name: name,
      kind: 'functionTypedef',
      isPublic: !name.startsWith('_'),
      documentation: documentation,
      annotations: collectAnnotations(node.metadata),
      typeParameters: typeParameters,
      functionParameters: parameters,
      returnType: returnType,
      location: location,
    );

    // Добавляем функциональный typedef в список типов
    _types.add(functionTypedefInfo);

    // Добавляем функциональный typedef в список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'functionTypedef',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Посещаем тип для поиска вложенных типов
    super.visitFunctionTypeAlias(node);
  }

  @override
  void visitExtensionTypeDeclaration(ExtensionTypeDeclaration node) {
    // Этот метод будет работать только для Dart 3.0+, где появились extension types
    // Извлекаем информацию о extension type
    final name = node.name.lexeme;
    final documentation = extractDocumentation(node);
    final location = createSourceLocation(node);

    // Получаем представленный тип
    final representationType = node.representation.toString();

    // Получаем параметры типа
    final typeParameters = node.typeParameters?.typeParameters
        .map((param) => param.name.lexeme)
        .toList();

    // Получаем реализуемые интерфейсы
    final interfaces = node.implementsClause?.interfaces
            .map((interface) => interface.name2.lexeme)
            .toList() ??
        <String>[];

    // Создаем объект для информации об extension type
    final extensionTypeInfo = TypeInfo(
      name: name,
      kind: 'extensionType',
      isPublic: !name.startsWith('_'),
      documentation: documentation,
      annotations: collectAnnotations(node.metadata),
      typeParameters: typeParameters,
      representationType: representationType,
      interfaces: interfaces,
      location: location,
    );

    // Добавляем extension type в список типов
    _types.add(extensionTypeInfo);

    // Добавляем extension type в список деклараций
    addDeclaration(DeclarationInfo(
      name: name,
      type: 'extensionType',
      isPublic: !name.startsWith('_'),
      location: location,
    ));

    // Посещаем extension type для поиска вложенных типов
    super.visitExtensionTypeDeclaration(node);
  }

  @override
  void finalize() {
    _logger.d(
        'Собрано ${_types.length} типов: ${_types.map((t) => "${t.kind}:${t.name}").join(', ')}');
    super.finalize();
  }
}
