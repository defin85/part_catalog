import 'dart:io';
import 'package:path/path.dart' as path;

/// Генератор тестов для виджетов
class TestGenerator {
  static const String _widgetTestTemplate = '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/{widget_import_path}';
import '../helpers/base_widget_test.dart';

class {widget_class_name}Test extends BaseWidgetTest {
  @override
  String get widgetName => '{widget_class_name}';

  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return {widget_class_name}(
      // Добавьте необходимые параметры
    );
  }

  @override
  List<WidgetTestState> getTestStates() {
    return [
      // Добавьте тестовые состояния
    ];
  }

  @override
  List<WidgetTestInteraction> getTestInteractions() {
    return [
      // Добавьте тестовые взаимодействия
    ];
  }
}

void main() {
  group('{widget_class_name} Widget Tests', () {
    late {widget_class_name}Test testSuite;

    setUp(() {
      testSuite = {widget_class_name}Test();
    });

    testSuite.runAllTests();

    // Добавьте дополнительные специфичные тесты
    testWidgets('should have specific behavior', (tester) async {
      await tester.pumpTestApp(
        testSuite.createWidget(),
        overrides: testSuite.providerOverrides,
      );

      // Добавьте ваши проверки
    });
  });
}
''';

  static const String _screenTestTemplate = '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/{screen_import_path}';
import '../helpers/base_widget_test.dart';

class {screen_class_name}Test extends BaseScreenTest {
  @override
  String get widgetName => '{screen_class_name}';

  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return {screen_class_name}(
      // Добавьте необходимые параметры
    );
  }

  @override
  List<Override> get providerOverrides => [
    // Добавьте переопределения провайдеров
  ];

  @override
  List<WidgetTestState> getTestStates() {
    return [
      WidgetTestState(
        name: 'loading state',
        verify: (tester) async {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      ),
      WidgetTestState(
        name: 'loaded state',
        verify: (tester) async {
          expect(find.byType({screen_class_name}), findsOneWidget);
        },
      ),
      WidgetTestState(
        name: 'error state',
        verify: (tester) async {
          expect(find.textContaining('Error'), findsOneWidget);
        },
      ),
    ];
  }

  @override
  List<WidgetTestInteraction> getTestInteractions() {
    return [
      // Добавьте тестовые взаимодействия
    ];
  }

  @override
  void runLoadingTests() {
    group('\$widgetName Loading Tests', () {
      testWidgets('should show loading indicator', (tester) async {
        await tester.pumpTestApp(
          createWidget(),
          overrides: providerOverrides,
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  }

  @override
  void runErrorTests() {
    group('\$widgetName Error Tests', () {
      testWidgets('should show error message', (tester) async {
        // Добавьте тест для обработки ошибок
      });
    });
  }
}

void main() {
  group('{screen_class_name} Widget Tests', () {
    late {screen_class_name}Test testSuite;

    setUp(() {
      testSuite = {screen_class_name}Test();
    });

    testSuite.runAllTests();
  });
}
''';

  static const String _formTestTemplate = '''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/{form_import_path}';
import '../helpers/base_widget_test.dart';

class {form_class_name}Test extends BaseFormTest {
  @override
  String get widgetName => '{form_class_name}';

  @override
  Widget createWidget({Map<String, dynamic>? props}) {
    return {form_class_name}(
      // Добавьте необходимые параметры
    );
  }

  @override
  List<FormValidationTest> getValidationTests() {
    return [
      FormValidationTest(
        fieldName: 'required field',
        perform: (tester) async {
          // Оставляем поле пустым и валидируем
          final form = Form.of(tester.element(find.byType(Form)));
          form.validate();
          await tester.pump();
        },
        verify: (tester) async {
          expect(find.textContaining('обязательно'), findsOneWidget);
        },
      ),
    ];
  }

  @override
  Future<void> fillValidForm(WidgetTester tester) async {
    // Заполните форму валидными данными
  }

  @override
  Future<void> fillInvalidForm(WidgetTester tester) async {
    // Заполните форму невалидными данными
  }

  @override
  Future<void> submitForm(WidgetTester tester) async {
    final submitButton = find.text('Сохранить');
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
  }

  @override
  Future<void> verifySuccessfulSubmission(WidgetTester tester) async {
    expect(find.textContaining('успешно'), findsOneWidget);
  }

  @override
  Future<void> verifyFailedSubmission(WidgetTester tester) async {
    expect(find.textContaining('ошибка'), findsOneWidget);
  }
}

void main() {
  group('{form_class_name} Widget Tests', () {
    late {form_class_name}Test testSuite;

    setUp(() {
      testSuite = {form_class_name}Test();
    });

    testSuite.runAllTests();
  });
}
''';

  /// Генерирает тест для виджета
  static Future<void> generateWidgetTest({
    required String widgetPath,
    required String outputPath,
    String? testType,
  }) async {
    final widgetFile = File(widgetPath);
    if (!widgetFile.existsSync()) {
      throw Exception('Widget file not found: $widgetPath');
    }

    final widgetContent = await widgetFile.readAsString();
    final widgetClassName = _extractClassName(widgetContent);
    final widgetImportPath = _getImportPath(widgetPath);

    String template;
    switch (testType?.toLowerCase()) {
      case 'screen':
        template = _screenTestTemplate;
        template = template.replaceAll('{screen_class_name}', widgetClassName);
        template = template.replaceAll('{screen_import_path}', widgetImportPath);
        break;
      case 'form':
        template = _formTestTemplate;
        template = template.replaceAll('{form_class_name}', widgetClassName);
        template = template.replaceAll('{form_import_path}', widgetImportPath);
        break;
      default:
        template = _widgetTestTemplate;
        template = template.replaceAll('{widget_class_name}', widgetClassName);
        template = template.replaceAll('{widget_import_path}', widgetImportPath);
    }

    final testFile = File(outputPath);
    await testFile.create(recursive: true);
    await testFile.writeAsString(template);

    // Generated test file: $outputPath
  }

  /// Генерирует тесты для всех виджетов в директории
  static Future<void> generateAllWidgetTests(String sourceDir, String testDir) async {
    final sourceDirectory = Directory(sourceDir);
    if (!sourceDirectory.existsSync()) {
      throw Exception('Source directory not found: $sourceDir');
    }

    final widgetFiles = sourceDirectory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => _isWidgetFile(file.path));

    for (final widgetFile in widgetFiles) {
      final relativePath = path.relative(widgetFile.path, from: sourceDir);
      final testPath = path.join(testDir, relativePath.replaceAll('.dart', '_test.dart'));
      
      // Определяем тип теста на основе содержимого и пути
      String? testType;
      if (relativePath.contains('screen')) {
        testType = 'screen';
      } else if (relativePath.contains('form')) {
        testType = 'form';
      }

      await generateWidgetTest(
        widgetPath: widgetFile.path,
        outputPath: testPath,
        testType: testType,
      );
    }
  }

  /// Анализирует сложность виджета
  static WidgetComplexity analyzeWidgetComplexity(String widgetPath) {
    final file = File(widgetPath);
    if (!file.existsSync()) return WidgetComplexity.unknown;

    final content = file.readAsStringSync();
    
    int complexity = 0;
    
    // Сложные паттерны
    final complexPatterns = [
      'StatefulWidget',
      'ConsumerWidget',
      'ConsumerStatefulWidget',
      'LayoutBuilder',
      'MediaQuery',
      'StreamBuilder',
      'FutureBuilder',
      'Provider',
      'Riverpod',
      'Navigator',
      'showDialog',
      'AnimationController',
    ];

    for (final pattern in complexPatterns) {
      if (content.contains(pattern)) complexity += 2;
    }

    // Средние паттерны
    final mediumPatterns = [
      'StatelessWidget',
      'ListView',
      'GridView',
      'Column',
      'Row',
      'Stack',
      'Form',
      'TextFormField',
      'GestureDetector',
      'InkWell',
    ];

    for (final pattern in mediumPatterns) {
      if (content.contains(pattern)) complexity += 1;
    }

    // Дополнительная сложность по размеру файла
    final lines = content.split('\n').length;
    if (lines > 500) {
      complexity += 3;
    } else if (lines > 200) {
      complexity += 2;
    } else if (lines > 100) {
      complexity += 1;
    }

    if (complexity >= 8) {
      return WidgetComplexity.complex;
    }
    if (complexity >= 4) {
      return WidgetComplexity.medium;
    }
    if (complexity >= 1) {
      return WidgetComplexity.simple;
    }
    return WidgetComplexity.trivial;
  }

  /// Создает отчет о покрытии тестами
  static Future<TestCoverageReport> generateCoverageReport(
    String sourceDir,
    String testDir,
  ) async {
    final sourceFiles = Directory(sourceDir)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart') && _isWidgetFile(file.path))
        .toList();

    // Убираем неиспользуемую переменную testFiles

    final coverage = <String, TestCoverageItem>{};

    for (final sourceFile in sourceFiles) {
      final relativePath = path.relative(sourceFile.path, from: sourceDir);
      final expectedTestPath = path.join(testDir, relativePath.replaceAll('.dart', '_test.dart'));
      final hasTest = File(expectedTestPath).existsSync();
      final complexity = analyzeWidgetComplexity(sourceFile.path);

      coverage[relativePath] = TestCoverageItem(
        sourcePath: sourceFile.path,
        testPath: expectedTestPath,
        hasTest: hasTest,
        complexity: complexity,
        shouldBeTested: complexity.shouldBeTested,
      );
    }

    return TestCoverageReport(coverage);
  }

  static String _extractClassName(String content) {
    final classRegex = RegExp(r'class\s+(\w+)\s+extends\s+\w+');
    final match = classRegex.firstMatch(content);
    return match?.group(1) ?? 'UnknownWidget';
  }

  static String _getImportPath(String widgetPath) {
    // Преобразуем абсолютный путь в относительный import путь
    final relativePath = widgetPath.replaceAll(r'\', '/');
    final libIndex = relativePath.indexOf('/lib/');
    if (libIndex >= 0) {
      return relativePath.substring(libIndex + 5);
    }
    return relativePath;
  }

  static bool _isWidgetFile(String filePath) {
    // Простая эвристика для определения файлов виджетов
    final fileName = path.basename(filePath).toLowerCase();
    return fileName.contains('widget') ||
           fileName.contains('screen') ||
           fileName.contains('page') ||
           fileName.contains('dialog') ||
           fileName.contains('form');
  }
}

enum WidgetComplexity {
  trivial,
  simple,
  medium,
  complex,
  unknown;

  bool get shouldBeTested {
    switch (this) {
      case WidgetComplexity.trivial:
        return false;
      case WidgetComplexity.simple:
        return false;
      case WidgetComplexity.medium:
        return true;
      case WidgetComplexity.complex:
        return true;
      case WidgetComplexity.unknown:
        return true;
    }
  }

  String get description {
    switch (this) {
      case WidgetComplexity.trivial:
        return 'Тривиальный - не требует тестирования';
      case WidgetComplexity.simple:
        return 'Простой - опционально';
      case WidgetComplexity.medium:
        return 'Средний - рекомендуется тестирование';
      case WidgetComplexity.complex:
        return 'Сложный - обязательно тестирование';
      case WidgetComplexity.unknown:
        return 'Неизвестно - требует анализа';
    }
  }
}

class TestCoverageItem {
  final String sourcePath;
  final String testPath;
  final bool hasTest;
  final WidgetComplexity complexity;
  final bool shouldBeTested;

  TestCoverageItem({
    required this.sourcePath,
    required this.testPath,
    required this.hasTest,
    required this.complexity,
    required this.shouldBeTested,
  });

  bool get needsTest => shouldBeTested && !hasTest;
}

class TestCoverageReport {
  final Map<String, TestCoverageItem> items;

  TestCoverageReport(this.items);

  int get totalFiles => items.length;
  int get testedFiles => items.values.where((item) => item.hasTest).length;
  int get shouldBeTestedFiles => items.values.where((item) => item.shouldBeTested).length;
  int get needsTestFiles => items.values.where((item) => item.needsTest).length;

  double get coveragePercentage => 
      shouldBeTestedFiles > 0 ? (testedFiles / shouldBeTestedFiles) * 100 : 100;

  void printReport() {
    // Test Coverage Report
    // Total files: $totalFiles
    // Files with tests: $testedFiles  
    // Files that should be tested: $shouldBeTestedFiles
    // Files needing tests: $needsTestFiles
    // Coverage: ${coveragePercentage.toStringAsFixed(1)}%
    
    // Files needing tests listed above
  }
}

// Пример использования
void main() async {
  // Генерируем отчет о покрытии
  final report = await TestGenerator.generateCoverageReport(
    'lib/',
    'test/widgets/',
  );
  
  report.printReport();
  
  // Генерируем недостающие тесты
  await TestGenerator.generateAllWidgetTests(
    'lib/features/',
    'test/widgets/',
  );
}