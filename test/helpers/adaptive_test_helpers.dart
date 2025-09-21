import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'test_helpers.dart';

/// Утилиты для тестирования адаптивных компонентов
class AdaptiveTestHelpers {
  /// Стандартные размеры экранов для тестирования адаптивности
  static const Size smallScreen = Size(320, 568); // Mobile portrait
  static const Size mediumScreen = Size(768, 1024); // Tablet portrait
  static const Size largeScreen = Size(1920, 1080); // Desktop

  /// Breakpoints для тестирования
  static const double mediumBreakpoint = 600.0;
  static const double largeBreakpoint = 1000.0;

  /// Тестирует виджет на всех размерах экранов
  static Future<void> testAllScreenSizes(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    String? description,
  }) async {
    final screenSizes = [
      ('Small Screen (Mobile)', smallScreen),
      ('Medium Screen (Tablet)', mediumScreen),
      ('Large Screen (Desktop)', largeScreen),
    ];

    for (final (name, size) in screenSizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
      await tester.pumpAndSettle();

      // Проверяем отсутствие overflow
      expect(
        tester.takeException(),
        isNull,
        reason: 'No exceptions should occur on $name${description != null ? ' for $description' : ''}',
      );
    }
  }

  /// Проверяет что виджет корректно адаптируется к размеру экрана
  static Future<void> expectResponsiveBehavior(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    required void Function(ScreenSize screenSize) assertions,
  }) async {
    // Тестируем small screen
    await tester.binding.setSurfaceSize(smallScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    assertions(ScreenSize.small);

    // Тестируем medium screen
    await tester.binding.setSurfaceSize(mediumScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    assertions(ScreenSize.medium);

    // Тестируем large screen
    await tester.binding.setSurfaceSize(largeScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    assertions(ScreenSize.large);
  }

  /// Проверяет breakpoints
  static Future<void> testBreakpoints(
    WidgetTester tester,
    Widget Function() widgetBuilder,
  ) async {
    // Размеры чуть меньше и больше breakpoints
    final testSizes = [
      Size(mediumBreakpoint - 1, 600), // Just below medium
      Size(mediumBreakpoint + 1, 600), // Just above medium
      Size(largeBreakpoint - 1, 600), // Just below large
      Size(largeBreakpoint + 1, 600), // Just above large
    ];

    for (final size in testSizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'No exceptions at breakpoint ${size.width}x${size.height}',
      );
    }
  }

  /// Проверяет что виджет рендерится без overflow на всех размерах
  static Future<void> expectNoOverflowOnAllSizes(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    String? description,
  }) async {
    final sizes = [
      ('Small Screen', smallScreen),
      ('Medium Screen', mediumScreen),
      ('Large Screen', largeScreen),
      ('iPhone 8', const Size(375, 667)),
      ('iPhone 11', const Size(414, 896)),
      ('Laptop', const Size(1366, 768)),
      ('Ultra-wide', const Size(2560, 1080)),
    ];

    for (final (name, size) in sizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
      await tester.pumpAndSettle();

      // Проверяем на RenderFlex overflow и другие layout ошибки
      final exception = tester.takeException();
      if (exception != null) {
        fail('Widget should not have layout errors on $name (${size.width}x${size.height})'
             '${description != null ? ' for $description' : ''}. '
             'Error: $exception');
      }
    }
  }

  /// Проверяет, что виджет не содержит constraint ошибок
  static Future<void> expectNoConstraintErrors(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    String? description,
  }) async {
    final sizes = [
      ('Small Screen', smallScreen),
      ('Medium Screen', mediumScreen),
      ('Large Screen', largeScreen),
    ];

    for (final (name, size) in sizes) {
      await tester.binding.setSurfaceSize(size);

      // Сбрасываем любые предыдущие исключения
      tester.takeException();

      await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
      await tester.pumpAndSettle();

      final exception = tester.takeException();
      if (exception != null) {
        final exceptionStr = exception.toString();
        if (exceptionStr.contains('BoxConstraints') ||
            exceptionStr.contains('infinite height') ||
            exceptionStr.contains('infinite width') ||
            exceptionStr.contains('RenderFlex') ||
            exceptionStr.contains('forces an infinite')) {
          fail('Widget has constraint/layout errors on $name (${size.width}x${size.height})'
               '${description != null ? ' for $description' : ''}. '
               'Error: $exception');
        }
      }
    }
  }

  /// Проверяет, что виджет работает с ref.listen корректно
  static Future<void> expectNoRefListenErrors(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    String? description,
  }) async {
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();

    final exception = tester.takeException();
    if (exception != null) {
      final exceptionStr = exception.toString();
      if (exceptionStr.contains('ref.listen') ||
          exceptionStr.contains('debugDoingBuild') ||
          exceptionStr.contains('can only be used within the build method')) {
        fail('Widget has ref.listen errors'
             '${description != null ? ' for $description' : ''}. '
             'Error: $exception');
      }
    }
  }

  /// Находит виджеты по типу с учетом адаптивности
  static Finder findAdaptiveWidget<T>() {
    return find.byType(T);
  }

  /// Проверяет размеры виджета на разных экранах
  static Future<void> expectDifferentSizesOnScreens(
    WidgetTester tester,
    Widget Function() widgetBuilder,
    Finder finder,
  ) async {
    Size? smallSize, mediumSize, largeSize;

    // Small screen
    await tester.binding.setSurfaceSize(smallScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(finder)) {
      smallSize = tester.getSize(finder);
    }

    // Medium screen
    await tester.binding.setSurfaceSize(mediumScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(finder)) {
      mediumSize = tester.getSize(finder);
    }

    // Large screen
    await tester.binding.setSurfaceSize(largeScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(finder)) {
      largeSize = tester.getSize(finder);
    }

    // Проверяем что размеры действительно разные или хотя бы логичные
    if (smallSize != null && mediumSize != null) {
      expect(
        smallSize != mediumSize,
        isTrue,
        reason: 'Widget should have different sizes on small vs medium screens',
      );
    }

    if (mediumSize != null && largeSize != null) {
      expect(
        mediumSize != largeSize,
        isTrue,
        reason: 'Widget should have different sizes on medium vs large screens',
      );
    }
  }

  /// Проверяет адаптивное поведение текста
  static Future<void> expectAdaptiveTextSizes(
    WidgetTester tester,
    Widget Function() widgetBuilder,
  ) async {
    double? smallFontSize, mediumFontSize, largeFontSize;

    // Small screen
    await tester.binding.setSurfaceSize(smallScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    final smallText = tester.widget<Text>(find.byType(Text).first);
    smallFontSize = smallText.style?.fontSize;

    // Medium screen
    await tester.binding.setSurfaceSize(mediumScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    final mediumText = tester.widget<Text>(find.byType(Text).first);
    mediumFontSize = mediumText.style?.fontSize;

    // Large screen
    await tester.binding.setSurfaceSize(largeScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    final largeText = tester.widget<Text>(find.byType(Text).first);
    largeFontSize = largeText.style?.fontSize;

    // Проверяем логичное масштабирование
    if (smallFontSize != null && mediumFontSize != null && largeFontSize != null) {
      expect(
        smallFontSize <= mediumFontSize,
        isTrue,
        reason: 'Font size should increase or stay same from small to medium screen',
      );
      expect(
        mediumFontSize <= largeFontSize,
        isTrue,
        reason: 'Font size should increase or stay same from medium to large screen',
      );
    }
  }

  /// Проверяет адаптивные отступы
  static Future<void> expectAdaptivePadding(
    WidgetTester tester,
    Widget Function() widgetBuilder,
    Finder paddingFinder,
  ) async {
    EdgeInsets? smallPadding, mediumPadding, largePadding;

    // Small screen
    await tester.binding.setSurfaceSize(smallScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(paddingFinder)) {
      final padding = tester.widget<Padding>(paddingFinder);
      smallPadding = padding.padding as EdgeInsets?;
    }

    // Medium screen
    await tester.binding.setSurfaceSize(mediumScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(paddingFinder)) {
      final padding = tester.widget<Padding>(paddingFinder);
      mediumPadding = padding.padding as EdgeInsets?;
    }

    // Large screen
    await tester.binding.setSurfaceSize(largeScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    if (tester.any(paddingFinder)) {
      final padding = tester.widget<Padding>(paddingFinder);
      largePadding = padding.padding as EdgeInsets?;
    }

    // Проверяем что отступы адаптируются
    if (smallPadding != null && largePadding != null) {
      expect(
        smallPadding != largePadding,
        isTrue,
        reason: 'Padding should be different between small and large screens',
      );
    }
  }

  /// Создает виджет для тестирования в определенном размере
  static Widget createSizedTestWidget(
    Widget child,
    Size size,
  ) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  /// Проверяет что layout меняется между размерами экранов
  static Future<void> expectDifferentLayouts(
    WidgetTester tester,
    Widget Function() widgetBuilder, {
    required void Function() smallScreenAssertions,
    required void Function() mediumScreenAssertions,
    required void Function() largeScreenAssertions,
  }) async {
    // Small screen layout
    await tester.binding.setSurfaceSize(smallScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    smallScreenAssertions();

    // Medium screen layout
    await tester.binding.setSurfaceSize(mediumScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    mediumScreenAssertions();

    // Large screen layout
    await tester.binding.setSurfaceSize(largeScreen);
    await tester.pumpWidget(TestHelpers.createTestApp(widgetBuilder()));
    await tester.pumpAndSettle();
    largeScreenAssertions();
  }
}

/// Базовый класс для тестирования адаптивных виджетов
abstract class BaseAdaptiveWidgetTest {
  /// Название виджета для отчетов
  String get widgetName;

  /// Создает виджет для тестирования
  Widget createWidget({Map<String, dynamic>? props});

  /// Запускает все базовые тесты адаптивности
  void runAllAdaptiveTests() {
    group('$widgetName Adaptive Tests', () {
      testWidgets('should render without errors on all screen sizes', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => createWidget(),
          description: widgetName,
        );
      });

      testWidgets('should not overflow on any screen size', (tester) async {
        await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
          tester,
          () => createWidget(),
        );
      });

      testWidgets('should handle breakpoints correctly', (tester) async {
        await AdaptiveTestHelpers.testBreakpoints(
          tester,
          () => createWidget(),
        );
      });

      // Дополнительные тесты для конкретного виджета
      runCustomAdaptiveTests();
    });
  }

  /// Переопределяется в наследниках для специфичных тестов
  void runCustomAdaptiveTests() {}
}