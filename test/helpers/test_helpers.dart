import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';

/// Базовые helper функции для тестирования
class TestHelpers {
  /// Создает виджет с Riverpod и локализацией для тестирования
  static Widget createTestApp({
    required Widget child,
    List<Override>? overrides,
  }) {
    return ProviderScope(
      overrides: overrides ?? [],
      child: TranslationProvider(
        child: MaterialApp(
          home: child,
          localizationsDelegates: const [
            // Добавляем стандартные делегаты, если нужно
          ],
        ),
      ),
    );
  }

  /// Создает тестовый виджет с базовым Scaffold
  static Widget createScaffoldTestApp({
    required Widget child,
    List<Override>? overrides,
  }) {
    return createTestApp(
      overrides: overrides,
      child: Scaffold(
        body: child,
      ),
    );
  }

  /// Ждет завершения всех анимаций и микротасков
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.pump(Duration.zero); // Дополнительный pump для микротасков
  }

  /// Находит виджет по тексту (с учетом локализации)
  static Finder findTextIgnoreCase(String text) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.toLowerCase().contains(text.toLowerCase()),
    );
  }

  /// Проверяет наличие индикатора загрузки
  static Finder findLoadingIndicator() {
    return find.byType(CircularProgressIndicator);
  }

  /// Проверяет наличие текста ошибки
  static Finder findErrorText() {
    return find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.style?.color != null &&
          (widget.style!.color == Colors.red ||
              widget.style!.color == Colors.red.shade700),
    );
  }
}

/// Расширения для удобства тестирования
extension WidgetTesterExtensions on WidgetTester {
  /// Быстрый способ создать тестовое приложение
  Future<void> pumpTestApp(
    Widget widget, {
    List<Override>? overrides,
  }) async {
    await pumpWidget(
      TestHelpers.createTestApp(
        child: widget,
        overrides: overrides,
      ),
    );
  }

  /// Быстрый способ найти и нажать на кнопку
  Future<void> tapButton(String buttonText) async {
    await tap(find.text(buttonText));
    await pump();
  }

  /// Ввод текста в поле с указанной меткой
  Future<void> enterTextInField(String labelText, String text) async {
    await enterText(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.labelText == labelText,
      ),
      text,
    );
    await pump();
  }
}