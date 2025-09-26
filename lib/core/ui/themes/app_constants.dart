import 'package:flutter/material.dart';

// Breakpoints для адаптивного дизайна
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  /// Проверяет размер экрана
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}

/// Отступы для адаптивного дизайна
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  /// Адаптивные отступы в зависимости от размера экрана
  static double adaptive(BuildContext context) {
    if (AppBreakpoints.isDesktop(context)) return xl;
    if (AppBreakpoints.isTablet(context)) return lg;
    return md;
  }

  static double smallAdaptive(BuildContext context) {
    if (AppBreakpoints.isDesktop(context)) return lg;
    if (AppBreakpoints.isTablet(context)) return md;
    return sm;
  }
}

/// Радиусы скругления
class AppRadius {
  static const double none = 0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 1000.0;
}

/// Размеры для различных элементов
class AppSizes {
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;

  static const double inputHeight = 48.0;
  static const double inputHeightSmall = 36.0;
  static const double inputHeightLarge = 56.0;

  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;

  static const double cardElevation = 2.0;
  static const double dialogElevation = 8.0;
  static const double fabElevation = 6.0;
}

/// Анимации и продолжительности
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  /// Кривые анимаций
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;
}

/// Z-индексы для слоев
class AppZIndex {
  static const int dropdown = 1000;
  static const int sticky = 1020;
  static const int fixed = 1030;
  static const int overlay = 1040;
  static const int modal = 1050;
  static const int popover = 1060;
  static const int tooltip = 1070;
  static const int toast = 1080;
}