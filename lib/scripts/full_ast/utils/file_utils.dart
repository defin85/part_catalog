import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;

import 'logger.dart';

/// Утилиты для работы с файлами исходного кода проекта
class FileUtils {
  /// Логгер для данного класса
  static final _logger = setupLogger('AST.FileUtils');

  /// Получает все Dart файлы из указанной директории и её поддиректорий
  ///
  /// [rootDir] - корневая директория для поиска
  /// [excludePaths] - пути, которые следует исключить из поиска
  static Future<List<File>> getDartFiles(
    Directory rootDir, {
    List<String> excludePaths = const ['build', '.dart_tool', '.git'],
  }) async {
    _logger.i('Поиск Dart файлов в ${rootDir.path}');

    if (!await rootDir.exists()) {
      _logger.e('Директория ${rootDir.path} не существует');
      throw FileSystemException('Директория не существует', rootDir.path);
    }

    final files = <File>[];

    try {
      await for (final entity
          in rootDir.list(recursive: true, followLinks: false)) {
        // Проверка, является ли путь исключенным
        if (excludePaths.any((excludedPath) =>
            entity.path
                .contains('${path.separator}$excludedPath${path.separator}') ||
            entity.path.endsWith('${path.separator}$excludedPath}'))) {
          continue;
        }

        if (entity is File && entity.path.endsWith('.dart')) {
          files.add(entity);
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Ошибка при поиске Dart файлов в ${rootDir.path}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }

    _logger.d('Найдено ${files.length} Dart файлов');
    return files;
  }

  /// Считывает содержимое файла в строку
  ///
  /// [file] - файл для чтения
  static Future<String> readFileAsString(File file) async {
    try {
      return await file.readAsString();
    } catch (e, stackTrace) {
      _logger.e('Ошибка при чтении файла ${file.path}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Записывает данные в файл с созданием промежуточных директорий
  ///
  /// [filePath] - путь для записи файла
  /// [content] - содержимое для записи
  static Future<File> writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      // Создаем родительские директории если их нет
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      return await file.writeAsString(content);
    } catch (e, stackTrace) {
      _logger.e('Ошибка при записи файла $filePath',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает или очищает директорию
  ///
  /// [dir] - директория для создания/очистки
  /// [clean] - если true, существующая директория будет очищена
  static Future<Directory> createOrCleanDir(Directory dir,
      {bool clean = false}) async {
    try {
      if (await dir.exists()) {
        if (clean) {
          await dir.delete(recursive: true);
          await dir.create(recursive: true);
        }
      } else {
        await dir.create(recursive: true);
      }
      return dir;
    } catch (e, stackTrace) {
      _logger.e('Ошибка при создании/очистке директории ${dir.path}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Возвращает относительный путь к файлу от корневой директории
  ///
  /// [file] - файл, для которого нужен относительный путь
  /// [rootDir] - корневая директория
  static String getRelativePath(File file, Directory rootDir) {
    return path.relative(file.path, from: rootDir.path);
  }

  /// Определяет, принадлежит ли файл к тестам
  ///
  /// [filePath] - путь к файлу
  static bool isTestFile(String filePath) {
    return filePath.contains('${path.separator}test${path.separator}') ||
        filePath.contains('_test.dart') ||
        filePath.contains('${path.separator}integration_test${path.separator}');
  }

  /// Определяет, принадлежит ли файл к сгенерированному коду
  ///
  /// [filePath] - путь к файлу
  static bool isGeneratedFile(String filePath) {
    return filePath.endsWith('.g.dart') ||
        filePath.endsWith('.freezed.dart') ||
        filePath.endsWith('.gr.dart') ||
        filePath.endsWith('.mocks.dart');
  }

  /// Получает имя пакета из импорта
  ///
  /// [importUri] - URI импорта для анализа
  static String? getPackageNameFromImport(String importUri) {
    if (importUri.startsWith('package:')) {
      final parts = importUri.substring('package:'.length).split('/');
      if (parts.isNotEmpty) {
        return parts.first;
      }
    }
    return null;
  }

  /// Проверяет, является ли импорт внутренним для проекта
  ///
  /// [importUri] - URI импорта для проверки
  /// [projectPackageName] - имя пакета проекта
  static bool isInternalImport(String importUri, String projectPackageName) {
    if (importUri.startsWith('dart:') || importUri.startsWith('package:')) {
      return importUri.startsWith('package:$projectPackageName/');
    }
    // Относительные импорты всегда внутренние
    return importUri.startsWith('./') ||
        importUri.startsWith('../') ||
        !importUri.contains(':');
  }

  /// Получает список файлов с определенными расширениями из директории
  ///
  /// [rootDir] - корневая директория для поиска
  /// [extensions] - список расширений файлов для поиска
  /// [excludePaths] - пути, которые следует исключить из поиска
  static Future<List<File>> getFilesByExtensions(
    Directory rootDir, {
    required List<String> extensions,
    List<String> excludePaths = const ['build', '.dart_tool', '.git'],
  }) async {
    _logger.i('Поиск файлов с расширениями $extensions в ${rootDir.path}');

    if (!await rootDir.exists()) {
      _logger.e('Директория ${rootDir.path} не существует');
      throw FileSystemException('Директория не существует', rootDir.path);
    }

    final files = <File>[];

    try {
      await for (final entity
          in rootDir.list(recursive: true, followLinks: false)) {
        // Проверка, является ли путь исключенным
        if (excludePaths.any((excludedPath) =>
            entity.path
                .contains('${path.separator}$excludedPath${path.separator}') ||
            entity.path.endsWith('${path.separator}$excludedPath}'))) {
          continue;
        }

        if (entity is File &&
            extensions.any((ext) => entity.path.endsWith(ext))) {
          files.add(entity);
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Ошибка при поиске файлов в ${rootDir.path}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }

    _logger.d('Найдено ${files.length} файлов с указанными расширениями');
    return files;
  }

  /// Находит файл pubspec.yaml в проекте, начиная с указанной директории
  ///
  /// [startDir] - директория для начала поиска
  /// [maxDepth] - максимальная глубина поиска
  static Future<File?> findPubspecFile(Directory startDir,
      {int maxDepth = 5}) async {
    var currentDir = startDir;
    var depth = 0;

    while (depth < maxDepth) {
      final pubspecFile = File(path.join(currentDir.path, 'pubspec.yaml'));
      if (await pubspecFile.exists()) {
        return pubspecFile;
      }

      final parentDir = currentDir.parent;
      if (parentDir.path == currentDir.path) {
        // Достигли корня файловой системы
        break;
      }

      currentDir = parentDir;
      depth++;
    }

    return null;
  }

  /// Получает информацию о размере файла в различных единицах измерения
  ///
  /// [file] - файл для анализа
  static Future<Map<String, num>> getFileSizeInfo(File file) async {
    final sizeInBytes = await file.length();

    return {
      'bytes': sizeInBytes,
      'kb': sizeInBytes / 1024,
      'mb': sizeInBytes / (1024 * 1024),
    };
  }
}
