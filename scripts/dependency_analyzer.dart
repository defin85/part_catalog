import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as path;

/// Класс для сбора информации о импортах в Dart файле
class ImportCollector extends SimpleAstVisitor<void> {
  final List<Map<String, dynamic>> imports = [];
  final String filePath;

  ImportCollector(this.filePath);

  @override
  void visitImportDirective(ImportDirective node) {
    final uri = node.uri.stringValue;
    if (uri != null) {
      imports.add({
        'uri': uri,
        'isPackage': uri.startsWith('package:'),
        'isRelative':
            uri.startsWith('./') || uri.startsWith('../') || !uri.contains(':'),
        'prefix': node.prefix?.name,
        'isDeferred': node.deferredKeyword != null,
        'combinators': node.combinators.map((c) {
          if (c is ShowCombinator) {
            return {
              'type': 'show',
              'names': c.shownNames.map((n) => n.name).toList()
            };
          } else if (c is HideCombinator) {
            return {
              'type': 'hide',
              'names': c.hiddenNames.map((n) => n.name).toList()
            };
          }
          return {'type': 'unknown'};
        }).toList(),
      });
    }
    super.visitImportDirective(node);
  }
}

/// Модель зависимостей файла
class FileDependency {
  final String path;
  final String relativePath;
  final List<Map<String, dynamic>> imports;
  final List<Map<String, dynamic>> exportedTypes;
  final List<String> errors;

  FileDependency({
    required this.path,
    required this.relativePath,
    required this.imports,
    required this.exportedTypes,
    this.errors = const [],
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'relativePath': relativePath,
        'imports': imports,
        'exportedTypes': exportedTypes,
        'errors': errors,
      };
}

/// Класс для сбора экспортируемых типов из файла
class ExportedTypesCollector extends SimpleAstVisitor<void> {
  final List<Map<String, dynamic>> exportedTypes = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    exportedTypes.add({
      'type': 'class',
      'name': node.name.lexeme,
      'isPublic': !node.name.lexeme.startsWith('_'),
      'isAbstract': node.abstractKeyword != null,
    });
    super.visitClassDeclaration(node);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    exportedTypes.add({
      'type': 'enum',
      'name': node.name.lexeme,
      'isPublic': !node.name.lexeme.startsWith('_'),
    });
    super.visitEnumDeclaration(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    exportedTypes.add({
      'type': 'extension',
      'name': node.name?.lexeme ?? 'anonymous',
      'isPublic': node.name != null && !node.name!.lexeme.startsWith('_'),
      'extendedType': node.extendedType.toString(),
    });
    super.visitExtensionDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    exportedTypes.add({
      'type': 'mixin',
      'name': node.name.lexeme,
      'isPublic': !node.name.lexeme.startsWith('_'),
    });
    super.visitMixinDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (node.parent is CompilationUnit) {
      // Только глобальные функции
      exportedTypes.add({
        'type': 'function',
        'name': node.name.lexeme,
        'isPublic': !node.name.lexeme.startsWith('_'),
        'isGetter': node.isGetter,
        'isSetter': node.isSetter,
      });
    }
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    for (var variable in node.variables.variables) {
      exportedTypes.add({
        'type': 'variable',
        'name': variable.name.lexeme,
        'isPublic': !variable.name.lexeme.startsWith('_'),
        'isConst': node.variables.isConst,
        'isFinal': node.variables.isFinal,
      });
    }
    super.visitTopLevelVariableDeclaration(node);
  }
}

/// Анализ файла для извлечения информации о зависимостях
Future<FileDependency> analyzeFile(File file, String rootPath) async {
  final relativePath = path.relative(file.path, from: rootPath);

  try {
    final content = await file.readAsString();
    final parseResult = parseString(
      content: content,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );

    final importCollector = ImportCollector(file.path);
    parseResult.unit.accept(importCollector);

    final exportedTypesCollector = ExportedTypesCollector();
    parseResult.unit.accept(exportedTypesCollector);

    return FileDependency(
      path: file.path,
      relativePath: relativePath,
      imports: importCollector.imports,
      exportedTypes: exportedTypesCollector.exportedTypes,
    );
  } catch (e) {
    return FileDependency(
      path: file.path,
      relativePath: relativePath,
      imports: [],
      exportedTypes: [],
      errors: [e.toString()],
    );
  }
}

/// Обработка директории для анализа зависимостей
Future<List<FileDependency>> processDirectoryForDependencies(
    Directory directory, String rootPath) async {
  final dependencies = <FileDependency>[];

  try {
    final entities = await directory.list(recursive: true).toList();

    for (var entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        try {
          final dependency = await analyzeFile(entity, rootPath);
          dependencies.add(dependency);
        } catch (e) {
          print('Ошибка при анализе файла ${entity.path}: $e');
        }
      }
    }
  } catch (e) {
    print('Ошибка при обработке директории ${directory.path}: $e');
  }

  return dependencies;
}

/// Создание графа зависимостей на основе собранной информации
Map<String, dynamic> createDependencyGraph(List<FileDependency> dependencies) {
  final graph = <String, dynamic>{
    'nodes': <Map<String, dynamic>>[],
    'links': <Map<String, dynamic>>[],
  };

  // Добавляем узлы (файлы)
  for (var dep in dependencies) {
    graph['nodes'].add({
      'id': dep.relativePath,
      'path': dep.path,
      'types': dep.exportedTypes.length,
      'hasErrors': dep.errors.isNotEmpty,
    });
  }

  // Создаем карту путь -> индекс для быстрого поиска
  final fileIndices = <String, int>{};
  for (var i = 0; i < dependencies.length; i++) {
    fileIndices[dependencies[i].relativePath] = i;
  }

  // Добавляем связи (импорты)
  for (var sourceIndex = 0; sourceIndex < dependencies.length; sourceIndex++) {
    final source = dependencies[sourceIndex];

    for (var import in source.imports) {
      if (import['isRelative']) {
        try {
          final importPath =
              _resolveRelativePath(source.relativePath, import['uri']);
          final targetIndex = fileIndices[importPath];

          if (targetIndex != null) {
            graph['links'].add({
              'source': sourceIndex,
              'target': targetIndex,
              'value': 1, // Вес связи
            });
          }
        } catch (e) {
          print(
              'Ошибка при разрешении пути для импорта ${import['uri']} из ${source.relativePath}: $e');
        }
      }
    }
  }

  return graph;
}

/// Разрешение относительного пути импорта
String _resolveRelativePath(String sourcePath, String importUri) {
  final sourceDir = path.dirname(sourcePath);
  return path.normalize(path.join(sourceDir, importUri));
}

/// Генерация HTML-файла с визуализацией графа
Future<void> generateVisualization(
    Map<String, dynamic> graph, String outputFile) async {
  final html = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Part Catalog - Dependency Graph</title>
  <script src="https://d3js.org/d3.v7.min.js"></script>
  <style>
    body { 
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }
    #container {
      width: 100%;
      height: 100vh;
      display: flex;
    }
    #graph {
      flex: 1;
      overflow: hidden;
    }
    #details {
      width: 300px;
      padding: 1rem;
      background-color: white;
      border-left: 1px solid #ddd;
      overflow-y: auto;
    }
    .node {
      cursor: pointer;
    }
    .node:hover {
      opacity: 0.8;
    }
    .link {
      stroke: #999;
      stroke-opacity: 0.6;
    }
    h3 {
      margin-top: 0;
    }
    .info {
      margin-bottom: 0.5rem;
    }
    .error {
      color: red;
    }
  </style>
</head>
<body>
  <div id="container">
    <div id="graph"></div>
    <div id="details">
      <h3>Part Catalog Dependencies</h3>
      <p>Click on a node to view details.</p>
      <div id="node-details"></div>
    </div>
  </div>
  <script>
    // Данные графа
    const graph = ${jsonEncode(graph)};
    
    // Настройка визуализации
    const width = document.getElementById('graph').clientWidth;
    const height = document.getElementById('graph').clientHeight;
    
    const svg = d3.select('#graph')
      .append('svg')
      .attr('width', width)
      .attr('height', height);
    
    // Создаем контейнер для графа с возможностью масштабирования
    const g = svg.append('g');
    
    // Добавляем зум-поведение
    const zoom = d3.zoom()
      .scaleExtent([0.1, 4])
      .on('zoom', (event) => {
        g.attr('transform', event.transform);
      });
    
    svg.call(zoom);
    
    // Инициализируем силовую симуляцию
    const simulation = d3.forceSimulation(graph.nodes)
      .force('link', d3.forceLink(graph.links).id(d => d.id).distance(100))
      .force('charge', d3.forceManyBody().strength(-300))
      .force('center', d3.forceCenter(width / 2, height / 2))
      .force('x', d3.forceX(width / 2).strength(0.1))
      .force('y', d3.forceY(height / 2).strength(0.1));
    
    // Отрисовка связей
    const link = g.append('g')
      .attr('class', 'links')
      .selectAll('line')
      .data(graph.links)
      .enter()
      .append('line')
      .attr('class', 'link')
      .attr('stroke-width', d => Math.sqrt(d.value));
    
    // Отрисовка узлов
    const node = g.append('g')
      .attr('class', 'nodes')
      .selectAll('circle')
      .data(graph.nodes)
      .enter()
      .append('circle')
      .attr('class', 'node')
      .attr('r', d => 5 + Math.sqrt(d.types * 2))
      .attr('fill', d => d.hasErrors ? '#e74c3c' : '#3498db')
      .call(d3.drag()
        .on('start', dragstarted)
        .on('drag', dragged)
        .on('end', dragended));
    
    // Добавляем подписи к узлам
    const labels = g.append('g')
      .attr('class', 'labels')
      .selectAll('text')
      .data(graph.nodes)
      .enter()
      .append('text')
      .text(d => {
        const parts = d.id.split('/');
        return parts[parts.length - 1];
      })
      .attr('font-size', 10)
      .attr('dx', 12)
      .attr('dy', 4);
    
    // Показывать детали при клике на узел
    node.on('click', (event, d) => {
      d3.select('#node-details').html(`
        <div class="info"><strong>File:</strong> \${d.id}</div>
        <div class="info"><strong>Types:</strong> \${d.types}</div>
        \${d.hasErrors ? '<div class="error">Has errors</div>' : ''}
        <div class="info">
          <strong>Incoming:</strong> \${graph.links.filter(l => l.target === d).length} links
        </div>
        <div class="info">
          <strong>Outgoing:</strong> \${graph.links.filter(l => l.source === d).length} links
        </div>
      `);
    });
    
    // Обновление позиций при симуляции
    simulation.on('tick', () => {
      link
        .attr('x1', d => d.source.x)
        .attr('y1', d => d.source.y)
        .attr('x2', d => d.target.x)
        .attr('y2', d => d.target.y);
      
      node
        .attr('cx', d => d.x)
        .attr('cy', d => d.y);
      
      labels
        .attr('x', d => d.x)
        .attr('y', d => d.y);
    });
    
    // Функции для реализации перетаскивания
    function dragstarted(event) {
      if (!event.active) simulation.alphaTarget(0.3).restart();
      event.subject.fx = event.subject.x;
      event.subject.fy = event.subject.y;
    }
    
    function dragged(event) {
      event.subject.fx = event.x;
      event.subject.fy = event.y;
    }
    
    function dragended(event) {
      if (!event.active) simulation.alphaTarget(0);
      event.subject.fx = null;
      event.subject.fy = null;
    }
  </script>
</body>
</html>
  ''';

  await File(outputFile).writeAsString(html);
  print('Визуализация создана в файле: $outputFile');
}

/// Генерация текстового отчета о зависимостях
Future<void> generateTextReport(
    List<FileDependency> dependencies, String outputFile) async {
  final reportLines = <String>[];

  reportLines.add('# Отчет о зависимостях Part Catalog');
  reportLines.add('');
  reportLines.add('Дата создания: ${DateTime.now()}');
  reportLines.add('');
  reportLines.add('## Статистика');
  reportLines.add('');
  reportLines.add('- Всего файлов: ${dependencies.length}');

  final filesWithErrors = dependencies.where((d) => d.errors.isNotEmpty).length;
  reportLines.add('- Файлов с ошибками: $filesWithErrors');

  final totalImports = dependencies.fold(0, (sum, d) => sum + d.imports.length);
  reportLines.add('- Всего импортов: $totalImports');

  final importsByType = <String, int>{};
  for (var dep in dependencies) {
    for (var import in dep.imports) {
      final type = import['isPackage'] ? 'package' : 'relative';
      importsByType[type] = (importsByType[type] ?? 0) + 1;
    }
  }

  reportLines.add('- Импортов пакетов: ${importsByType['package'] ?? 0}');
  reportLines
      .add('- Относительных импортов: ${importsByType['relative'] ?? 0}');

  // Наиболее связанные файлы
  reportLines.add('');
  reportLines.add('## Наиболее зависимые файлы');
  reportLines.add('');

  final sortedByImports = List<FileDependency>.from(dependencies)
    ..sort((a, b) => b.imports.length.compareTo(a.imports.length));

  for (var i = 0; i < min(10, sortedByImports.length); i++) {
    final dep = sortedByImports[i];
    reportLines
        .add('${i + 1}. ${dep.relativePath} - ${dep.imports.length} импортов');
  }

  // Файлы без импортов
  final filesWithoutImports =
      dependencies.where((d) => d.imports.isEmpty).toList();
  if (filesWithoutImports.isNotEmpty) {
    reportLines.add('');
    reportLines.add('## Файлы без импортов');
    reportLines.add('');

    for (var dep in filesWithoutImports) {
      reportLines.add('- ${dep.relativePath}');
    }
  }

  // Файлы с ошибками
  if (filesWithErrors > 0) {
    reportLines.add('');
    reportLines.add('## Файлы с ошибками анализа');
    reportLines.add('');

    for (var dep in dependencies.where((d) => d.errors.isNotEmpty)) {
      reportLines.add('### ${dep.relativePath}');
      for (var error in dep.errors) {
        reportLines.add('- $error');
      }
      reportLines.add('');
    }
  }

  await File(outputFile).writeAsString(reportLines.join('\n'));
  print('Текстовый отчет создан в файле: $outputFile');
}

/// Вспомогательная функция для получения минимального значения
int min(int a, int b) => a < b ? a : b;

/// Основная функция анализатора зависимостей
void main() async {
  final rootDir = Directory('lib');
  final outputDir = Directory('analysis');

  // Создаем директорию для результатов анализа, если она не существует
  if (!await outputDir.exists()) {
    await outputDir.create();
  }

  print('Начинаем анализ зависимостей...');

  try {
    // Анализируем зависимости в проекте
    final dependencies =
        await processDirectoryForDependencies(rootDir, rootDir.path);
    print('Проанализировано ${dependencies.length} файлов.');

    // Создаем граф зависимостей
    final graph = createDependencyGraph(dependencies);

    // Сохраняем данные графа
    await File(path.join(outputDir.path, 'dependency_graph.json'))
        .writeAsString(JsonEncoder.withIndent('  ').convert(graph));

    // Генерируем HTML-визуализацию
    await generateVisualization(
        graph, path.join(outputDir.path, 'dependency_visualization.html'));

    // Генерируем текстовый отчет
    await generateTextReport(
        dependencies, path.join(outputDir.path, 'dependency_report.md'));

    print('Анализ зависимостей успешно завершен!');
    print('Результаты сохранены в директории: ${outputDir.path}');
    print('Открывайте HTML-файл в браузере для интерактивной визуализации.');
  } catch (e) {
    print('Ошибка при анализе зависимостей: $e');
  }
}
