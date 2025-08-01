#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

/// Скрипт для запуска всех тестов с детальной отчетностью
class TestRunner {
  static const String testDir = 'test/';
  
  /// Запускает все тесты
  static Future<void> runAllTests() async {
    // ignore: avoid_print
    print('🧪 Запуск всех тестов...\n');
    
    final startTime = DateTime.now();
    
    try {
      // Запускаем тесты с подробным выводом
      final result = await Process.run(
        'flutter',
        [
          'test',
          '--reporter=expanded',
          '--coverage',
          '--test-randomize-ordering-seed=random',
        ],
        workingDirectory: '.',
      );
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      // ignore: avoid_print
      print('\n${'='*50}');
      // ignore: avoid_print
      print('📊 РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ');
      // ignore: avoid_print
      print('='*50);
      // ignore: avoid_print
      print('Время выполнения: ${duration.inSeconds}с');
      // ignore: avoid_print
      print('Код завершения: ${result.exitCode}');
      
      if (result.exitCode == 0) {
        // ignore: avoid_print
        print('✅ Все тесты прошли успешно!');
        await _generateCoverageReport();
      } else {
        // ignore: avoid_print
        print('❌ Некоторые тесты провалились');
        // ignore: avoid_print
        print('\nВывод ошибок:');
        // ignore: avoid_print
        print(result.stderr);
      }
      
      // ignore: avoid_print
      print('\nВывод тестов:');
      // ignore: avoid_print
      print(result.stdout);
      
    } catch (e) {
      // ignore: avoid_print
      print('❌ Ошибка при запуске тестов: $e');
      exit(1);
    }
  }
  
  /// Запускает тесты по категориям
  static Future<void> runTestsByCategory() async {
    final categories = [
      TestCategory('Unit Tests', 'test/unit/'),
      TestCategory('Widget Tests', 'test/widgets/'),
      TestCategory('Integration Tests', 'test/integration/'),
    ];
    
    for (final category in categories) {
      await _runCategoryTests(category);
    }
  }
  
  /// Запускает тесты для конкретной категории
  static Future<void> _runCategoryTests(TestCategory category) async {
    // ignore: avoid_print
    print('\n🏷️  Запуск ${category.name}...');
    
    final categoryDir = Directory(category.path);
    if (!categoryDir.existsSync()) {
      // ignore: avoid_print
      print('⚠️  Директория ${category.path} не найдена');
      return;
    }
    
    final testFiles = categoryDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('_test.dart'))
        .toList();
    
    if (testFiles.isEmpty) {
      // ignore: avoid_print
      print('ℹ️  Тесты в ${category.path} не найдены');
      return;
    }
    
    // ignore: avoid_print
    print('📁 Найдено ${testFiles.length} тестовых файлов');
    
    try {
      final result = await Process.run(
        'flutter',
        ['test', category.path, '--reporter=compact'],
        workingDirectory: '.',
      );
      
      if (result.exitCode == 0) {
        // ignore: avoid_print
        print('✅ ${category.name}: УСПЕШНО');
      } else {
        // ignore: avoid_print
        print('❌ ${category.name}: ПРОВАЛЕНО');
        // ignore: avoid_print
        print('Ошибки:\n${result.stderr}');
      }
      
    } catch (e) {
      // ignore: avoid_print
      print('❌ Ошибка при запуске ${category.name}: $e');
    }
  }
  
  /// Генерирует отчет о покрытии
  static Future<void> _generateCoverageReport() async {
    // ignore: avoid_print
    print('\n📈 Генерация отчета о покрытии...');
    
    try {
      // Генерируем HTML отчет
      final result = await Process.run(
        'genhtml',
        [
          'coverage/lcov.info',
          '-o',
          'coverage/html',
        ],
        workingDirectory: '.',
      );
      
      if (result.exitCode == 0) {
        // ignore: avoid_print
        print('✅ Отчет о покрытии создан: coverage/html/index.html');
      } else {
        // ignore: avoid_print
        print('⚠️  Не удалось создать HTML отчет (genhtml не установлен?)');
        await _parseBasicCoverage();
      }
      
    } catch (e) {
      // ignore: avoid_print
      print('⚠️  Ошибка при генерации отчета: $e');
      await _parseBasicCoverage();
    }
  }
  
  /// Парсит базовую информацию о покрытии
  static Future<void> _parseBasicCoverage() async {
    final coverageFile = File('coverage/lcov.info');
    if (!coverageFile.existsSync()) {
      // ignore: avoid_print
      print('⚠️  Файл покрытия не найден');
      return;
    }
    
    try {
      final content = await coverageFile.readAsString();
      final lines = content.split('\n');
      
      int totalLines = 0;
      int coveredLines = 0;
      
      for (final line in lines) {
        if (line.startsWith('LF:')) {
          totalLines += int.parse(line.substring(3));
        } else if (line.startsWith('LH:')) {
          coveredLines += int.parse(line.substring(3));
        }
      }
      
      if (totalLines > 0) {
        final percentage = (coveredLines / totalLines * 100).toStringAsFixed(1);
        // ignore: avoid_print
        print('📊 Покрытие кода: $percentage% ($coveredLines/$totalLines строк)');
      }
      
    } catch (e) {
      // ignore: avoid_print
      print('⚠️  Ошибка при парсинге покрытия: $e');
    }
  }
  
  /// Запускает тесты с отслеживанием производительности
  static Future<void> runPerformanceTests() async {
    // ignore: avoid_print
    print('\n⚡ Запуск тестов производительности...');
    
    final performanceTests = [
      'test/performance/',
      'test/widgets/**/performance_*.dart',
    ];
    
    for (final testPattern in performanceTests) {
      final result = await Process.run(
        'flutter',
        [
          'test',
          testPattern,
          '--reporter=json',
          '--concurrency=1', // Запускаем последовательно для точных измерений
        ],
        workingDirectory: '.',
      );
      
      if (result.exitCode == 0) {
        _parsePerformanceResults(result.stdout);
      }
    }
  }
  
  /// Парсит результаты тестов производительности
  static void _parsePerformanceResults(String jsonOutput) {
    try {
      final lines = jsonOutput.split('\n');
      final slowTests = <String>[];
      
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        
        final json = jsonDecode(line);
        if (json['type'] == 'test' && json['result'] == 'success') {
          final time = json['time'] as int?;
          if (time != null && time > 5000) { // Тесты медленнее 5 секунд
            slowTests.add('${json['name']}: ${time}ms');
          }
        }
      }
      
      if (slowTests.isNotEmpty) {
        // ignore: avoid_print
        print('🐌 Медленные тесты:');
        for (final test in slowTests) {
          // ignore: avoid_print
          print('  - $test');
        }
      } else {
        // ignore: avoid_print
        print('✅ Все тесты выполняются быстро');
      }
      
    } catch (e) {
      // ignore: avoid_print
      print('⚠️  Ошибка при парсинге результатов: $e');
    }
  }
  
  /// Запускает только проваленные тесты
  static Future<void> runFailedTests() async {
    // ignore: avoid_print
    print('\n🔄 Повторный запуск проваленных тестов...');
    
    // Запускаем с опцией --reporter=json для получения списка проваленных тестов
    final result = await Process.run(
      'flutter',
      ['test', '--reporter=json'],
      workingDirectory: '.',
    );
    
    if (result.exitCode == 0) {
      // ignore: avoid_print
      print('✅ Все тесты прошли успешно!');
      return;
    }
    
    final failedTests = <String>[];
    final lines = result.stdout.toString().split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      try {
        final json = jsonDecode(line);
        if (json['type'] == 'test' && json['result'] == 'error') {
          failedTests.add(json['url']);
        }
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
    
    if (failedTests.isNotEmpty) {
      // ignore: avoid_print
      print('🎯 Найдено ${failedTests.length} проваленных тестов');
      
      for (final testFile in failedTests) {
        // ignore: avoid_print
        print('\n🧪 Повторный запуск: $testFile');
        
        final retryResult = await Process.run(
          'flutter',
          ['test', testFile, '--reporter=expanded'],
          workingDirectory: '.',
        );
        
        if (retryResult.exitCode == 0) {
          // ignore: avoid_print
          print('✅ $testFile: ИСПРАВЛЕН');
        } else {
          // ignore: avoid_print
          print('❌ $testFile: ВСЕ ЕЩЕ ПРОВАЛЕН');
          // ignore: avoid_print
          print(retryResult.stdout);
        }
      }
    }
  }
  
  /// Очищает кэш тестов
  static Future<void> cleanTestCache() async {
    // ignore: avoid_print
    print('🧹 Очистка кэша тестов...');
    
    final cacheDirectories = [
      '.dart_tool/test/',
      'coverage/',
      'test/.test_coverage.dart',
    ];
    
    for (final dir in cacheDirectories) {
      final directory = Directory(dir);
      if (directory.existsSync()) {
        await directory.delete(recursive: true);
        // ignore: avoid_print
        print('🗑️  Удалено: $dir');
      }
    }
    
    // ignore: avoid_print
    print('✅ Кэш очищен');
  }
}

class TestCategory {
  final String name;
  final String path;
  
  TestCategory(this.name, this.path);
}

void main(List<String> args) async {
  if (args.isEmpty) {
    await TestRunner.runAllTests();
    return;
  }
  
  switch (args[0]) {
    case '--categories':
      await TestRunner.runTestsByCategory();
      break;
    case '--performance':
      await TestRunner.runPerformanceTests();
      break;
    case '--failed':
      await TestRunner.runFailedTests();
      break;
    case '--clean':
      await TestRunner.cleanTestCache();
      break;
    case '--help':
      _printHelp();
      break;
    default:
      // ignore: avoid_print
      print('❌ Неизвестная команда: ${args[0]}');
      _printHelp();
      exit(1);
  }
}

void _printHelp() {
  // ignore: avoid_print
  print('''
🧪 Test Runner - Утилита для запуска тестов

Использование:
  dart test/run_all_tests.dart [команда]

Команды:
  (без команды)  Запустить все тесты
  --categories   Запустить тесты по категориям
  --performance  Запустить тесты производительности
  --failed       Повторно запустить проваленные тесты
  --clean        Очистить кэш тестов
  --help         Показать эту справку

Примеры:
  dart test/run_all_tests.dart
  dart test/run_all_tests.dart --categories
  dart test/run_all_tests.dart --performance
''');
}