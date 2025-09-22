import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Режим адаптации размеров контейнера
enum AdaptiveSizeMode {
  /// Фиксированные размеры для каждого breakpoint
  fixed,
  /// Пропорциональные размеры от экрана
  proportional,
  /// Гибридный режим с ограничениями
  hybrid,
  /// Автоматический размер по содержимому
  content,
}

/// Конфигурация размеров для разных экранов
class AdaptiveSizeConfig {
  final double? mobileWidth;
  final double? mobileHeight;
  final double? tabletWidth;
  final double? tabletHeight;
  final double? desktopWidth;
  final double? desktopHeight;

  /// Пропорциональные размеры (0.0 - 1.0)
  final double? mobileWidthFactor;
  final double? mobileHeightFactor;
  final double? tabletWidthFactor;
  final double? tabletHeightFactor;
  final double? desktopWidthFactor;
  final double? desktopHeightFactor;

  /// Ограничения размеров
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;

  const AdaptiveSizeConfig({
    // Фиксированные размеры
    this.mobileWidth,
    this.mobileHeight,
    this.tabletWidth,
    this.tabletHeight,
    this.desktopWidth,
    this.desktopHeight,
    // Пропорциональные размеры
    this.mobileWidthFactor,
    this.mobileHeightFactor,
    this.tabletWidthFactor,
    this.tabletHeightFactor,
    this.desktopWidthFactor,
    this.desktopHeightFactor,
    // Ограничения
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  /// Предустановленная конфигурация для карточек
  static const AdaptiveSizeConfig card = AdaptiveSizeConfig(
    mobileWidthFactor: 1.0,
    tabletWidthFactor: 0.8,
    desktopWidthFactor: 0.6,
    maxWidth: 600,
    minWidth: 300,
  );

  /// Предустановленная конфигурация для модальных окон
  static const AdaptiveSizeConfig modal = AdaptiveSizeConfig(
    mobileWidthFactor: 0.9,
    mobileHeightFactor: 0.8,
    tabletWidthFactor: 0.7,
    tabletHeightFactor: 0.7,
    desktopWidthFactor: 0.5,
    desktopHeightFactor: 0.6,
    maxWidth: 800,
    maxHeight: 600,
    minWidth: 320,
    minHeight: 200,
  );

  /// Предустановленная конфигурация для форм
  static const AdaptiveSizeConfig form = AdaptiveSizeConfig(
    mobileWidthFactor: 1.0,
    tabletWidthFactor: 0.75,
    desktopWidth: 480,
    maxWidth: 600,
    minWidth: 320,
  );

  /// Предустановленная конфигурация для боковых панелей
  static const AdaptiveSizeConfig sidebar = AdaptiveSizeConfig(
    mobileWidth: 280,
    tabletWidth: 320,
    desktopWidth: 360,
    maxWidth: 400,
    minWidth: 240,
  );
}

/// Адаптивный контейнер с динамическими размерами
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final AdaptiveSizeMode sizeMode;
  final AdaptiveSizeConfig sizeConfig;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;
  final Color? color;
  final Decoration? decoration;
  final double? customWidth;
  final double? customHeight;
  final bool maintainAspectRatio;
  final double? aspectRatio;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.sizeMode = AdaptiveSizeMode.hybrid,
    this.sizeConfig = AdaptiveSizeConfig.card,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
    this.color,
    this.decoration,
    this.customWidth,
    this.customHeight,
    this.maintainAspectRatio = false,
    this.aspectRatio,
  });

  /// Конструктор для карточки
  const AdaptiveContainer.card({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
  }) : sizeMode = AdaptiveSizeMode.hybrid,
       sizeConfig = AdaptiveSizeConfig.card,
       alignment = Alignment.center,
       customWidth = null,
       customHeight = null,
       maintainAspectRatio = false,
       aspectRatio = null;

  /// Конструктор для модального окна
  const AdaptiveContainer.modal({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
  }) : sizeMode = AdaptiveSizeMode.hybrid,
       sizeConfig = AdaptiveSizeConfig.modal,
       alignment = Alignment.center,
       customWidth = null,
       customHeight = null,
       maintainAspectRatio = false,
       aspectRatio = null;

  /// Конструктор для формы
  const AdaptiveContainer.form({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
  }) : sizeMode = AdaptiveSizeMode.hybrid,
       sizeConfig = AdaptiveSizeConfig.form,
       alignment = Alignment.topCenter,
       customWidth = null,
       customHeight = null,
       maintainAspectRatio = false,
       aspectRatio = null;

  /// Конструктор для боковой панели
  const AdaptiveContainer.sidebar({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
  }) : sizeMode = AdaptiveSizeMode.fixed,
       sizeConfig = AdaptiveSizeConfig.sidebar,
       alignment = Alignment.topLeft,
       customWidth = null,
       customHeight = null,
       maintainAspectRatio = false,
       aspectRatio = null;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildContainer(context, constraints, ScreenSize.small),
      medium: (context, constraints) => _buildContainer(context, constraints, ScreenSize.medium),
      large: (context, constraints) => _buildContainer(context, constraints, ScreenSize.large),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  Widget _buildContainer(BuildContext context, BoxConstraints constraints, ScreenSize screenSize) {
    final calculatedSize = _calculateSize(constraints, screenSize);

    Widget container = Container(
      width: calculatedSize.width,
      height: calculatedSize.height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      color: color,
      decoration: decoration,
      child: maintainAspectRatio && aspectRatio != null
          ? AspectRatio(aspectRatio: aspectRatio!, child: child)
          : child,
    );

    // Добавляем ограничения если нужно
    if (sizeConfig.minWidth != null || sizeConfig.maxWidth != null ||
        sizeConfig.minHeight != null || sizeConfig.maxHeight != null) {
      container = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: sizeConfig.minWidth ?? 0,
          maxWidth: sizeConfig.maxWidth ?? double.infinity,
          minHeight: sizeConfig.minHeight ?? 0,
          maxHeight: sizeConfig.maxHeight ?? double.infinity,
        ),
        child: container,
      );
    }

    return container;
  }

  Size _calculateSize(BoxConstraints constraints, ScreenSize screenSize) {
    double? width = customWidth;
    double? height = customHeight;

    switch (sizeMode) {
      case AdaptiveSizeMode.fixed:
        final fixedSize = _getFixedSize(screenSize);
        width ??= fixedSize.width;
        height ??= fixedSize.height;
        break;

      case AdaptiveSizeMode.proportional:
        final proportionalSize = _getProportionalSize(constraints, screenSize);
        width ??= proportionalSize.width;
        height ??= proportionalSize.height;
        break;

      case AdaptiveSizeMode.hybrid:
        final hybridSize = _getHybridSize(constraints, screenSize);
        width ??= hybridSize.width;
        height ??= hybridSize.height;
        break;

      case AdaptiveSizeMode.content:
        // Размер по содержимому (null = auto)
        break;
    }

    // ИСПРАВЛЕНИЕ: Проверяем на бесконечную высоту
    final safeHeight = constraints.maxHeight.isInfinite ? null : constraints.maxHeight;

    // Если высота равна 0 (не задана), используем null для автоматического размера
    final finalHeight = height == 0 ? null : height;

    return Size(width ?? constraints.maxWidth, finalHeight ?? (safeHeight ?? 0));
  }

  Size _getFixedSize(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return Size(
          sizeConfig.mobileWidth ?? double.infinity,
          sizeConfig.mobileHeight ?? 0,
        );
      case ScreenSize.medium:
        return Size(
          sizeConfig.tabletWidth ?? sizeConfig.mobileWidth ?? double.infinity,
          sizeConfig.tabletHeight ?? sizeConfig.mobileHeight ?? 0,
        );
      case ScreenSize.large:
        return Size(
          sizeConfig.desktopWidth ?? sizeConfig.tabletWidth ?? sizeConfig.mobileWidth ?? double.infinity,
          sizeConfig.desktopHeight ?? sizeConfig.tabletHeight ?? sizeConfig.mobileHeight ?? 0,
        );
    }
  }

  Size _getProportionalSize(BoxConstraints constraints, ScreenSize screenSize) {
    double? widthFactor;
    double? heightFactor;

    switch (screenSize) {
      case ScreenSize.small:
        widthFactor = sizeConfig.mobileWidthFactor;
        heightFactor = sizeConfig.mobileHeightFactor;
        break;
      case ScreenSize.medium:
        widthFactor = sizeConfig.tabletWidthFactor ?? sizeConfig.mobileWidthFactor;
        heightFactor = sizeConfig.tabletHeightFactor ?? sizeConfig.mobileHeightFactor;
        break;
      case ScreenSize.large:
        widthFactor = sizeConfig.desktopWidthFactor ??
                     sizeConfig.tabletWidthFactor ??
                     sizeConfig.mobileWidthFactor;
        heightFactor = sizeConfig.desktopHeightFactor ??
                      sizeConfig.tabletHeightFactor ??
                      sizeConfig.mobileHeightFactor;
        break;
    }

    return Size(
      widthFactor != null ? constraints.maxWidth * widthFactor : double.infinity,
      heightFactor != null ? constraints.maxHeight * heightFactor : double.infinity,
    );
  }

  Size _getHybridSize(BoxConstraints constraints, ScreenSize screenSize) {
    // Сначала пробуем фиксированные размеры
    final fixedSize = _getFixedSize(screenSize);
    double width = fixedSize.width;
    double height = fixedSize.height;

    // Если фиксированного размера нет, используем пропорциональный
    if (width == double.infinity) {
      final proportionalSize = _getProportionalSize(constraints, screenSize);
      width = proportionalSize.width;
    }

    if (height == double.infinity) {
      final proportionalSize = _getProportionalSize(constraints, screenSize);
      height = proportionalSize.height;
    }

    // Применяем ограничения
    if (sizeConfig.minWidth != null) width = width.clamp(sizeConfig.minWidth!, double.infinity);
    if (sizeConfig.maxWidth != null) width = width.clamp(0, sizeConfig.maxWidth!);
    if (sizeConfig.minHeight != null) height = height.clamp(sizeConfig.minHeight!, double.infinity);
    if (sizeConfig.maxHeight != null) height = height.clamp(0, sizeConfig.maxHeight!);

    return Size(width, height);
  }
}

/// Расширения для удобного использования
extension AdaptiveContainerExtensions on Widget {
  /// Оборачивает виджет в AdaptiveContainer.card
  Widget asAdaptiveCard({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
  }) {
    return AdaptiveContainer.card(
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      child: this,
    );
  }

  /// Оборачивает виджет в AdaptiveContainer.modal
  Widget asAdaptiveModal({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
  }) {
    return AdaptiveContainer.modal(
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      child: this,
    );
  }

  /// Оборачивает виджет в AdaptiveContainer.form
  Widget asAdaptiveForm({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
  }) {
    return AdaptiveContainer.form(
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      child: this,
    );
  }
}