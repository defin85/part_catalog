import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Error handler для тестов с детальным логированием
class TestErrorHandler {
  static final List<FlutterErrorDetails> _capturedErrors = [];
  static FlutterExceptionHandler? _originalOnError;

  /// Устанавливает перехватчик ошибок для тестов
  static void setupErrorCapture() {
    _originalOnError = FlutterError.onError;
    _capturedErrors.clear();
    
    FlutterError.onError = (FlutterErrorDetails details) {
      _capturedErrors.add(details);
      // Логируем ошибку для отладки
      // ignore: avoid_print
      print('🚨 Test Error Captured: ${details.exception}');
      if (details.stack != null) {
        // ignore: avoid_print
        print('📍 Stack trace: ${details.stack}');
      }
      
      // Вызываем оригинальный обработчик если нужно
      _originalOnError?.call(details);
    };
  }

  /// Восстанавливает оригинальный обработчик ошибок
  static void restoreErrorHandler() {
    FlutterError.onError = _originalOnError;
    _capturedErrors.clear();
  }

  /// Получает список захваченных ошибок
  static List<FlutterErrorDetails> getCapturedErrors() {
    return List.unmodifiable(_capturedErrors);
  }

  /// Проверяет наличие overflow ошибок
  static List<FlutterErrorDetails> getOverflowErrors() {
    return _capturedErrors.where((error) {
      final message = error.exception.toString().toLowerCase();
      return message.contains('overflow') || 
             message.contains('renderflex') ||
             message.contains('pixels');
    }).toList();
  }

  /// Проверяет наличие ошибок рендеринга
  static List<FlutterErrorDetails> getRenderErrors() {
    return _capturedErrors.where((error) {
      final message = error.exception.toString().toLowerCase();
      return message.contains('render') || 
             message.contains('layout') ||
             message.contains('constraint');
    }).toList();
  }

  /// Очищает захваченные ошибки
  static void clearErrors() {
    _capturedErrors.clear();
  }

  /// Утилита для обработки ошибок в тестах
  static Future<T> expectNoErrors<T>(
    Future<T> Function() testFunction, {
    String? testName,
  }) async {
    setupErrorCapture();
    
    try {
      final result = await testFunction();
      
      if (_capturedErrors.isNotEmpty) {
        // ignore: avoid_print
        print('⚠️ Test "$testName" captured ${_capturedErrors.length} errors:');
        for (final error in _capturedErrors) {
          // ignore: avoid_print
          print('  - ${error.exception}');
        }
        fail('Test captured unexpected errors: ${_capturedErrors.length}');
      }
      
      return result;
    } finally {
      restoreErrorHandler();
    }
  }

  /// Ожидает определенные ошибки в тесте
  static Future<T> expectSpecificErrors<T>(
    Future<T> Function() testFunction, {
    required List<String> expectedErrors,
    String? testName,
  }) async {
    setupErrorCapture();
    
    try {
      final result = await testFunction();
      
      // Проверяем что были получены ожидаемые ошибки
      for (final expectedError in expectedErrors) {
        final found = _capturedErrors.any((error) =>
          error.exception.toString().contains(expectedError));
        
        if (!found) {
          fail('Expected error "$expectedError" was not captured in test "$testName"');
        }
      }
      
      return result;
    } finally {
      restoreErrorHandler();
    }
  }

  /// Создает тестовый wrapper с обработкой ошибок
  static void testWidgetsWithErrorHandling(
    String description,
    Future<void> Function(WidgetTester) testFunction, {
    bool expectNoErrors = true,
    List<String>? expectedErrors,
  }) {
    testWidgets(description, (tester) async {
      if (expectNoErrors) {
        await TestErrorHandler.expectNoErrors(
          () => testFunction(tester),
          testName: description,
        );
      } else if (expectedErrors != null) {
        await TestErrorHandler.expectSpecificErrors(
          () => testFunction(tester),
          expectedErrors: expectedErrors,
          testName: description,
        );
      } else {
        await testFunction(tester);
      }
    });
  }
}