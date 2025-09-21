import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Расширенные размеры экрана с поддержкой складных устройств
enum AdvancedScreenSize {
  /// Очень маленький экран (smartwatch, mini phones)
  tiny,
  /// Маленький экран (обычные телефоны в портретной ориентации)
  small,
  /// Средний экран (большие телефоны в ландшафте, маленькие планшеты)
  medium,
  /// Большой экран (планшеты)
  large,
  /// Очень большой экран (складные устройства в развернутом виде)
  extraLarge,
  /// Десктоп экран
  desktop,
}

/// Ориентация устройства с дополнительными состояниями
enum DeviceOrientation {
  /// Портретная ориентация
  portrait,
  /// Ландшафтная ориентация
  landscape,
  /// Складное устройство в свернутом состоянии
  folded,
  /// Складное устройство в развернутом состоянии
  unfolded,
}

/// Тип устройства для более точной адаптации
enum DeviceType {
  /// Телефон
  phone,
  /// Планшет
  tablet,
  /// Складное устройство
  foldable,
  /// Десктоп
  desktop,
  /// ТВ или очень большой экран
  tv,
}

/// Конфигурация для определения breakpoints
class ResponsiveBreakpoints {
  final double tinyBreakpoint;
  final double smallBreakpoint;
  final double mediumBreakpoint;
  final double largeBreakpoint;
  final double extraLargeBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveBreakpoints({
    this.tinyBreakpoint = 300.0,
    this.smallBreakpoint = 600.0,
    this.mediumBreakpoint = 900.0,
    this.largeBreakpoint = 1200.0,
    this.extraLargeBreakpoint = 1600.0,
    this.desktopBreakpoint = 1920.0,
  });

  /// Стандартные breakpoints
  static const ResponsiveBreakpoints standard = ResponsiveBreakpoints();

  /// Breakpoints для складных устройств
  static const ResponsiveBreakpoints foldable = ResponsiveBreakpoints(
    smallBreakpoint: 680.0,
    mediumBreakpoint: 840.0,
    largeBreakpoint: 1080.0,
    extraLargeBreakpoint: 1400.0,
  );

  /// Кастомные breakpoints на основе контента
  static ResponsiveBreakpoints adaptive({
    required double contentWidth,
    required int columnCount,
  }) {
    final baseWidth = contentWidth / columnCount;
    return ResponsiveBreakpoints(
      smallBreakpoint: baseWidth * 1.5,
      mediumBreakpoint: baseWidth * 2.5,
      largeBreakpoint: baseWidth * 3.5,
      extraLargeBreakpoint: baseWidth * 4.5,
    );
  }
}

/// Информация о текущем состоянии экрана
class ScreenInfo {
  final AdvancedScreenSize size;
  final DeviceOrientation orientation;
  final DeviceType deviceType;
  final double width;
  final double height;
  final double aspectRatio;
  final bool isTabletInLandscape;
  final bool isFoldableUnfolded;
  final bool isDesktop;

  const ScreenInfo({
    required this.size,
    required this.orientation,
    required this.deviceType,
    required this.width,
    required this.height,
    required this.aspectRatio,
    required this.isTabletInLandscape,
    required this.isFoldableUnfolded,
    required this.isDesktop,
  });

  /// Определяет количество колонок для адаптивной сетки
  int get recommendedColumns {
    switch (size) {
      case AdvancedScreenSize.tiny:
        return 1;
      case AdvancedScreenSize.small:
        return orientation == DeviceOrientation.landscape ? 2 : 1;
      case AdvancedScreenSize.medium:
        return 2;
      case AdvancedScreenSize.large:
        return isTabletInLandscape ? 3 : 2;
      case AdvancedScreenSize.extraLarge:
        return isFoldableUnfolded ? 4 : 3;
      case AdvancedScreenSize.desktop:
        return width > 1600 ? 5 : 4;
    }
  }

  /// Определяет размер отступов
  double get recommendedPadding {
    switch (size) {
      case AdvancedScreenSize.tiny:
        return 8.0;
      case AdvancedScreenSize.small:
        return 16.0;
      case AdvancedScreenSize.medium:
        return 20.0;
      case AdvancedScreenSize.large:
        return 24.0;
      case AdvancedScreenSize.extraLarge:
        return 28.0;
      case AdvancedScreenSize.desktop:
        return 32.0;
    }
  }

  /// Определяет максимальную ширину контента
  double get maxContentWidth {
    switch (size) {
      case AdvancedScreenSize.tiny:
        return double.infinity;
      case AdvancedScreenSize.small:
        return double.infinity;
      case AdvancedScreenSize.medium:
        return 800.0;
      case AdvancedScreenSize.large:
        return 1000.0;
      case AdvancedScreenSize.extraLarge:
        return 1200.0;
      case AdvancedScreenSize.desktop:
        return 1400.0;
    }
  }
}

/// Билдер функции для расширенного responsive layout
typedef AdvancedResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenInfo screenInfo,
);

/// Расширенный responsive layout builder с поддержкой складных устройств
class AdvancedResponsiveLayoutBuilder extends StatelessWidget {
  final AdvancedResponsiveWidgetBuilder? tiny;
  final AdvancedResponsiveWidgetBuilder? small;
  final AdvancedResponsiveWidgetBuilder? medium;
  final AdvancedResponsiveWidgetBuilder? large;
  final AdvancedResponsiveWidgetBuilder? extraLarge;
  final AdvancedResponsiveWidgetBuilder? desktop;
  final AdvancedResponsiveWidgetBuilder fallback;
  final ResponsiveBreakpoints breakpoints;
  final bool detectFoldableDevices;

  const AdvancedResponsiveLayoutBuilder({
    super.key,
    this.tiny,
    this.small,
    this.medium,
    this.large,
    this.extraLarge,
    this.desktop,
    required this.fallback,
    this.breakpoints = ResponsiveBreakpoints.standard,
    this.detectFoldableDevices = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenInfo = _analyzeScreen(context, constraints);

        // Выбираем подходящий билдер
        final builder = _selectBuilder(screenInfo);

        return builder(context, screenInfo);
      },
    );
  }

  ScreenInfo _analyzeScreen(BuildContext context, BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    final aspectRatio = width / height;

    // Определяем размер экрана
    final size = _determineScreenSize(width);

    // Определяем ориентацию
    final orientation = _determineOrientation(context, aspectRatio);

    // Определяем тип устройства
    final deviceType = _determineDeviceType(width, height, aspectRatio);

    // Дополнительные флаги
    final isTabletInLandscape = deviceType == DeviceType.tablet &&
                               orientation == DeviceOrientation.landscape;
    final isFoldableUnfolded = deviceType == DeviceType.foldable &&
                              orientation == DeviceOrientation.unfolded;
    final isDesktop = deviceType == DeviceType.desktop;

    return ScreenInfo(
      size: size,
      orientation: orientation,
      deviceType: deviceType,
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      isTabletInLandscape: isTabletInLandscape,
      isFoldableUnfolded: isFoldableUnfolded,
      isDesktop: isDesktop,
    );
  }

  AdvancedScreenSize _determineScreenSize(double width) {
    if (width < breakpoints.tinyBreakpoint) return AdvancedScreenSize.tiny;
    if (width < breakpoints.smallBreakpoint) return AdvancedScreenSize.small;
    if (width < breakpoints.mediumBreakpoint) return AdvancedScreenSize.medium;
    if (width < breakpoints.largeBreakpoint) return AdvancedScreenSize.large;
    if (width < breakpoints.extraLargeBreakpoint) return AdvancedScreenSize.extraLarge;
    return AdvancedScreenSize.desktop;
  }

  DeviceOrientation _determineOrientation(BuildContext context, double aspectRatio) {
    final mediaQuery = MediaQuery.of(context);

    // Проверяем на складные устройства
    if (detectFoldableDevices) {
      // Эвристика для определения складных устройств
      // Основана на соотношении сторон и размерах экрана
      if (aspectRatio > 2.5) {
        return DeviceOrientation.unfolded;
      }
      if (aspectRatio < 0.8 && mediaQuery.size.width < 400) {
        return DeviceOrientation.folded;
      }
    }

    // Стандартная ориентация
    return aspectRatio > 1.0
        ? DeviceOrientation.landscape
        : DeviceOrientation.portrait;
  }

  DeviceType _determineDeviceType(double width, double height, double aspectRatio) {
    final diagonal = _calculateDiagonal(width, height);

    // ТВ или очень большие экраны
    if (width > 1800 && aspectRatio > 1.5) return DeviceType.tv;

    // Десктоп
    if (width > breakpoints.extraLargeBreakpoint) return DeviceType.desktop;

    // Складные устройства (эвристика)
    if (detectFoldableDevices) {
      if (aspectRatio > 2.5 || (aspectRatio < 0.8 && width < 400)) {
        return DeviceType.foldable;
      }
    }

    // Планшет vs телефон
    if (diagonal > 700 || width > breakpoints.mediumBreakpoint) {
      return DeviceType.tablet;
    }

    return DeviceType.phone;
  }

  double _calculateDiagonal(double width, double height) {
    // Приблизительный расчет диагонали в логических пикселях
    return math.sqrt(width * width + height * height);
  }

  AdvancedResponsiveWidgetBuilder _selectBuilder(ScreenInfo screenInfo) {
    switch (screenInfo.size) {
      case AdvancedScreenSize.tiny:
        return tiny ?? small ?? fallback;
      case AdvancedScreenSize.small:
        return small ?? tiny ?? fallback;
      case AdvancedScreenSize.medium:
        return medium ?? small ?? fallback;
      case AdvancedScreenSize.large:
        return large ?? medium ?? fallback;
      case AdvancedScreenSize.extraLarge:
        return extraLarge ?? large ?? fallback;
      case AdvancedScreenSize.desktop:
        return desktop ?? extraLarge ?? fallback;
    }
  }
}

/// Миксин для виджетов, которые нужно сделать адаптивными
mixin AdvancedResponsiveMixin {
  /// Получает информацию о текущем экране
  ScreenInfo getScreenInfo(BuildContext context) {
    final builder = context.findAncestorWidgetOfExactType<AdvancedResponsiveLayoutBuilder>();
    if (builder != null) {
      // Получаем размеры экрана через MediaQuery как fallback
      final mediaQuery = MediaQuery.of(context);
      final constraints = BoxConstraints(
        maxWidth: mediaQuery.size.width,
        maxHeight: mediaQuery.size.height,
      );
      return builder._analyzeScreen(context, constraints);
    }
    return _fallbackScreenInfo(context);
  }

  ScreenInfo _fallbackScreenInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return ScreenInfo(
      size: width < 600 ? AdvancedScreenSize.small : AdvancedScreenSize.medium,
      orientation: width > height ? DeviceOrientation.landscape : DeviceOrientation.portrait,
      deviceType: width < 600 ? DeviceType.phone : DeviceType.tablet,
      width: width,
      height: height,
      aspectRatio: width / height,
      isTabletInLandscape: false,
      isFoldableUnfolded: false,
      isDesktop: false,
    );
  }
}

/// Extension для удобного доступа к responsive утилитам
extension ResponsiveContext on BuildContext {
  /// Получает информацию о текущем экране
  ScreenInfo get screenInfo {
    final builder = findAncestorWidgetOfExactType<AdvancedResponsiveLayoutBuilder>();
    if (builder != null) {
      final mediaQuery = MediaQuery.of(this);
      final constraints = BoxConstraints(
        maxWidth: mediaQuery.size.width,
        maxHeight: mediaQuery.size.height,
      );
      return builder._analyzeScreen(this, constraints);
    }

    // Fallback
    final mediaQuery = MediaQuery.of(this);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return ScreenInfo(
      size: width < 600 ? AdvancedScreenSize.small : AdvancedScreenSize.medium,
      orientation: width > height ? DeviceOrientation.landscape : DeviceOrientation.portrait,
      deviceType: width < 600 ? DeviceType.phone : DeviceType.tablet,
      width: width,
      height: height,
      aspectRatio: width / height,
      isTabletInLandscape: false,
      isFoldableUnfolded: false,
      isDesktop: false,
    );
  }

  /// Проверяет, является ли экран маленьким
  bool get isSmallScreen => screenInfo.size.index <= AdvancedScreenSize.small.index;

  /// Проверяет, является ли экран большим
  bool get isLargeScreen => screenInfo.size.index >= AdvancedScreenSize.large.index;

  /// Проверяет, является ли устройство планшетом в ландшафте
  bool get isTabletInLandscape => screenInfo.isTabletInLandscape;

  /// Проверяет, является ли устройство складным в развернутом виде
  bool get isFoldableUnfolded => screenInfo.isFoldableUnfolded;
}