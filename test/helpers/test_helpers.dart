import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';

import 'provider_test_helpers.dart';

/// Базовые helper функции для тестирования
class TestHelpers {
  /// Создает виджет с Riverpod и локализацией для тестирования
  static Widget createTestApp(
    Widget child, {
    List<Override>? overrides,
    Size? screenSize,
  }) {
    final app = ProviderScope(
      overrides: overrides ?? ProviderTestHelpers.createStandardOverrides(),
      child: TranslationProvider(
        child: MaterialApp(
          home: child,
          localizationsDelegates: const [
            // Добавляем стандартные делегаты, если нужно
          ],
        ),
      ),
    );

    if (screenSize != null) {
      return MediaQuery(
        data: MediaQueryData(size: screenSize),
        child: app,
      );
    }

    return app;
  }

  /// Создает виджет с пустыми данными для тестирования
  static Widget createEmptyTestApp(
    Widget child,
  ) {
    return ProviderScope(
      overrides: ProviderTestHelpers.createEmptyDataOverrides(),
      child: TranslationProvider(
        child: MaterialApp(
          home: child,
        ),
      ),
    );
  }

  /// Создает виджет с ошибками для тестирования
  static Widget createErrorTestApp(
    Widget child,
  ) {
    return ProviderScope(
      overrides: ProviderTestHelpers.createErrorOverrides(),
      child: TranslationProvider(
        child: MaterialApp(
          home: child,
        ),
      ),
    );
  }

  /// Создает тестовый виджет с базовым Scaffold
  static Widget createScaffoldTestApp(
    Widget child, {
    List<Override>? overrides,
  }) {
    return createTestApp(
      Scaffold(
        body: child,
      ),
      overrides: overrides,
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

  /// Проверяет отсутствие overflow ошибок
  static Future<void> expectNoOverflow(
    WidgetTester tester,
    Widget widget, {
    List<Override>? overrides,
    Size? screenSize,
  }) async {
    final errors = <String>[];
    FlutterError.onError = (details) {
      if (details.exception.toString().contains('overflow')) {
        errors.add(details.exception.toString());
      }
    };

    if (screenSize != null) {
      await tester.binding.setSurfaceSize(screenSize);
    }

    await tester.pumpWidget(createTestApp(widget, overrides: overrides));
    await tester.pump();

    expect(errors, isEmpty, reason: 'Widget should not have overflow errors');
  }

  /// Тестирует виджет на разных размерах экрана
  static Future<void> testResponsiveness(
    WidgetTester tester,
    Widget widget, {
    List<Override>? overrides,
  }) async {
    final screenSizes = [
      const Size(320, 568), // iPhone SE
      const Size(375, 667), // iPhone 8
      const Size(414, 896), // iPhone 11
      const Size(768, 1024), // iPad
      const Size(1366, 768), // Laptop
      const Size(1920, 1080), // Desktop
    ];

    for (final size in screenSizes) {
      await expectNoOverflow(
        tester,
        widget,
        overrides: overrides,
        screenSize: size,
      );
    }
  }

  /// Проверяет производительность рендеринга виджета
  static Future<void> testPerformance(
    WidgetTester tester,
    Widget widget, {
    List<Override>? overrides,
    int maxRenderTimeMs = 100,
  }) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(createTestApp(widget, overrides: overrides));

    stopwatch.stop();
    expect(
      stopwatch.elapsedMilliseconds,
      lessThan(maxRenderTimeMs),
      reason: 'Widget should render within $maxRenderTimeMs ms',
    );
  }

  /// Общие размеры экранов для тестирования
  static const mobilePortrait = Size(375, 667);
  static const mobileLandscape = Size(667, 375);
  static const tabletPortrait = Size(768, 1024);
  static const tabletLandscape = Size(1024, 768);
  static const desktop = Size(1920, 1080);
  static const ultraWide = Size(2560, 1080);
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
        widget,
        overrides: overrides,
      ),
    );

    // Даем время для полной инициализации провайдеров и локализации
    await pump();
    await pump(const Duration(milliseconds: 100));
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
            widget is TextField && widget.decoration?.labelText == labelText,
      ),
      text,
    );
    await pump();
  }

  /// Ждет появления виджета с таймаутом
  Future<void> waitForWidget(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await pumpAndSettle();

    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      if (any(finder)) return;
      await pump(const Duration(milliseconds: 100));
    }

    fail('Widget not found within timeout');
  }

  /// Скроллит до виджета
  Future<void> scrollToWidget(Finder finder) async {
    final scrollable = find.byType(Scrollable);
    if (any(scrollable)) {
      await scrollUntilVisible(finder, 100);
    }
  }

  /// Проверяет состояние загрузки
  Future<void> expectLoading() async {
    expect(TestHelpers.findLoadingIndicator(), findsOneWidget);
  }

  /// Проверяет отсутствие состояния загрузки
  Future<void> expectNotLoading() async {
    expect(TestHelpers.findLoadingIndicator(), findsNothing);
  }

  /// Drag для тестирования swipe жестов
  Future<void> swipeLeft(Finder finder) async {
    await drag(finder, const Offset(-300, 0));
    await pumpAndSettle();
  }

  Future<void> swipeRight(Finder finder) async {
    await drag(finder, const Offset(300, 0));
    await pumpAndSettle();
  }

  Future<void> swipeUp(Finder finder) async {
    await drag(finder, const Offset(0, -300));
    await pumpAndSettle();
  }

  Future<void> swipeDown(Finder finder) async {
    await drag(finder, const Offset(0, 300));
    await pumpAndSettle();
  }
}