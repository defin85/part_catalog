import 'dart:io';
import 'dart:math' as math;

import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

/// Основные пути документации
const String docsDir = 'docs';
const String outputFile = '.github/copilot-instructions.md';
const int maxFileSizeBytes =
    1 * 1024 * 1024; // Ограничение размера файла (1 MB)

/// Логгер для скрипта с настройкой вывода без стека вызовов
final Logger _logger = Logger(
  printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 90,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart),
);

/// Структура приоритетов разделов
/// Определяет порядок, в котором разделы будут отображаться в документации
final Map<String, int> _sectionPriorities = {
  'README.md': 0,
  'architecture/': 10,
  'modules/': 20,
  'guides/': 30,
  'references/': 40,
};

/// Приоритеты для конкретных файлов внутри разделов
final Map<String, int> _filePriorities = {
  'overview.md': 0,
  'database_schema.md': 10,
  'api_integration.md': 20,
  'clients.md': 0,
  'vehicles.md': 10,
  'orders.md': 20,
  'suppliers/overview.md': 30,
  'suppliers/direct_api.md': 31,
  'suppliers/proxy_server.md': 32,
  'code_style.md': 0,
  'testing.md': 10,
  'error_handling.md': 20,
  'async_programming.md': 30,
};

/// Список исключаемых файлов и директорий
final List<String> _excludedPaths = [
  'references/code_examples/', // Примеры кода обрабатываются отдельно
  '.git',
  '.github',
  'assets/', // Исключаем папки с изображениями
  'node_modules/',
];

/// Максимальное количество кодовых примеров для включения
const int maxCodeExamples = 5;

Future<void> main() async {
  _logger.i('Начало компиляции документации для GitHub Copilot');

  // Динамически определяем список файлов для компиляции
  final List<String> sectionOrder = await _discoverDocumentationFiles();
  _logger.i('Найдено ${sectionOrder.length} файлов документации');

  final buffer = StringBuffer();

  // Заголовок файла инструкций для Copilot
  buffer.writeln('# Part Catalog - Инструкции для GitHub Copilot');
  buffer.writeln(
      '\n> Это автоматически сгенерированный файл из документации проекта. Не редактируйте его напрямую.\n');
  buffer.writeln('## Содержание\n');

  // Формируем оглавление
  int sectionIndex = 1;
  for (final section in sectionOrder) {
    final file = File(path.join(docsDir, section));
    if (!file.existsSync()) {
      _logger.w('Файл не найден: ${path.join(docsDir, section)}');
      continue;
    }

    final firstLine = file.readAsLinesSync().firstWhere(
        (line) => line.startsWith('# '),
        orElse: () => '# ${path.basenameWithoutExtension(section)}');

    final title = firstLine.replaceFirst('# ', '');
    buffer.writeln(
        '${sectionIndex++}. [$title](#${title.toLowerCase().replaceAll(' ', '-')})');
  }

  buffer.writeln('\n---\n');

  // Добавляем содержимое каждого файла
  for (final section in sectionOrder) {
    final file = File(path.join(docsDir, section));
    if (!file.existsSync()) continue;

    _logger.d('Обработка файла: ${path.join(docsDir, section)}');

    final content = file.readAsStringSync();

    // Защищаем блоки кода от модификации
    final contentWithProtectedCodeBlocks = _protectCodeBlocks(content);
    final codeBlocks =
        contentWithProtectedCodeBlocks['codeBlocks'] as List<String>;
    final protectedContent =
        contentWithProtectedCodeBlocks['content'] as String;

    // Преобразуем заголовок первого уровня во второй
    final modifiedContent = protectedContent
        .replaceFirstMapped(RegExp(r'^# .*$', multiLine: true), (Match match) {
      return '## ${match.group(0)!.substring(2)}';
    });

    // Повышаем уровень всех других заголовков
    String finalContent = modifiedContent;
    finalContent = finalContent.replaceAll('\n## ', '\n### ');
    finalContent = finalContent.replaceAll('\n### ', '\n#### ');
    finalContent = finalContent.replaceAll('\n#### ', '\n##### ');
    finalContent = finalContent.replaceAll('\n##### ', '\n###### ');

    // Исправляем заголовок первого уровня, который мы изменили
    finalContent = finalContent.replaceFirst(RegExp(r'^## '), '## ');

    // Восстанавливаем блоки кода
    finalContent = _restoreCodeBlocks(finalContent, codeBlocks);

    // Заменяем относительные ссылки на документацию
    final processedContent = _processRelativeLinks(finalContent, section);

    // Добавляем метаданные о файле для информации
    buffer.writeln('<!-- Source: ${path.join(docsDir, section)} -->');
    buffer.writeln(processedContent);
    buffer.writeln('\n---\n');
  }

  // Добавляем примеры кода с ограничением количества
  try {
    await _includeCodeExamples(buffer);
  } catch (e) {
    _logger.w('Ошибка при добавлении примеров кода: $e');
  }

  // Проверяем размер сгенерированного файла
  final totalCharacters = buffer.length;
  final estimatedSizeBytes =
      totalCharacters * 2; // Приблизительный размер в байтах (UTF-16)

  if (estimatedSizeBytes > maxFileSizeBytes) {
    _logger.w(
        'Сгенерированный файл слишком большой: ${(estimatedSizeBytes / 1024).toStringAsFixed(2)} KB. '
        'Это может превышать ограничения контекста Copilot.');

    // Анализируем размеры разделов
    final sectionSizes = <String, int>{};
    for (final section in sectionOrder) {
      final file = File(path.join(docsDir, section));
      if (file.existsSync()) {
        sectionSizes[section] = file.readAsBytesSync().length;
      }
    }

    // Выводим топ-5 самых больших секций
    final sortedSections = sectionSizes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _logger.i('Самые большие секции:');
    for (int i = 0; i < math.min(5, sortedSections.length); i++) {
      _logger.i(
          '${i + 1}. ${sortedSections[i].key}: ${(sortedSections[i].value / 1024).toStringAsFixed(1)} KB');
    }

    // Добавляем предупреждение в файл
    buffer.writeln('\n## ⚠️ Примечание о размере\n');
    buffer.writeln(
        '> Этот файл инструкций содержит ${(estimatedSizeBytes / 1024).toStringAsFixed(2)} KB данных, '
        'что может превышать ограничения контекста Copilot. Это может привести к тому, '
        'что некоторые разделы документации не будут учтены при генерации кода.');
  }

  // Записываем результат в файл инструкций Copilot
  final outputDir = Directory(path.dirname(outputFile));
  if (!outputDir.existsSync()) {
    _logger.i('Создание директории: ${path.dirname(outputFile)}');
    try {
      outputDir.createSync(recursive: true);
    } catch (e) {
      _logger.e('Ошибка при создании директории: $e');
      exitCode = 1;
      return;
    }
  }

  // Улучшенная обработка ошибок при записи файла
  try {
    File(outputFile).writeAsStringSync(buffer.toString());
    _logger.i('Файл инструкций для Copilot успешно создан: $outputFile '
        '(${(buffer.length * 2 / 1024).toStringAsFixed(2)} KB)');
  } catch (e, stack) {
    _logger.e('Ошибка при записи файла: $e', error: e, stackTrace: stack);
    exitCode = 1;
    return;
  }

  _logger.i('Компиляция завершена');
}

/// Динамически определяет список файлов Markdown для компиляции
Future<List<String>> _discoverDocumentationFiles() async {
  final List<String> result = [];
  final docsDirectory = Directory(docsDir);

  if (!docsDirectory.existsSync()) {
    _logger.e('Директория документации не существует: $docsDir');
    return result;
  }

  // Получаем все .md файлы рекурсивно
  await for (final entity in docsDirectory.list(recursive: true)) {
    // Проверяем только файлы с расширением .md
    if (entity is File && path.extension(entity.path) == '.md') {
      final relativePath = path.relative(entity.path, from: docsDir);

      // Проверяем, не находится ли файл в исключенных директориях
      if (_excludedPaths
          .any((excludedPath) => relativePath.startsWith(excludedPath))) {
        _logger.d('Пропускаем исключенный файл: $relativePath');
        continue;
      }

      result.add(relativePath);
    }
  }

  // Сортируем файлы по приоритетам разделов и внутренним приоритетам
  result.sort((a, b) {
    // Сначала определяем раздел для каждого файла
    final sectionA = _sectionPriorities.keys.firstWhere(
      (section) => a.startsWith(section),
      orElse: () => '',
    );

    final sectionB = _sectionPriorities.keys.firstWhere(
      (section) => b.startsWith(section),
      orElse: () => '',
    );

    // Если файлы из разных разделов, сортируем по приоритету раздела
    if (sectionA != sectionB) {
      return (_sectionPriorities[sectionA] ?? 100) -
          (_sectionPriorities[sectionB] ?? 100);
    }

    // Если файлы из одного раздела, используем приоритет файла
    final fileA = a.replaceFirst(sectionA, '');
    final fileB = b.replaceFirst(sectionB, '');

    final priorityA =
        _filePriorities[fileA] ?? _filePriorities[path.basename(fileA)] ?? 100;
    final priorityB =
        _filePriorities[fileB] ?? _filePriorities[path.basename(fileB)] ?? 100;

    return priorityA - priorityB;
  });

  _logger.d('Отсортированный список файлов: $result');
  return result;
}

/// Защищает блоки кода от модификации при преобразовании заголовков
Map<String, dynamic> _protectCodeBlocks(String content) {
  final codeBlockPattern = RegExp(r'```[^\n]*\n[\s\S]*?\n```', multiLine: true);
  final codeBlocks = <String>[];

  // Заменяем блоки кода на маркеры
  final protectedContent = content.replaceAllMapped(codeBlockPattern, (match) {
    final block = match.group(0)!;
    codeBlocks.add(block);
    return '{{CODE_BLOCK_${codeBlocks.length - 1}}}';
  });

  return {
    'content': protectedContent,
    'codeBlocks': codeBlocks,
  };
}

/// Восстанавливает блоки кода после преобразования заголовков
String _restoreCodeBlocks(String content, List<String> codeBlocks) {
  String result = content;
  for (int i = 0; i < codeBlocks.length; i++) {
    result = result.replaceFirst('{{CODE_BLOCK_$i}}', codeBlocks[i]);
  }
  return result;
}

/// Обрабатывает относительные ссылки в документации
String _processRelativeLinks(String content, String currentFile) {
  final currentDir = path.dirname(currentFile);

  // Заменяем относительные ссылки на Copilot-специфичные якоря
  final linkPattern = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
  return content.replaceAllMapped(linkPattern, (match) {
    final linkText = match.group(1)!;
    final linkTarget = match.group(2)!;

    // Пропускаем внешние ссылки и якоря
    if (linkTarget.startsWith('http') || linkTarget.startsWith('#')) {
      return match.group(0)!;
    }

    try {
      // Преобразуем относительный путь в абсолютный
      final resolvedPath = path.normalize(path.join(currentDir, linkTarget));
      final relativePath = path.relative(resolvedPath, from: docsDir);

      // Создаем якорь для внутренней навигации
      final anchorName = path
          .basenameWithoutExtension(relativePath)
          .toLowerCase()
          .replaceAll(' ', '-');

      // Явное возвращение строки
      return '[$linkText](#$anchorName)';
    } catch (e) {
      _logger.w('Ошибка при обработке ссылки $linkTarget: $e');
      // Явное возвращение строки
      return match.group(0)!;
    }
  });
}

/// Добавляет примеры кода из директории references/code_examples
Future<void> _includeCodeExamples(StringBuffer buffer) async {
  final codeExamplesDir =
      Directory(path.join(docsDir, 'references/code_examples'));
  if (!codeExamplesDir.existsSync()) {
    _logger.w('Директория примеров кода не найдена: ${codeExamplesDir.path}');
    return;
  }

  buffer.writeln('\n## Примеры кода\n');
  buffer.writeln('> Ниже приведены наиболее важные примеры кода из проекта\n');

  final codeFiles = codeExamplesDir
      .listSync()
      .whereType<File>()
      .where((f) => ['.dart', '.yaml', '.md'].contains(path.extension(f.path)))
      .toList();

  if (codeFiles.isEmpty) {
    buffer.writeln('Примеры кода отсутствуют.');
    return;
  }

  // Ограничиваем количество примеров
  final filesToInclude = codeFiles.take(maxCodeExamples).toList();

  for (final file in filesToInclude) {
    final fileName = path.basename(file.path);
    final fileExtension = path.extension(file.path).replaceFirst('.', '');
    final fileContent = await file.readAsString();

    buffer.writeln('### $fileName\n');
    buffer.writeln('```$fileExtension');
    buffer.writeln(fileContent);
    buffer.writeln('```\n');
  }

  if (codeFiles.length > maxCodeExamples) {
    buffer.writeln(
        '\n> Показаны только первые $maxCodeExamples из ${codeFiles.length} примеров кода\n');
  }
}
