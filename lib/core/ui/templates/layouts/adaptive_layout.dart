import 'package:flutter/material.dart';

/// Адаптивный макет, который переключается между разными компоновками
/// в зависимости от размера экрана
class AdaptiveLayout extends StatelessWidget {
  /// Макет для мобильных устройств (< 600px)
  final Widget mobile;

  /// Макет для планшетов (600px - 1200px)
  final Widget? tablet;

  /// Макет для десктопов (> 1200px)
  final Widget? desktop;

  /// Брейкпоинт между мобильным и планшетным режимами
  final double tabletBreakpoint;

  /// Брейкпоинт между планшетным и десктопным режимами
  final double desktopBreakpoint;

  /// Анимировать переходы между макетами
  final bool animate;

  /// Длительность анимации
  final Duration animationDuration;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.tabletBreakpoint = 600,
    this.desktopBreakpoint = 1200,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final layout = _selectLayout(width);

        if (animate) {
          return AnimatedSwitcher(
            duration: animationDuration,
            child: layout,
          );
        }

        return layout;
      },
    );
  }

  Widget _selectLayout(double width) {
    if (width >= desktopBreakpoint && desktop != null) {
      return desktop!;
    } else if (width >= tabletBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Билдер для создания адаптивных виджетов с учетом размера экрана
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints, DeviceType deviceType) builder;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.tabletBreakpoint = 600,
    this.desktopBreakpoint = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        return builder(context, constraints, deviceType);
      },
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width >= desktopBreakpoint) {
      return DeviceType.desktop;
    } else if (width >= tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }
}

/// Типы устройств для адаптивного дизайна
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Утилиты для работы с адаптивным дизайном
class AdaptiveUtils {
  static const double defaultTabletBreakpoint = 600;
  static const double defaultDesktopBreakpoint = 1200;

  /// Определить тип устройства по ширине экрана
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= defaultDesktopBreakpoint) {
      return DeviceType.desktop;
    } else if (width >= defaultTabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  /// Получить значение в зависимости от типа устройства
  static T getValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Проверить, является ли устройство мобильным
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Проверить, является ли устройство планшетом
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Проверить, является ли устройство десктопом
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Получить количество колонок сетки для текущего устройства
  static int getGridColumns(BuildContext context) {
    return getValue(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  /// Получить отступы для текущего устройства
  static EdgeInsets getPadding(BuildContext context) {
    return getValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Получить максимальную ширину контента для устройства
  static double getMaxContentWidth(BuildContext context) {
    return getValue(
      context: context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }
}

/// Расширения для MediaQuery для удобной работы с адаптивностью
extension AdaptiveMediaQuery on MediaQueryData {
  DeviceType get deviceType {
    if (size.width >= AdaptiveUtils.defaultDesktopBreakpoint) {
      return DeviceType.desktop;
    } else if (size.width >= AdaptiveUtils.defaultTabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.mobile;
    }
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
}