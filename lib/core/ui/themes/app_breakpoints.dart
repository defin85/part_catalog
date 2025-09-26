import 'package:flutter/material.dart';

/// Система брейкпоинтов для адаптивного дизайна
/// Определяет точки переключения между различными размерами экранов
class AppBreakpoints {
  AppBreakpoints._();

  // =======================
  // ОСНОВНЫЕ БРЕЙКПОИНТЫ
  // =======================

  /// Мобильные устройства (портрет)
  static const double mobileMini = 320;
  static const double mobile = 480;

  /// Мобильные устройства (ландшафт) и маленькие планшеты
  static const double mobileLarge = 600;

  /// Планшеты (портрет)
  static const double tablet = 768;

  /// Планшеты (ландшафт) и маленькие десктопы
  static const double tabletLarge = 1024;

  /// Десктопы
  static const double desktop = 1200;

  /// Большие десктопы
  static const double desktopLarge = 1440;

  /// Очень большие экраны
  static const double desktopXLarge = 1920;

  // =======================
  // СПЕЦИАЛИЗИРОВАННЫЕ БРЕЙКПОИНТЫ
  // =======================

  /// Переключение с мобильной на планшетную навигацию
  static const double navigationBreakpoint = mobileLarge;

  /// Переключение на sidebar навигацию
  static const double sidebarBreakpoint = tablet;

  /// Переключение на master-detail layout
  static const double masterDetailBreakpoint = tabletLarge;

  /// Переключение на широкий layout с боковыми панелями
  static const double wideLayoutBreakpoint = desktop;

  // =======================
  // ВЫСОТЫ ЭКРАНОВ
  // =======================

  /// Минимальная высота для полноценного интерфейса
  static const double minHeight = 600;

  /// Компактная высота (складные телефоны, альбомная ориентация)
  static const double compactHeight = 400;

  /// Высота для планшетов
  static const double tabletHeight = 800;

  /// Высота для десктопов
  static const double desktopHeight = 1080;

  // =======================
  // УТИЛИТАРНЫЕ МЕТОДЫ
  // =======================

  /// Определить тип устройства по ширине экрана
  static DeviceType getDeviceType(double width) {
    if (width < mobile) {
      return DeviceType.mobileMini;
    } else if (width < mobileLarge) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.mobileLarge;
    } else if (width < tabletLarge) {
      return DeviceType.tablet;
    } else if (width < desktop) {
      return DeviceType.tabletLarge;
    } else if (width < desktopLarge) {
      return DeviceType.desktop;
    } else if (width < desktopXLarge) {
      return DeviceType.desktopLarge;
    } else {
      return DeviceType.desktopXLarge;
    }
  }

  /// Определить тип устройства для текущего контекста
  static DeviceType getDeviceTypeForContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getDeviceType(width);
  }

  /// Проверить, является ли экран мобильным
  static bool isMobile(double width) {
    return width < mobileLarge;
  }

  /// Проверить, является ли экран планшетом
  static bool isTablet(double width) {
    return width >= mobileLarge && width < desktop;
  }

  /// Проверить, является ли экран десктопом
  static bool isDesktop(double width) {
    return width >= desktop;
  }

  /// Проверить для текущего контекста
  static bool isMobileForContext(BuildContext context) {
    return isMobile(MediaQuery.of(context).size.width);
  }

  static bool isTabletForContext(BuildContext context) {
    return isTablet(MediaQuery.of(context).size.width);
  }

  static bool isDesktopForContext(BuildContext context) {
    return isDesktop(MediaQuery.of(context).size.width);
  }

  /// Проверить, поддерживается ли master-detail layout
  static bool supportsMasterDetail(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= masterDetailBreakpoint;
  }

  /// Проверить, нужна ли боковая навигация
  static bool needsSideNavigation(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= sidebarBreakpoint;
  }

  /// Проверить, компактная ли высота экрана
  static bool isCompactHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height < compactHeight;
  }

  /// Получить количество колонок для сетки в зависимости от ширины
  static int getGridColumns(double width) {
    if (width < mobile) {
      return 1;
    } else if (width < mobileLarge) {
      return 2;
    } else if (width < tablet) {
      return 2;
    } else if (width < tabletLarge) {
      return 3;
    } else if (width < desktop) {
      return 4;
    } else if (width < desktopLarge) {
      return 5;
    } else {
      return 6;
    }
  }

  /// Получить количество колонок для текущего контекста
  static int getGridColumnsForContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getGridColumns(width);
  }

  /// Получить максимальную ширину контента для данного размера экрана
  static double getMaxContentWidth(double screenWidth) {
    if (screenWidth < mobileLarge) {
      return screenWidth - 32; // 16pt отступы с каждой стороны
    } else if (screenWidth < tablet) {
      return screenWidth - 64; // 32pt отступы
    } else if (screenWidth < desktop) {
      return 800; // Фиксированная ширина для планшетов
    } else {
      return 1200; // Максимальная ширина для десктопов
    }
  }

  /// Получить адаптивные отступы в зависимости от размера экрана
  static EdgeInsets getAdaptivePadding(double width) {
    if (width < mobile) {
      return const EdgeInsets.all(12);
    } else if (width < mobileLarge) {
      return const EdgeInsets.all(16);
    } else if (width < tablet) {
      return const EdgeInsets.all(24);
    } else if (width < desktop) {
      return const EdgeInsets.all(32);
    } else {
      return const EdgeInsets.all(48);
    }
  }

  /// Получить адаптивные отступы для текущего контекста
  static EdgeInsets getAdaptivePaddingForContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getAdaptivePadding(width);
  }

  /// Проверить, нужно ли показывать компактный интерфейс
  static bool shouldUseCompactUI(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < mobileLarge || size.height < minHeight;
  }

  /// Получить адаптивное значение в зависимости от размера экрана
  static T getAdaptiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? mobileLarge,
    T? tablet,
    T? tabletLarge,
    T? desktop,
    T? desktopLarge,
  }) {
    final deviceType = getDeviceTypeForContext(context);

    switch (deviceType) {
      case DeviceType.mobileMini:
      case DeviceType.mobile:
        return mobile;
      case DeviceType.mobileLarge:
        return mobileLarge ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case DeviceType.tabletLarge:
        return tabletLarge ?? tablet ?? mobileLarge ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tabletLarge ?? tablet ?? mobileLarge ?? mobile;
      case DeviceType.desktopLarge:
      case DeviceType.desktopXLarge:
        return desktopLarge ?? desktop ?? tabletLarge ?? tablet ?? mobileLarge ?? mobile;
    }
  }

  /// Создать адаптивный виджет в зависимости от размера экрана
  static Widget buildAdaptive({
    required BuildContext context,
    required Widget mobile,
    Widget? mobileLarge,
    Widget? tablet,
    Widget? tabletLarge,
    Widget? desktop,
    Widget? desktopLarge,
  }) {
    return getAdaptiveValue(
      context: context,
      mobile: mobile,
      mobileLarge: mobileLarge,
      tablet: tablet,
      tabletLarge: tabletLarge,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }
}

/// Типы устройств для удобства использования
enum DeviceType {
  mobileMini,     // < 480px
  mobile,         // 480px - 600px
  mobileLarge,    // 600px - 768px
  tablet,         // 768px - 1024px
  tabletLarge,    // 1024px - 1200px
  desktop,        // 1200px - 1440px
  desktopLarge,   // 1440px - 1920px
  desktopXLarge,  // > 1920px
}

/// Расширения для MediaQuery для удобства работы с брейкпоинтами
extension MediaQueryBreakpoints on MediaQueryData {
  /// Получить тип устройства
  DeviceType get deviceType => AppBreakpoints.getDeviceType(size.width);

  /// Проверки размера экрана
  bool get isMobile => AppBreakpoints.isMobile(size.width);
  bool get isTablet => AppBreakpoints.isTablet(size.width);
  bool get isDesktop => AppBreakpoints.isDesktop(size.width);

  /// Дополнительные проверки
  bool get supportsMasterDetail => size.width >= AppBreakpoints.masterDetailBreakpoint;
  bool get needsSideNavigation => size.width >= AppBreakpoints.sidebarBreakpoint;
  bool get isCompactHeight => size.height < AppBreakpoints.compactHeight;
  bool get shouldUseCompactUI => size.width < AppBreakpoints.mobileLarge ||
                                 size.height < AppBreakpoints.minHeight;

  /// Получить количество колонок для сетки
  int get gridColumns => AppBreakpoints.getGridColumns(size.width);

  /// Получить максимальную ширину контента
  double get maxContentWidth => AppBreakpoints.getMaxContentWidth(size.width);

  /// Получить адаптивные отступы
  EdgeInsets get adaptivePadding => AppBreakpoints.getAdaptivePadding(size.width);
}

/// Расширения для BuildContext для еще более удобной работы
extension BuildContextBreakpoints on BuildContext {
  /// Быстрый доступ к MediaQuery
  MediaQueryData get mq => MediaQuery.of(this);

  /// Проверки размера экрана
  bool get isMobile => AppBreakpoints.isMobileForContext(this);
  bool get isTablet => AppBreakpoints.isTabletForContext(this);
  bool get isDesktop => AppBreakpoints.isDesktopForContext(this);

  /// Дополнительные проверки
  bool get supportsMasterDetail => AppBreakpoints.supportsMasterDetail(this);
  bool get needsSideNavigation => AppBreakpoints.needsSideNavigation(this);
  bool get isCompactHeight => AppBreakpoints.isCompactHeight(this);
  bool get shouldUseCompactUI => AppBreakpoints.shouldUseCompactUI(this);

  /// Получить адаптивное значение
  T adaptiveValue<T>({
    required T mobile,
    T? mobileLarge,
    T? tablet,
    T? tabletLarge,
    T? desktop,
    T? desktopLarge,
  }) {
    return AppBreakpoints.getAdaptiveValue(
      context: this,
      mobile: mobile,
      mobileLarge: mobileLarge,
      tablet: tablet,
      tabletLarge: tabletLarge,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }

  /// Построить адаптивный виджет
  Widget adaptiveWidget({
    required Widget mobile,
    Widget? mobileLarge,
    Widget? tablet,
    Widget? tabletLarge,
    Widget? desktop,
    Widget? desktopLarge,
  }) {
    return AppBreakpoints.buildAdaptive(
      context: this,
      mobile: mobile,
      mobileLarge: mobileLarge,
      tablet: tablet,
      tabletLarge: tabletLarge,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }
}