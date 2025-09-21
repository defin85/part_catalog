import 'dart:async';

import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/optimized_armtek_api_client.dart';

/// Уровни тестирования подключения
enum TestLevel {
  /// Уровень 1: Проверка доступности URL (5 сек)
  urlAvailability(1, 'Проверка доступности URL', Duration(seconds: 5)),

  /// Уровень 2: Проверка аутентификации (10 сек)
  authentication(2, 'Проверка аутентификации', Duration(seconds: 10)),

  /// Уровень 3: Проверка VKORG доступа (15 сек)
  vkorgAccess(3, 'Проверка доступа VKORG', Duration(seconds: 15)),

  /// Уровень 4: Полное функциональное тестирование (30 сек)
  fullFunctional(4, 'Полное функциональное тестирование', Duration(seconds: 30));

  const TestLevel(this.level, this.description, this.timeout);

  final int level;
  final String description;
  final Duration timeout;
}

/// Результат тестирования уровня
class TestLevelResult {
  final TestLevel level;
  final bool passed;
  final String? errorMessage;
  final String? suggestion;
  final Duration duration;
  final Map<String, dynamic>? details;

  const TestLevelResult({
    required this.level,
    required this.passed,
    this.errorMessage,
    this.suggestion,
    required this.duration,
    this.details,
  });

  TestLevelResult.success({
    required this.level,
    required this.duration,
    this.details,
  }) : passed = true,
       errorMessage = null,
       suggestion = null;

  TestLevelResult.failure({
    required this.level,
    required String this.errorMessage,
    this.suggestion,
    required this.duration,
    this.details,
  }) : passed = false;
}

/// Результат полного многоуровневого тестирования
class MultiLevelTestResult {
  final SupplierConfig config;
  final List<TestLevelResult> results;
  final bool overallSuccess;
  final Duration totalDuration;
  final TestLevel? failedAtLevel;

  const MultiLevelTestResult({
    required this.config,
    required this.results,
    required this.overallSuccess,
    required this.totalDuration,
    this.failedAtLevel,
  });

  /// Получить результат конкретного уровня
  TestLevelResult? getResultForLevel(TestLevel level) {
    try {
      return results.firstWhere((result) => result.level == level);
    } catch (e) {
      return null;
    }
  }

  /// Получить все пройденные уровни
  List<TestLevel> getPassedLevels() {
    return results
        .where((result) => result.passed)
        .map((result) => result.level)
        .toList();
  }

  /// Получить все непройденные уровни
  List<TestLevel> getFailedLevels() {
    return results
        .where((result) => !result.passed)
        .map((result) => result.level)
        .toList();
  }
}

/// Callback для отслеживания прогресса тестирования
typedef TestProgressCallback = void Function(TestLevel currentLevel, String status);

/// Сервис многоуровневого тестирования подключений к поставщикам
class MultiLevelTestingService {
  static final _logger = appLogger('MultiLevelTestingService');

  /// Выполнить многоуровневое тестирование
  static Future<MultiLevelTestResult> performMultiLevelTest(
    SupplierConfig config, {
    List<TestLevel> levels = TestLevel.values,
    TestProgressCallback? onProgress,
    bool stopOnFirstFailure = false,
  }) async {
    _logger.i('Starting multi-level test for ${config.supplierCode}');

    final stopwatch = Stopwatch()..start();
    final results = <TestLevelResult>[];
    TestLevel? failedAtLevel;

    for (final level in levels) {
      onProgress?.call(level, 'Выполняется...');

      try {
        final result = await _performLevelTest(config, level);
        results.add(result);

        _logger.i('Level ${level.level} completed: ${result.passed ? 'PASSED' : 'FAILED'}');

        if (!result.passed) {
          failedAtLevel = level;
          onProgress?.call(level, 'Ошибка: ${result.errorMessage}');

          if (stopOnFirstFailure) {
            _logger.w('Stopping tests due to failure at level ${level.level}');
            break;
          }
        } else {
          onProgress?.call(level, 'Успешно');
        }
      } catch (e) {
        _logger.e('Error during level ${level.level} test: $e');
        results.add(TestLevelResult.failure(
          level: level,
          errorMessage: 'Внутренняя ошибка: $e',
          duration: Duration.zero,
        ));

        failedAtLevel = level;
        if (stopOnFirstFailure) break;
      }
    }

    stopwatch.stop();
    final overallSuccess = results.isNotEmpty && results.every((r) => r.passed);

    final result = MultiLevelTestResult(
      config: config,
      results: results,
      overallSuccess: overallSuccess,
      totalDuration: stopwatch.elapsed,
      failedAtLevel: failedAtLevel,
    );

    _logger.i('Multi-level test completed in ${stopwatch.elapsed.inMilliseconds}ms. Success: $overallSuccess');

    return result;
  }

  /// Выполнить тестирование конкретного уровня
  static Future<TestLevelResult> _performLevelTest(
    SupplierConfig config,
    TestLevel level,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      switch (level) {
        case TestLevel.urlAvailability:
          return await _testUrlAvailability(config, stopwatch);
        case TestLevel.authentication:
          return await _testAuthentication(config, stopwatch);
        case TestLevel.vkorgAccess:
          return await _testVkorgAccess(config, stopwatch);
        case TestLevel.fullFunctional:
          return await _testFullFunctional(config, stopwatch);
      }
    } on TimeoutException {
      stopwatch.stop();
      return TestLevelResult.failure(
        level: level,
        errorMessage: 'Превышено время ожидания (${level.timeout.inSeconds} сек)',
        suggestion: 'Проверьте интернет-соединение и URL',
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();
      return TestLevelResult.failure(
        level: level,
        errorMessage: 'Ошибка тестирования: $e',
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Уровень 1: Проверка доступности URL
  static Future<TestLevelResult> _testUrlAvailability(
    SupplierConfig config,
    Stopwatch stopwatch,
  ) async {
    final dio = Dio();
    dio.options.connectTimeout = TestLevel.urlAvailability.timeout;
    dio.options.receiveTimeout = TestLevel.urlAvailability.timeout;

    try {
      final response = await dio.head(config.apiConfig.baseUrl);
      stopwatch.stop();

      if (response.statusCode == 200 || response.statusCode == 405) {
        // 405 Method Not Allowed тоже означает, что сервер доступен
        return TestLevelResult.success(
          level: TestLevel.urlAvailability,
          duration: stopwatch.elapsed,
          details: {'statusCode': response.statusCode},
        );
      } else {
        return TestLevelResult.failure(
          level: TestLevel.urlAvailability,
          errorMessage: 'Сервер недоступен (код: ${response.statusCode})',
          suggestion: 'Проверьте правильность URL',
          duration: stopwatch.elapsed,
        );
      }
    } on DioException catch (e) {
      stopwatch.stop();

      String errorMsg;
      String? suggestion;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          errorMsg = 'Превышено время ожидания';
          suggestion = 'Проверьте интернет-соединение';
          break;
        case DioExceptionType.connectionError:
          errorMsg = 'Ошибка подключения';
          suggestion = 'Проверьте URL и интернет-соединение';
          break;
        default:
          errorMsg = 'Сетевая ошибка: ${e.message}';
      }

      return TestLevelResult.failure(
        level: TestLevel.urlAvailability,
        errorMessage: errorMsg,
        suggestion: suggestion,
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Уровень 2: Проверка аутентификации
  static Future<TestLevelResult> _testAuthentication(
    SupplierConfig config,
    Stopwatch stopwatch,
  ) async {
    if (config.apiConfig.authType == AuthenticationType.none) {
      stopwatch.stop();
      return TestLevelResult.success(
        level: TestLevel.authentication,
        duration: stopwatch.elapsed,
        details: {'authType': 'none'},
      );
    }

    if (config.apiConfig.credentials == null) {
      stopwatch.stop();
      return TestLevelResult.failure(
        level: TestLevel.authentication,
        errorMessage: 'Учетные данные не настроены',
        suggestion: 'Укажите логин и пароль в настройках',
        duration: stopwatch.elapsed,
      );
    }

    try {
      // Создаем тестовый API клиент
      final client = await OptimizedArmtekApiClient.create(
        connectionMode: config.apiConfig.connectionMode ?? ApiConnectionMode.direct,
        username: config.apiConfig.credentials?.username,
        password: config.apiConfig.credentials?.password,
      );

      // Пробуем выполнить ping сервиса
      await client.pingService();

      stopwatch.stop();
      return TestLevelResult.success(
        level: TestLevel.authentication,
        duration: stopwatch.elapsed,
        details: {'authType': config.apiConfig.authType.name},
      );

    } on DioException catch (e) {
      stopwatch.stop();

      String errorMsg;
      String? suggestion;

      if (e.response?.statusCode == 401) {
        errorMsg = 'Неверные учетные данные';
        suggestion = 'Проверьте логин и пароль';
      } else if (e.response?.statusCode == 403) {
        errorMsg = 'Доступ запрещен';
        suggestion = 'Обратитесь к администратору для получения доступа';
      } else {
        errorMsg = 'Ошибка аутентификации: ${e.message}';
      }

      return TestLevelResult.failure(
        level: TestLevel.authentication,
        errorMessage: errorMsg,
        suggestion: suggestion,
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Уровень 3: Проверка доступа VKORG
  static Future<TestLevelResult> _testVkorgAccess(
    SupplierConfig config,
    Stopwatch stopwatch,
  ) async {
    try {
      // Создаем тестовый API клиент
      final client = await OptimizedArmtekApiClient.create(
        connectionMode: config.apiConfig.connectionMode ?? ApiConnectionMode.direct,
        username: config.apiConfig.credentials?.username,
        password: config.apiConfig.credentials?.password,
      );

      // Проверяем доступные VKORG
      final vkorgResponse = await client.getUserVkorgList();

      stopwatch.stop();

      if (vkorgResponse.responseData == null || vkorgResponse.responseData!.isEmpty) {
        return TestLevelResult.failure(
          level: TestLevel.vkorgAccess,
          errorMessage: 'Нет доступных организаций продаж (VKORG)',
          suggestion: 'Обратитесь к администратору для настройки доступа',
          duration: stopwatch.elapsed,
        );
      }

      return TestLevelResult.success(
        level: TestLevel.vkorgAccess,
        duration: stopwatch.elapsed,
        details: {
          'vkorgCount': vkorgResponse.responseData!.length,
          'vkorgList': vkorgResponse.responseData!.take(3).map((v) => v.vkorg).toList(),
        },
      );

    } catch (e) {
      stopwatch.stop();
      return TestLevelResult.failure(
        level: TestLevel.vkorgAccess,
        errorMessage: 'Ошибка проверки VKORG: $e',
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Уровень 4: Полное функциональное тестирование
  static Future<TestLevelResult> _testFullFunctional(
    SupplierConfig config,
    Stopwatch stopwatch,
  ) async {
    try {
      // Создаем тестовый API клиент
      final client = await OptimizedArmtekApiClient.create(
        connectionMode: config.apiConfig.connectionMode ?? ApiConnectionMode.direct,
        username: config.apiConfig.credentials?.username,
        password: config.apiConfig.credentials?.password,
      );

      // Выполняем полный набор тестов
      final tests = <String, bool>{};

      // Тест 1: Проверка доступности сервиса
      try {
        await client.pingService();
        tests['pingService'] = true;
      } catch (e) {
        tests['pingService'] = false;
        _logger.w('Ping service test failed: $e');
      }

      // Тест 2: Получение списка VKORG
      try {
        await client.getUserVkorgList();
        tests['getUserVkorgList'] = true;
      } catch (e) {
        tests['getUserVkorgList'] = false;
        _logger.w('Get user VKORG list test failed: $e');
      }

      // Тест 3: Проверка подключения
      try {
        await client.checkConnection();
        tests['checkConnection'] = true;
      } catch (e) {
        tests['checkConnection'] = false;
        _logger.w('Check connection test failed: $e');
      }

      stopwatch.stop();

      final passedTests = tests.values.where((passed) => passed).length;
      final totalTests = tests.length;

      if (passedTests == totalTests) {
        return TestLevelResult.success(
          level: TestLevel.fullFunctional,
          duration: stopwatch.elapsed,
          details: {
            'testsResults': tests,
            'passedTests': passedTests,
            'totalTests': totalTests,
          },
        );
      } else {
        return TestLevelResult.failure(
          level: TestLevel.fullFunctional,
          errorMessage: 'Не все функции работают корректно ($passedTests/$totalTests)',
          suggestion: 'Проверьте настройки API и права доступа',
          duration: stopwatch.elapsed,
          details: {
            'testsResults': tests,
            'passedTests': passedTests,
            'totalTests': totalTests,
          },
        );
      }

    } catch (e) {
      stopwatch.stop();
      return TestLevelResult.failure(
        level: TestLevel.fullFunctional,
        errorMessage: 'Ошибка функционального тестирования: $e',
        duration: stopwatch.elapsed,
      );
    }
  }

  /// Получить рекомендации по исправлению проблем
  static List<String> getDiagnosticSuggestions(MultiLevelTestResult testResult) {
    final suggestions = <String>[];

    for (final result in testResult.results) {
      if (!result.passed && result.suggestion != null) {
        suggestions.add('${result.level.description}: ${result.suggestion}');
      }
    }

    // Общие рекомендации на основе паттернов ошибок
    final failedLevels = testResult.getFailedLevels();

    if (failedLevels.contains(TestLevel.urlAvailability)) {
      suggestions.add('Общие рекомендации: Проверьте интернет-подключение и корректность URL');
    }

    if (failedLevels.contains(TestLevel.authentication)) {
      suggestions.add('Общие рекомендации: Убедитесь, что учетные данные актуальны');
    }

    if (failedLevels.contains(TestLevel.vkorgAccess)) {
      suggestions.add('Общие рекомендации: Обратитесь к поставщику для настройки доступа');
    }

    return suggestions;
  }

  /// Экспорт диагностической информации
  static Map<String, dynamic> exportDiagnosticInfo(MultiLevelTestResult testResult) {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'supplierCode': testResult.config.supplierCode,
      'baseUrl': testResult.config.apiConfig.baseUrl,
      'authType': testResult.config.apiConfig.authType.name,
      'overallSuccess': testResult.overallSuccess,
      'totalDuration': testResult.totalDuration.inMilliseconds,
      'failedAtLevel': testResult.failedAtLevel?.level,
      'results': testResult.results.map((result) => {
        'level': result.level.level,
        'description': result.level.description,
        'passed': result.passed,
        'duration': result.duration.inMilliseconds,
        'errorMessage': result.errorMessage,
        'suggestion': result.suggestion,
        'details': result.details,
      }).toList(),
      'suggestions': getDiagnosticSuggestions(testResult),
    };
  }

}