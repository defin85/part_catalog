import 'package:flutter/material.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Контекст использования иконки для определения размера
enum AdaptiveIconContext {
  /// Иконка в навигации
  navigation,
  /// Иконка в действиях (actions)
  action,
  /// Иконка в кнопке
  button,
  /// Иконка в списке
  list,
  /// Иконка в карточке
  card,
  /// Иконка в заголовке
  header,
  /// Иконка в tab bar
  tab,
  /// Иконка в floating action button
  fab,
  /// Иконка как аватар
  avatar,
  /// Декоративная иконка
  decorative,
  /// Кастомный размер
  custom,
}

/// Стиль иконки для разных состояний
enum AdaptiveIconState {
  /// Обычное состояние
  normal,
  /// Выбранное состояние
  selected,
  /// Отключенное состояние
  disabled,
  /// Состояние при наведении
  hovered,
  /// Состояние при нажатии
  pressed,
}

/// Конфигурация размеров иконки
class AdaptiveIconConfig {
  /// Размеры для разных экранов
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  /// Множители масштабирования
  final double? mobileScale;
  final double? tabletScale;
  final double? desktopScale;

  /// Ограничения размеров
  final double? minSize;
  final double? maxSize;

  /// Цвета для разных состояний
  final Color? normalColor;
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? hoveredColor;
  final Color? pressedColor;

  /// Анимации
  final Duration? animationDuration;
  final Curve? animationCurve;

  const AdaptiveIconConfig({
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
    this.mobileScale,
    this.tabletScale,
    this.desktopScale,
    this.minSize,
    this.maxSize,
    this.normalColor,
    this.selectedColor,
    this.disabledColor,
    this.hoveredColor,
    this.pressedColor,
    this.animationDuration,
    this.animationCurve,
  });

  /// Предустановленные конфигурации для разных контекстов
  static const AdaptiveIconConfig navigation = AdaptiveIconConfig(
    mobileSize: 24,
    tabletSize: 26,
    desktopSize: 28,
    minSize: 20,
    maxSize: 32,
    animationDuration: Duration(milliseconds: 200),
  );

  static const AdaptiveIconConfig action = AdaptiveIconConfig(
    mobileSize: 20,
    tabletSize: 22,
    desktopSize: 24,
    minSize: 18,
    maxSize: 28,
    animationDuration: Duration(milliseconds: 150),
  );

  static const AdaptiveIconConfig button = AdaptiveIconConfig(
    mobileSize: 18,
    tabletSize: 20,
    desktopSize: 22,
    minSize: 16,
    maxSize: 26,
    animationDuration: Duration(milliseconds: 100),
  );

  static const AdaptiveIconConfig list = AdaptiveIconConfig(
    mobileSize: 20,
    tabletSize: 22,
    desktopSize: 24,
    minSize: 18,
    maxSize: 28,
  );

  static const AdaptiveIconConfig card = AdaptiveIconConfig(
    mobileSize: 24,
    tabletSize: 28,
    desktopSize: 32,
    minSize: 20,
    maxSize: 40,
  );

  static const AdaptiveIconConfig header = AdaptiveIconConfig(
    mobileSize: 28,
    tabletSize: 32,
    desktopSize: 36,
    minSize: 24,
    maxSize: 48,
  );

  static const AdaptiveIconConfig tab = AdaptiveIconConfig(
    mobileSize: 20,
    tabletSize: 22,
    desktopSize: 24,
    minSize: 18,
    maxSize: 28,
    animationDuration: Duration(milliseconds: 200),
  );

  static const AdaptiveIconConfig fab = AdaptiveIconConfig(
    mobileSize: 24,
    tabletSize: 28,
    desktopSize: 32,
    minSize: 20,
    maxSize: 40,
    animationDuration: Duration(milliseconds: 150),
  );

  static const AdaptiveIconConfig avatar = AdaptiveIconConfig(
    mobileSize: 32,
    tabletSize: 40,
    desktopSize: 48,
    minSize: 24,
    maxSize: 64,
  );

  static const AdaptiveIconConfig decorative = AdaptiveIconConfig(
    mobileSize: 16,
    tabletSize: 18,
    desktopSize: 20,
    minSize: 12,
    maxSize: 24,
  );
}

/// Адаптивная иконка с размерами по контексту
class AdaptiveIcon extends StatefulWidget {
  final IconData iconData;
  final AdaptiveIconContext context;
  final AdaptiveIconState state;
  final AdaptiveIconConfig? config;
  final Color? color;
  final double? customSize;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showAnimation;
  final Widget? selectedIcon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showSplash;

  const AdaptiveIcon(
    this.iconData, {
    super.key,
    this.context = AdaptiveIconContext.action,
    this.state = AdaptiveIconState.normal,
    this.config,
    this.color,
    this.customSize,
    this.semanticLabel,
    this.textDirection,
    this.onTap,
    this.onLongPress,
    this.showAnimation = true,
    this.selectedIcon,
    this.padding,
    this.borderRadius,
    this.showSplash = true,
  });

  /// Конструктор для навигационной иконки
  const AdaptiveIcon.navigation(
    this.iconData, {
    super.key,
    this.state = AdaptiveIconState.normal,
    this.config,
    this.color,
    this.selectedIcon,
    this.onTap,
    this.semanticLabel,
  }) : context = AdaptiveIconContext.navigation,
       customSize = null,
       textDirection = null,
       onLongPress = null,
       showAnimation = true,
       padding = null,
       borderRadius = null,
       showSplash = true;

  /// Конструктор для иконки действия
  const AdaptiveIcon.action(
    this.iconData, {
    super.key,
    this.state = AdaptiveIconState.normal,
    this.config,
    this.color,
    this.onTap,
    this.semanticLabel,
    this.padding,
  }) : context = AdaptiveIconContext.action,
       customSize = null,
       textDirection = null,
       onLongPress = null,
       showAnimation = true,
       selectedIcon = null,
       borderRadius = null,
       showSplash = true;

  /// Конструктор для иконки в кнопке
  const AdaptiveIcon.button(
    this.iconData, {
    super.key,
    this.state = AdaptiveIconState.normal,
    this.config,
    this.color,
    this.onTap,
    this.semanticLabel,
  }) : context = AdaptiveIconContext.button,
       customSize = null,
       textDirection = null,
       onLongPress = null,
       showAnimation = true,
       selectedIcon = null,
       padding = null,
       borderRadius = null,
       showSplash = true;

  @override
  State<AdaptiveIcon> createState() => _AdaptiveIconState();
}

class _AdaptiveIconState extends State<AdaptiveIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    final config = widget.config ?? _getDefaultConfig();
    _animationController = AnimationController(
      duration: config.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: config.animationCurve ?? Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildIcon(context, ScreenSize.small),
      medium: (context, constraints) => _buildIcon(context, ScreenSize.medium),
      large: (context, constraints) => _buildIcon(context, ScreenSize.large),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  Widget _buildIcon(BuildContext context, ScreenSize screenSize) {
    final config = widget.config ?? _getDefaultConfig();
    final size = _calculateIconSize(screenSize, config);
    final effectiveColor = _getEffectiveColor(context, config);
    final isSelected = widget.state == AdaptiveIconState.selected;

    Widget icon = Icon(
      widget.iconData,
      size: size,
      color: effectiveColor,
      semanticLabel: widget.semanticLabel,
      textDirection: widget.textDirection,
    );

    // Показываем выбранную иконку если она есть и состояние выбрано
    if (isSelected && widget.selectedIcon != null) {
      icon = widget.selectedIcon!;
    }

    // Добавляем анимацию если включена
    if (widget.showAnimation) {
      icon = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: icon,
      );
    }

    // Добавляем padding если указан
    if (widget.padding != null) {
      icon = Padding(
        padding: widget.padding!,
        child: icon,
      );
    }

    // Добавляем интерактивность если есть обработчики
    if (widget.onTap != null || widget.onLongPress != null) {
      icon = _wrapWithInteraction(icon, config);
    }

    return icon;
  }

  Widget _wrapWithInteraction(Widget icon, AdaptiveIconConfig config) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.showAnimation) {
            setState(() => _isPressed = true);
            _animationController.forward();
          }
        },
        onTapUp: (_) {
          if (widget.showAnimation) {
            setState(() => _isPressed = false);
            _animationController.reverse();
          }
        },
        onTapCancel: () {
          if (widget.showAnimation) {
            setState(() => _isPressed = false);
            _animationController.reverse();
          }
        },
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: widget.showSplash
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  child: icon,
                ),
              )
            : icon,
      ),
    );
  }

  double _calculateIconSize(ScreenSize screenSize, AdaptiveIconConfig config) {
    if (widget.customSize != null) return widget.customSize!;

    double size;
    switch (screenSize) {
      case ScreenSize.small:
        size = config.mobileSize ?? 20;
        break;
      case ScreenSize.medium:
        size = config.tabletSize ?? config.mobileSize ?? 22;
        break;
      case ScreenSize.large:
        size = config.desktopSize ?? config.tabletSize ?? config.mobileSize ?? 24;
        break;
    }

    // Применяем ограничения
    if (config.minSize != null) size = size.clamp(config.minSize!, double.infinity);
    if (config.maxSize != null) size = size.clamp(0, config.maxSize!);

    return size;
  }

  Color? _getEffectiveColor(BuildContext context, AdaptiveIconConfig config) {
    if (widget.color != null) return widget.color;

    final theme = Theme.of(context);
    Color? color;

    // Определяем цвет по состоянию
    switch (widget.state) {
      case AdaptiveIconState.normal:
        color = config.normalColor;
        break;
      case AdaptiveIconState.selected:
        color = config.selectedColor ?? theme.colorScheme.primary;
        break;
      case AdaptiveIconState.disabled:
        color = config.disabledColor ?? theme.disabledColor;
        break;
      case AdaptiveIconState.hovered:
        color = config.hoveredColor ?? theme.colorScheme.primary.withValues(alpha: 0.8);
        break;
      case AdaptiveIconState.pressed:
        color = config.pressedColor ?? theme.colorScheme.primary.withValues(alpha: 0.6);
        break;
    }

    // Применяем состояния наведения и нажатия
    if (_isPressed && config.pressedColor != null) {
      color = config.pressedColor;
    } else if (_isHovered && config.hoveredColor != null) {
      color = config.hoveredColor;
    }

    return color ?? theme.iconTheme.color;
  }

  AdaptiveIconConfig _getDefaultConfig() {
    switch (widget.context) {
      case AdaptiveIconContext.navigation:
        return AdaptiveIconConfig.navigation;
      case AdaptiveIconContext.action:
        return AdaptiveIconConfig.action;
      case AdaptiveIconContext.button:
        return AdaptiveIconConfig.button;
      case AdaptiveIconContext.list:
        return AdaptiveIconConfig.list;
      case AdaptiveIconContext.card:
        return AdaptiveIconConfig.card;
      case AdaptiveIconContext.header:
        return AdaptiveIconConfig.header;
      case AdaptiveIconContext.tab:
        return AdaptiveIconConfig.tab;
      case AdaptiveIconContext.fab:
        return AdaptiveIconConfig.fab;
      case AdaptiveIconContext.avatar:
        return AdaptiveIconConfig.avatar;
      case AdaptiveIconContext.decorative:
        return AdaptiveIconConfig.decorative;
      case AdaptiveIconContext.custom:
        return const AdaptiveIconConfig();
    }
  }
}

/// Расширения для удобного использования
extension AdaptiveIconExtensions on IconData {
  /// Создает адаптивную навигационную иконку
  Widget asAdaptiveNavigationIcon({
    AdaptiveIconState state = AdaptiveIconState.normal,
    Color? color,
    Widget? selectedIcon,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return AdaptiveIcon.navigation(
      this,
      state: state,
      color: color,
      selectedIcon: selectedIcon,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }

  /// Создает адаптивную иконку действия
  Widget asAdaptiveActionIcon({
    AdaptiveIconState state = AdaptiveIconState.normal,
    Color? color,
    VoidCallback? onTap,
    String? semanticLabel,
    EdgeInsetsGeometry? padding,
  }) {
    return AdaptiveIcon.action(
      this,
      state: state,
      color: color,
      onTap: onTap,
      semanticLabel: semanticLabel,
      padding: padding,
    );
  }

  /// Создает адаптивную иконку для кнопки
  Widget asAdaptiveButtonIcon({
    AdaptiveIconState state = AdaptiveIconState.normal,
    Color? color,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return AdaptiveIcon.button(
      this,
      state: state,
      color: color,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }

  /// Создает адаптивную иконку с кастомными параметрами
  Widget asAdaptiveIcon({
    AdaptiveIconContext context = AdaptiveIconContext.action,
    AdaptiveIconState state = AdaptiveIconState.normal,
    AdaptiveIconConfig? config,
    Color? color,
    double? customSize,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return AdaptiveIcon(
      this,
      context: context,
      state: state,
      config: config,
      color: color,
      customSize: customSize,
      onTap: onTap,
      semanticLabel: semanticLabel,
    );
  }
}